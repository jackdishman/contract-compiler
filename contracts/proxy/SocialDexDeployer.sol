// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {TickMath} from "./uniswap/TickMath.sol";
import {INonfungiblePositionManager, IUniswapV3Factory, ILockerFactory, ILocker, ExactInputSingleParams, ISwapRouter} from "./interface.sol";
import {Bytes32AddressLib} from "./Bytes32AddressLib.sol";

// Interface for the ReferralContract to access the isComplete variable
interface IReferralContract {
    function isComplete() external view returns (bool);
}

contract Token is ERC20 {
    address public referralContract;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupply_,
        address _referralContract
    ) ERC20(name_, symbol_) {
        _mint(msg.sender, maxSupply_);
        referralContract = _referralContract;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }
}

contract SocialDexDeployer is Ownable {
    using TickMath for int24;
    using Bytes32AddressLib for bytes32;

    address public taxCollector;
    uint64 public defaultLockingPeriod = 33275115461;
    uint8 public taxRate = 25; // 2.5%
    uint8 public lpFeesCut = 50; // 5%
    uint8 public protocolCut = 30; // 3%
    ILockerFactory public liquidityLocker;

    address public weth;
    IUniswapV3Factory public uniswapV3Factory;
    INonfungiblePositionManager public positionManager;
    address public swapRouter;

    event TokenCreated(
        address tokenAddress,
        uint256 lpNftId,
        address deployer,
        string name,
        string symbol,
        uint256 supply,
        uint256 _supply,
        address lockerAddress,
        address referralContract
    );

    constructor(
        address taxCollector_,
        address weth_,
        address locker_,
        address uniswapV3Factory_,
        address positionManager_,
        uint64 defaultLockingPeriod_,
        address swapRouter_
    ) Ownable(msg.sender) {
        taxCollector = taxCollector_;
        weth = weth_;
        liquidityLocker = ILockerFactory(locker_);
        uniswapV3Factory = IUniswapV3Factory(uniswapV3Factory_);
        positionManager = INonfungiblePositionManager(positionManager_);
        defaultLockingPeriod = defaultLockingPeriod_;
        swapRouter = swapRouter_;
    }

    function deployToken(
        string calldata _name,
        string calldata _symbol,
        uint256 _supply,
        int24 _initialTick,
        uint24 _fee,
        bytes32 _salt,
        address _deployer,
        address _referralContract
    ) external payable returns (Token token, uint256 tokenId) {
        // Check that the referralContract is complete
        require(
            IReferralContract(_referralContract).isComplete(),
            "Referral contract is not complete"
        );

        int24 tickSpacing = uniswapV3Factory.feeAmountTickSpacing(_fee);
        require(
            tickSpacing != 0 && _initialTick % tickSpacing == 0,
            "Invalid tick"
        );

        token = new Token{salt: keccak256(abi.encode(msg.sender, _salt))}(
            _name,
            _symbol,
            _supply,
            _referralContract
        );

        require(address(token) < weth, "Invalid salt");
        require(_supply >= _supply, "Invalid supply amount");

        uint160 sqrtPriceX96 = TickMath.getSqrtPriceAtTick(_initialTick);
        address pool = uniswapV3Factory.createPool(address(token), weth, _fee);
        IUniswapV3Factory(pool).initialize(sqrtPriceX96);

        INonfungiblePositionManager.MintParams
            memory params = INonfungiblePositionManager.MintParams(
                address(token),
                weth,
                _fee,
                _initialTick,
                maxUsableTick(tickSpacing),
                _supply,
                0,
                0,
                0,
                address(this),
                block.timestamp
            );

        token.approve(address(positionManager), _supply);
        (tokenId, , , ) = positionManager.mint(params);

        address lockerAddress = liquidityLocker.deploy(
            address(positionManager),
            _deployer,
            defaultLockingPeriod,
            tokenId,
            lpFeesCut
        );

        positionManager.safeTransferFrom(address(this), lockerAddress, tokenId);
        ILocker(lockerAddress).initializer(tokenId);

        uint256 protocolFees = (msg.value * protocolCut) / 1000;
        uint256 remainingFundsToBuyTokens = msg.value - protocolFees;

        if (msg.value > 0) {
            ExactInputSingleParams memory swapParams = ExactInputSingleParams({
                tokenIn: weth,
                tokenOut: address(token),
                fee: _fee,
                recipient: msg.sender,
                amountIn: remainingFundsToBuyTokens,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

            ISwapRouter(swapRouter).exactInputSingle{
                value: remainingFundsToBuyTokens
            }(swapParams);
        }

        (bool success, ) = payable(taxCollector).call{value: protocolFees}("");
        require(success, "Failed to send protocol fees");

        emit TokenCreated(
            address(token),
            tokenId,
            msg.sender,
            _name,
            _symbol,
            _supply,
            _supply,
            lockerAddress,
            _referralContract
        );
    }

    // Other functions as in the original contract
}

/// @notice Given a tickSpacing, compute the maximum usable tick
function maxUsableTick(int24 tickSpacing) pure returns (int24) {
    unchecked {
        return (TickMath.MAX_TICK / tickSpacing) * tickSpacing;
    }
}
