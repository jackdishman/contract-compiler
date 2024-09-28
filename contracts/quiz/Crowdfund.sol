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

    address[] public contributors; // Array to store all contributors
    mapping(address => uint256) public contributionsETH; // Mapping to track ETH contributions per address
    mapping(address => uint256) public contributionsUSDC; // Mapping to track USDC contributions per address

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

    // Add contributor if they haven't contributed before
    function _addContributor(address _contributor) internal {
        if (contributionsETH[_contributor] == 0 && contributionsUSDC[_contributor] == 0) {
            contributors.push(_contributor);
        }
    }

    // Contribute ETH directly
    function contributeETH() public payable {
        require(msg.value > 0, "Contribution must be greater than 0");
        require(block.timestamp <= deadline || deadline == 0, "Campaign has expired.");

        ethRaised += msg.value;
        _addContributor(msg.sender); // Add the contributor to the list if not already added
        contributionsETH[msg.sender] += msg.value; // Track their ETH contribution
        payable(recipient).transfer(msg.value); // Transfer ETH directly to the recipient

        emit ContributionETH(msg.sender, msg.value);
    }

    // Contribute USDC and transfer it directly to the recipient
    function contributeUSDC(uint256 amount) external {
        require(amount > 0, "Contribution must be greater than 0");
        require(block.timestamp <= deadline || deadline == 0, "Campaign has expired.");
        
        // Ensure the contributor has approved the contract to spend USDC on their behalf
        IERC20(paymentTokenAddress).transferFrom(msg.sender, recipient, amount);

        usdcRaised += amount;
        _addContributor(msg.sender); // Add the contributor to the list if not already added
        contributionsUSDC[msg.sender] += amount; // Track their USDC contribution

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
        uint256 ethRaisedInUSD = (ethRaised * ethPriceInUSD) / 1e20; // Adjusted denominator

        uint256 totalUSD = ethRaisedInUSD + usdcRaised; // Both in USD * 1e6 units

        // Divide by 1e4 to get total raised in USD with 2 decimal places
        return totalUSD / 1e4;
    }

    // Return the list of all contributors
    function getContributors() public view returns (address[] memory) {
        return contributors;
    }

    // Get each contributor's total contributions in USD
    function getContributorTotalInUSD() public view returns (uint256[] memory) {
        uint256 contributorCount = contributors.length;
        uint256[] memory totalContributions = new uint256[](contributorCount);

        for (uint256 i = 0; i < contributorCount; i++) {
            address contributor = contributors[i];

            // Adjusted denominator to 1e20 to get ethContributionInUSD in USD * 1e6 units
            uint256 ethContributionInUSD = (contributionsETH[contributor] * getEthPriceInUSD()) / 1e20;

            uint256 usdcContribution = contributionsUSDC[contributor]; // Already in USD * 1e6 units

            // Divide by 1e4 to get total contributions in USD with 2 decimal places
            totalContributions[i] = (ethContributionInUSD + usdcContribution) / 1e4;
        }

        return totalContributions;
    }

    // Fallback function to handle receiving ETH directly
    receive() external payable {
        contributeETH();
    }
}
