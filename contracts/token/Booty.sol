// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// MyToken extends the ERC20 standard with burnable functionality and is Ownable
contract BootyToken is ERC20, ERC20Burnable {

    address public owner;

    constructor(uint256 initialSupply) ERC20("Booty", "OO") {
        _mint(msg.sender, initialSupply);
        owner = msg.sender;
    }

    // Mint function that can only be called by the owner of the contract
    function mint(address to, uint256 amount) public {
        require(msg.sender == owner, "You are not the owner");
        _mint(to, amount);
    }

    // Transfer ownership of the contract to a new address
    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "You are not the owner");
        owner = newOwner;
    }
}
