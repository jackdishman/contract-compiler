// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Record.sol";

contract Engine is Ownable {
    uint public horsePower;
    string public brand;
    uint public engineYear;

    mapping(uint => Record) private records;
    uint private recordCount;    
    
    constructor(address initialOwner, uint _horsePower, string memory _brand, uint _engineYear) Ownable (initialOwner) {
        horsePower = _horsePower;
        brand = _brand;
        engineYear = _engineYear;
    }

    function getEngineDetails() public view returns (uint, string memory, uint) {
        return (horsePower, brand, engineYear);
    }

    function addRecord(string memory _title, string memory _description, string memory _data, string memory _kind) public onlyOwner {
        records[recordCount] = new Record(_title, _description, _data, _kind);
        recordCount++;
    }

    function getRecords() public view onlyOwner returns (Record[] memory) {
        Record[] memory _records = new Record[](recordCount);
        for (uint i = 0; i < recordCount; i++) {
            _records[i] = records[i];
        }
        return _records;
    }

    function removeRecord(uint _index) public onlyOwner {
        require(_index < recordCount, "Index out of bounds");
        for (uint i = _index; i < recordCount - 1; i++) {
            records[i] = records[i + 1];
        }
        recordCount--;
    }
}
