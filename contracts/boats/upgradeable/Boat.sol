// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Boat is OwnableUpgradeable {
    string public name;
    string public manufacturer;
    uint public year;
    uint public length;
    string[] public images;

    function initialize(string memory _name, string memory _manufacturer, uint _year, uint _length, string[] memory _images) public initializer {
        __Ownable_init(msg.sender);
        name = _name;
        manufacturer = _manufacturer;
        year = _year;
        length = _length;
        images = _images;
    }
}
