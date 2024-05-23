// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Munchkins is ERC20, ERC20Burnable, Ownable {
    uint256 private _burnRate = 1; // Burn rate of 1%
    uint256 private _totalSupply = 1000000 * 10 ** 18; // Total supply of 1,000,000 Munchkins

    constructor(
        address initialOwner
    ) ERC20("Munchkins", "MUNCH") Ownable(initialOwner) {
        _mint(initialOwner, _totalSupply);
    }

    function burnRate() public view returns (uint256) {
        return _burnRate;
    }

    function setBurnRate(uint256 newRate) external onlyOwner {
        require(newRate <= 100, "Burn rate cannot exceed 100%");
        _burnRate = newRate;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        uint256 burnAmount = (amount * _burnRate) / 100;
        uint256 sendAmount = amount - burnAmount;

        super._burn(sender, burnAmount);
        super._transfer(sender, recipient, sendAmount);
    }
}
