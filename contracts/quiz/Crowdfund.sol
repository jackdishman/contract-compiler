// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Crowdfunding is Ownable {
    address public recipient;
    address public paymentTokenAddress; // USDC token address on Base network
    AggregatorV3Interface internal priceFeed; // Price feed for ETH to USD

    uint256 public ethRaised;
    uint256 public usdcRaised;
    uint256 public targetAmountInUSD;
    uint256 public deadline;

    event ContributionETH(address indexed contributor, uint256 amount);
    event ContributionUSDC(address indexed contributor, uint256 amount);

    constructor(
        uint256 _targetAmountInUSD,
        uint256 _deadline,
        address _recipient,
        address _paymentTokenAddress,
        address _priceFeedAddress // Chainlink ETH/USD price feed on Base
    ) {
        recipient = _recipient;
        paymentTokenAddress = _paymentTokenAddress;
        targetAmountInUSD = _targetAmountInUSD;
        deadline = _deadline;
        priceFeed = AggregatorV3Interface(_priceFeedAddress); // Initialize price feed (ETH/USD)
    }

    // Allows a user to contribute in ETH, sent immediately to the recipient
    function contributeETH() external payable {
        require(msg.value > 0, "Contribution must be greater than 0");
        require(block.timestamp <= deadline || deadline == 0, "Campaign has expired.");

        ethRaised += msg.value;
        payable(recipient).transfer(msg.value); // Transfer ETH directly to the recipient

        emit ContributionETH(msg.sender, msg.value);
    }

    // Allows a user to contribute in USDC, sent immediately to the recipient
    function contributeUSDC(uint256 amount) external {
        require(amount > 0, "Contribution must be greater than 0");
        require(block.timestamp <= deadline || deadline == 0, "Campaign has expired.");

        _safeTransferFrom(paymentTokenAddress, msg.sender, recipient, amount);
        usdcRaised += amount;

        emit ContributionUSDC(msg.sender, amount);
    }

    // Admin can set the target amount in USD
    function setTargetAmount(uint256 _targetAmountInUSD) external onlyOwner {
        targetAmountInUSD = _targetAmountInUSD;
    }

    // Admin can set the deadline for the campaign
    function setDeadline(uint256 _deadline) external onlyOwner {
        deadline = _deadline;
    }

    // Get the current ETH price in USD (Chainlink oracle)
    function getEthPriceInUSD() public view returns (uint256) {
        (, int256 price, , ,) = priceFeed.latestRoundData();
        return uint256(price) * 1e10; // Adjust to 18 decimals
    }

    // Calculate the total amount raised in USD by converting ETH to USD using Chainlink
    function totalRaisedInUSD() public view returns (uint256) {
        uint256 ethRaisedInUSD = (ethRaised * getEthPriceInUSD()) / 1e18;
        return ethRaisedInUSD + usdcRaised; // Combine ETH (converted) and USDC amounts
    }

    // Fallback function to handle receiving ETH directly
    receive() external payable {
        contributeETH();
    }

    // Safely transfer tokens from one address to another
    function _safeTransferFrom(
        address token,
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(
                IERC20.transferFrom.selector,
                sender,
                recipient,
                amount
            )
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Transfer failed");
    }
}
