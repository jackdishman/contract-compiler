// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Engine is OwnableUpgradeable {
    uint public horsePower;
    string public brand;
    uint public engineYear;

    function initialize(uint _horsePower, string memory _brand, uint _engineYear) public initializer {
        __Ownable_init(msg.sender);
        horsePower = _horsePower;
        brand = _brand;
        engineYear = _engineYear;
    }
}
