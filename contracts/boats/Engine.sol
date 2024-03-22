// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./utils/Ownable.sol";

contract Engine is Ownable {
    uint public horsePower;
    string public brand;
    uint public engineYear;

    constructor(address initialOwner, uint _horsePower, string memory _brand, uint _engineYear) Ownable (initialOwner) {
        horsePower = _horsePower;
        brand = _brand;
        engineYear = _engineYear;
    }

    function setEngineDetails(uint _horsePower, string memory _brand, uint _engineYear) public onlyOwner {
        horsePower = _horsePower;
        brand = _brand;
        engineYear = _engineYear;
    }

    function getEngineDetails() public view returns (uint, string memory, uint) {
        return (horsePower, brand, engineYear);
    }
}
