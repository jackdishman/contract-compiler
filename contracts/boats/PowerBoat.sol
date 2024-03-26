// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Boat.sol";
import "./Engine.sol";
import "./utils/Ownable.sol";

contract PowerBoat is Boat {
    mapping(uint => Engine) public engines;
    uint public engineCount;

    uint8 public constant MAX_ENGINES = 5; // Maximum number of engines

    // Constructor to initialize the boat, engines are added separately
    constructor(
        address initialOwner,
        string memory _name,
        string memory _manufacturer,
        string memory _hullType,
        uint _year,
        uint _length,
        Engine[] memory _engines
    ) Boat(initialOwner, _name, _manufacturer, _hullType, _year, _length) {
        for (uint i = 0; i < _engines.length; i++) {
            engines[i] = _engines[i];
            engineCount++;
        }
    }

    // Add a new engine to the powerboat
    function addEngine(Engine _engine) public onlyOwner {
        require(engineCount < MAX_ENGINES, "Maximum number of engines reached.");
        engines[engineCount] = _engine;
        engineCount++;
    }

    // Remove an engine by index
    function removeEngine(uint index) public onlyOwner {
        require(index < engineCount, "Index out of bounds");
        for (uint i = index; i < engineCount - 1; i++) {
            engines[i] = engines[i + 1];
        }
        engineCount--;
    }

    // Fetch details from multiple engines
    function getEngines() public view returns (Engine[] memory) {
        Engine[] memory _engines = new Engine[](engineCount);
        for (uint i = 0; i < engineCount; i++) {
            _engines[i] = engines[i];
        }
        return _engines;
    }

}
