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
        address _priceFeedAddress
    ) Ownable(msg.sender) {
        recipient = _recipient;
        paymentTokenAddress = _paymentTokenAddress;
        targetAmountInUSD = _targetAmountInUSD;
        deadline = _deadline;
        priceFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    // Contribute ETH directly
    function contributeETH() public payable {
        require(msg.value > 0, "Contribution must be greater than 0");
        require(block.timestamp <= deadline || deadline == 0, "Campaign has expired.");

        ethRaised += msg.value;
        payable(recipient).transfer(msg.value); // Transfer ETH directly to the recipient

        emit ContributionETH(msg.sender, msg.value);
    }

    // Contribute USDC
    function contributeUSDC(uint256 amount) external {
        require(amount > 0, "Contribution must be greater than 0");
        require(block.timestamp <= deadline || deadline == 0, "Campaign has expired.");

        IERC20(paymentTokenAddress).transferFrom(msg.sender, recipient, amount);
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
        require(price > 0, "Invalid price data"); // Ensure we don't get a negative or zero price
        return uint256(price); // Price is already in 8 decimals, no need to adjust further
    }

    // Calculate the total amount raised in USD, returning a value in dollars (with 2 decimal places)
    function totalRaisedInUSD() public view returns (uint256) {
        uint256 ethPriceInUSD = getEthPriceInUSD(); // ETH price from Chainlink with 8 decimals
        uint256 ethRaisedInUSD = (ethRaised * ethPriceInUSD) / 1e18; // Convert ETH (18 decimals) to USD
        uint256 totalUSD = ethRaisedInUSD + usdcRaised; // Combine ETH (converted) and USDC amounts

        // Convert the total raised to a 2-decimal USD format
        return totalUSD / 1e6; // Dividing by 1e6 to convert to standard USD with 2 decimal places
    }

    // Fallback function to handle receiving ETH directly
    receive() external payable {
        contributeETH();
    }
}
