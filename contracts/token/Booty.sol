// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract BootyToken is ERC20, ERC20Burnable, Ownable {
    uint32 public hourlyRate;
    uint32 public multiplier;
    uint256 private constant SCALING_FACTOR = 1000; // Defines the precision of the multiplier
    uint256 private constant MINUTES_IN_HOUR = 60;

    event TransferWithMessage(address indexed from, address indexed to, uint256 value, string message);
    event WelcomeTokensIssued(address indexed to, uint256 amount);
    event HourlyRateAdjusted(uint32 newRate);
    event MultiplierAdjusted(uint32 newMultiplier);
    event Minted(address indexed to, uint256 amount, string message);

    constructor(
        address initialOwner,
        string memory name,
        string memory symbol,
        uint32 _hourlyRate,
        uint32 _multiplier // Note: _multiplier should now be scaled by SCALING_FACTOR
    ) ERC20(name, symbol)
        Ownable(initialOwner) {
        hourlyRate = _hourlyRate;
        multiplier = _multiplier;
    }

    function transferWithMessage(address to, uint256 amount, string memory message) public returns (bool) {
        _transfer(_msgSender(), to, amount);
        emit TransferWithMessage(_msgSender(), to, amount, message);
        return true;
    }

    function adjustHourlyRate(uint32 _newRate) public onlyOwner {
        hourlyRate = _newRate;
        emit HourlyRateAdjusted(_newRate);
    }

    // Adjust the multiplier by scaling it by SCALING_FACTOR
    function adjustMultiplier(uint32 _newMultiplier) public onlyOwner {
        multiplier = _newMultiplier;
        emit MultiplierAdjusted(_newMultiplier);
    }

    function getConversionRate(uint256 amount) public view returns (uint256) {
        uint256 safeMultiplier = uint256(multiplier);
        return amount * hourlyRate * safeMultiplier / (MINUTES_IN_HOUR * SCALING_FACTOR);
    }

    // @dev: Mint new tokens to an address
    // @params: to - the address to mint tokens to
    // @params: amount - the amount of minutes to be compensated for
    // @params: message - reason or description for reward
    function mint(address to, uint256 amount, string memory message) public onlyOwner {
        uint256 safeMultiplier = uint256(multiplier);
        // Adjust the calculation to account for the SCALING_FACTOR
        uint256 newTokens = amount * hourlyRate * safeMultiplier / (MINUTES_IN_HOUR * SCALING_FACTOR);
        _mint(to, newTokens);
        string memory formattedMessage = string(abi.encodePacked(message, " (", newTokens, " tokens at ", hourlyRate, " per hour with a multiplier of ", safeMultiplier, ")"));
        emit Minted(to, newTokens, formattedMessage);
    }

    function issueWelcomeTokens(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        emit WelcomeTokensIssued(to, amount);
    }
}
