// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Boat is Ownable {
    string public name;
    string public manufacturer;
    string public hullType;
    uint public year;
    uint public length;
    string public HIN;
    bool public isStolen;
    string public location;

    string public metadata;

    // Event definitions
    event NameChanged(string newName);
    event ChangedLocation(string newLocation);
    event MarkedStolen(bool isStolen);
    event MetadataChanged(string newMetadata);

    constructor(
        address initialOwner,
        string memory _name,
        string memory _manufacturer,
        string memory _hullType,
        uint _year,
        uint _length,
        string memory _metadata,
        string memory _location
    ) Ownable(initialOwner) {
        name = _name;
        manufacturer = _manufacturer;
        hullType = _hullType;
        year = _year;
        length = _length;
        metadata = _metadata;
        location = _location;
    }

    function setName(string memory _name) public onlyOwner {
        name = _name;
        emit NameChanged(_name);
    }

    function markStolen(bool _isStolen) public onlyOwner {
        isStolen = _isStolen;
        emit MarkedStolen(_isStolen);
    }

    function setHIN(string memory _HIN) public onlyOwner {
        require(bytes(HIN).length == 0, "HIN already set");
        HIN = _HIN;
    }

    function setLocation(string memory _location) public onlyOwner {
        location = _location;
        emit ChangedLocation(_location);
    }

    function setMetadata(string memory _metadata) public onlyOwner {
        metadata = _metadata;
        emit MetadataChanged(_metadata);
    }
}
