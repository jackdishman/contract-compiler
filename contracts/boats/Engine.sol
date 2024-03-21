// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Engine {
    uint public horsePower;
    string public brand;
    uint public engineYear;

    constructor(uint _horsePower, string memory _brand, uint _engineYear) {
        horsePower = _horsePower;
        brand = _brand;
        engineYear = _engineYear;
    }

    function setEngineDetails(uint _horsePower, string memory _brand, uint _engineYear) public {
        horsePower = _horsePower;
        brand = _brand;
        engineYear = _engineYear;
    }

    function getEngineDetails() public view returns (uint, string memory, uint) {
        return (horsePower, brand, engineYear);
    }
}
