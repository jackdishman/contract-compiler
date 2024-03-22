// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Boat.sol";
import "./Engine.sol";
import "./utils/Ownable.sol";

contract PowerBoat is Ownable {
    Boat public boat;
    Engine[] public engines; // Array to store engines

    uint8 public constant MAX_ENGINES = 5; // Maximum number of engines

    // Updated constructor to only initialize the boat, engines will be added separately
    constructor(
        address initialOwner,
        string memory _name,
        string memory _manufacturer,
        uint8 _year,
        uint8 _length,
        string[] memory _images,
        address[] memory _engineAddresses
    ) Ownable(initialOwner) {
        boat = new Boat(initialOwner, _name, _manufacturer, _year, _length, _images);
        for (uint i = 0; i < _engineAddresses.length; i++) {
            engines.push(Engine(_engineAddresses[i]));
        }
    }

    // Method to add an engine, ensuring we don't exceed the maximum
    function addEngine(address initialOwner, uint8 _horsePower, string memory _brand, uint8 _engineYear) public {
        require(engines.length < MAX_ENGINES, "Maximum number of engines reached.");
        Engine newEngine = new Engine(initialOwner, _horsePower, _brand, _engineYear);
        engines.push(newEngine);
    }

    // Method to remove an engine by index
    function removeEngine(uint index) public onlyOwner() {
        require(index < engines.length, "Engine index out of bounds.");
        engines[index] = engines[engines.length - 1];
        engines.pop();
    }

    // Updated to fetch details from multiple engines
    function getEngineDetails() public view returns (Engine[] memory) {
        return engines;
    }

    // Assuming Engine contract has a method getDetails() that returns engine details
    function getAllDetails() public view returns (
        string memory, string memory, uint, uint, string[] memory,
        Engine[] memory
    ) {
        // Extract boat details
        (string memory name, string memory manufacturer, uint year, uint length, string[] memory images) = boat.getDetails();

        // Return all details including multiple engines
        return (name, manufacturer, year, length, images, getEngineDetails());
    }
}
