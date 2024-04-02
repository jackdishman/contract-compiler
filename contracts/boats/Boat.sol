// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./utils/Ownable.sol";
import "./Image.sol";
import "./Record.sol";

contract Boat is Ownable {
    string public name;
    string public manufacturer;
    string public hullType;
    uint public year;
    uint public length;
    string public HIN;
    bool public isStolen;

    // Event definitions
    event NameChanged(string newName);
    event ImageAdded(uint index, string url, string label);
    event ImageRemoved(uint index);
    event RecordAdded(uint index, string title, string description, string data, string kind);
    event RecordRemoved(uint index);
    event MarkedStolen(bool isStolen);

    mapping(uint => Image) public images;
    uint public imageCount;

    mapping(uint => Record) private records;
    uint private recordCount;

    constructor(
        address initialOwner,
        string memory _name, 
        string memory _manufacturer, 
        string memory _hullType,
        uint _year, 
        uint _length
    ) Ownable(initialOwner) { 
        name = _name;
        manufacturer = _manufacturer;
        hullType = _hullType;
        year = _year;
        length = _length;
    }

    // Ensure only the owner can modify the boat's details
    function setName(string memory _name) public onlyOwner {
        name = _name;
        emit NameChanged(_name);
    }

    // add a new image
    function addImage(string memory _url, string memory _label) public onlyOwner {
        images[imageCount] = new Image(_url, _label);
        emit ImageAdded(imageCount, _url, _label);
        imageCount++;
    }

    // remove an image by index
    function removeImage(uint _index) public onlyOwner {
        require(_index < imageCount, "Index out of bounds");
        for (uint i = _index; i < imageCount - 1; i++) {
            images[i] = images[i + 1];
        }
        emit ImageRemoved(_index);
        imageCount--;
    }

    // Get all images of the boat
    function getImages() public view returns (Image[] memory) {
        Image[] memory _images = new Image[](imageCount);
        for (uint i = 0; i < imageCount; i++) {
            _images[i] = images[i];
        }
        return _images;
    }

    // add a new record
    function addRecord(string memory _title, string memory _description, string memory _data, string memory _kind) public onlyOwner {
        records[recordCount] = new Record(_title, _description, _data, _kind);
        emit RecordAdded(recordCount, _title, _description, _data, _kind);
        recordCount++;
    }

    // remove a record by index
    function removeRecord(uint _index) public onlyOwner {
        require(_index < recordCount, "Index out of bounds");
        for (uint i = _index; i < recordCount - 1; i++) {
            records[i] = records[i + 1];
        }
        emit RecordRemoved(_index);
        recordCount--;
    }

    // Get all records of the boat
    function getRecords() public view onlyOwner returns (Record[] memory) {
        Record[] memory _records = new Record[](recordCount);
        for (uint i = 0; i < recordCount; i++) {
            _records[i] = records[i];
        }
        return _records;
    }    

    // Mark the boat as stolen
    function markStolen(bool _isStolen) public onlyOwner {
        isStolen = _isStolen;
        emit MarkedStolen(_isStolen);
    }

    // set the Hull Identification Number (should only be called once)
    function setHIN(string memory _HIN) public onlyOwner {
        require(bytes(HIN).length == 0, "HIN already set");
        HIN = _HIN;
    }
}
