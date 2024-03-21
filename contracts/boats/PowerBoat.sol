// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Boat.sol";
import "./Engine.sol";

contract PowerBoat {
    Boat public boat;
    Engine public engine;

    constructor(
        string memory _name,
        string memory _manufacturer,
        uint _year,
        uint _length,
        string[] memory _images,
        uint _horsePower,
        string memory _brand,
        uint _engineYear
    ) {
        boat = new Boat(_name, _manufacturer, _year, _length, _images);
        engine = new Engine(_horsePower, _brand, _engineYear);
    }

    function getBoatDetails() public view returns (string memory, string memory, uint, uint, string[] memory) {
        return boat.getDetails();
    }

    function getEngineDetails() public view returns (uint, string memory, uint) {
        return engine.getEngineDetails();
    }

    function changeEngineDetails(uint _horsePower, string memory _brand, uint _engineYear) public {
        engine.setEngineDetails(_horsePower, _brand, _engineYear);
    }

    function getAllDetails() public view returns (
        string memory, string memory, uint, uint, string[] memory,
        uint, string memory, uint
    ) {
        // Extract boat details
        (string memory name, string memory manufacturer, uint year, uint length, string[] memory images) = getBoatDetails();

        // Extract engine details
        (uint horsePower, string memory brand, uint engineYear) = getEngineDetails();

        return (name, manufacturer, year, length, images, horsePower, brand, engineYear);
    }
}
