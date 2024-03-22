// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Boat.sol";
import "./PowerBoat.sol";
import "./BoatRegistry.sol";

contract BoatFactory {
    BoatRegistry public boatRegistry;

    event BoatCreated(address indexed boatAddress);
    event PowerBoatCreated(address indexed powerBoatAddress);

    // Function to set the BoatRegistry address
    function setBoatRegistry(address _boatRegistryAddress) public {
        boatRegistry = BoatRegistry(_boatRegistryAddress);
    }

    function createBoat(
        address initialOwner,
        string memory _name, 
        string memory _manufacturer, 
        uint _year, 
        uint _length, 
        string[] memory _images
    ) public {
        Boat boat = new Boat(
            initialOwner,
            _name, 
            _manufacturer, 
            _year, 
            _length, 
            _images
        );
        emit BoatCreated(address(boat));
        boatRegistry.registerBoat(address(boat));
    }

    function createPowerBoat(
        address initialOwner,
        string memory _name, 
        string memory _manufacturer, 
        uint8 _year, 
        uint8 _length, 
        string[] memory _images, 
        uint8 _horsePower, 
        string memory _brand, 
        uint8 _engineYear
    ) public {
        Engine engine = new Engine(
            initialOwner,
            _horsePower, 
            _brand, 
            _engineYear
        );
        Engine[] memory engines = new Engine[](1);
        engines[0] = engine;
        address[] memory engineAddresses = new address[](1);
        PowerBoat powerBoat = new PowerBoat(
            initialOwner,
            _name, 
            _manufacturer, 
            _year, 
            _length, 
            _images, 
            engineAddresses
            );
        emit PowerBoatCreated(address(powerBoat));
        boatRegistry.registerPowerBoat(address(powerBoat));
    }
}
