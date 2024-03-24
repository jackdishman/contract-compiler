// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Boat.sol";
import "./PowerBoat.sol";
import "./BoatRegistry.sol";

contract BoatFactory {
    BoatRegistry public boatRegistry;

    event BoatCreated(address indexed boatAddress);
    event EngineCreated(address indexed engineAddress);
    event PowerBoatCreated(address indexed powerBoatAddress);

    constructor(address _boatRegistryAddress) {
        boatRegistry = BoatRegistry(_boatRegistryAddress);
    }

    // Function to set the BoatRegistry address
    function setBoatRegistry(address _boatRegistryAddress) public {
        boatRegistry = BoatRegistry(_boatRegistryAddress);
    }

    function createBoat(
        address initialOwner,
        string memory _name, 
        string memory _manufacturer, 
        uint _year, 
        uint _length
    ) public {
        Boat boat = new Boat(
            initialOwner,
            _name, 
            _manufacturer, 
            _year, 
            _length
        );
        emit BoatCreated(address(boat));
        boatRegistry.registerBoat(address(boat));
    }

    function createPowerBoat(
        address initialOwner,
        string memory _name, 
        string memory _manufacturer, 
        uint _year, 
        uint _length
    ) public {
        PowerBoat powerBoat = new PowerBoat(
            initialOwner,
            _name, 
            _manufacturer, 
            _year, 
            _length,
            new Engine[](0)
            );
        emit PowerBoatCreated(address(powerBoat));
        boatRegistry.registerPowerBoat(address(powerBoat));
    }

    function createEngine(
        address initialOwner,
        uint _horsePower, 
        string memory _brand, 
        uint _engineYear
    ) public {
        Engine engine = new Engine(
            initialOwner,
            _horsePower, 
            _brand, 
            _engineYear
        );
        emit EngineCreated(address(engine));
        boatRegistry.registerEngine(address(engine));
    }

    function getBoatRegistryAddress() public view returns (address) {
        return address(boatRegistry);
    }
}
