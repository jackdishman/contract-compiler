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
        string memory _name, 
        string memory _manufacturer, 
        uint _year, 
        uint _length, 
        string[] memory _images
    ) public {
        Boat boat = new Boat(
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
        string memory _name, 
        string memory _manufacturer, 
        uint8 _year, 
        uint8 _length, 
        string[] memory _images, 
        uint8 _horsePower, 
        string memory _brand, 
        uint8 _engineYear
    ) public {
        PowerBoat powerBoat = new PowerBoat(
            _name, 
            _manufacturer, 
            _year, 
            _length, 
            _images, 
            _horsePower, 
            _brand, 
            _engineYear
        );
        emit PowerBoatCreated(address(powerBoat));
        boatRegistry.registerPowerBoat(address(powerBoat));
    }
}
