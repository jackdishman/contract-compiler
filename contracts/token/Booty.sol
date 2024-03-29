// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// MyToken extends the ERC20 standard with burnable functionality
contract MyToken is ERC20, ERC20Burnable {
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        _mint(msg.sender, initialSupply);
    }

    // Example of adding custom functionality: A function that increases supply.
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
