// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Boat.sol";
import "./Engine.sol";
import "./PowerBoat.sol";
import "./BoatRegistry.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract BoatFactory is Initializable, OwnableUpgradeable {
    BoatRegistry public boatRegistry;

    event BoatCreated(address boatAddress);
    event EngineCreated(address engineAddress);
    event PowerBoatCreated(address powerBoatAddress);


    function initialize(address _boatRegistryAddress) public onlyInitializing {
        __Ownable_init(msg.sender);
        boatRegistry = BoatRegistry(_boatRegistryAddress);
    }

    function createBoat(address _owner, string memory _name, string memory _manufacturer, uint _year, uint _length, string[] memory _images) public onlyOwner returns (address) {
        Boat newBoat = new Boat();
        newBoat.initialize(_owner, _name, _manufacturer, _year, _length, _images);
        emit BoatCreated(address(newBoat));
        return address(newBoat);
    }

    function createEngine(uint _horsePower, string memory _brand, uint _engineYear) public onlyOwner returns (address) {
        Engine newEngine = new Engine();
        newEngine.initialize(_horsePower, _brand, _engineYear);
        emit EngineCreated(address(newEngine));
        return address(newEngine);
    }

    // Updated to accept multiple engine addresses
    function createPowerBoat(address _owner, address _boatAddress, address[] memory _engineAddresses) public onlyOwner returns (address) {
        PowerBoat newPowerBoat = new PowerBoat();
        newPowerBoat.initialize(_owner, _boatAddress, _engineAddresses); // Adjust the PowerBoat initialization accordingly
        emit PowerBoatCreated(address(newPowerBoat));
        
        // Optionally, register the PowerBoat in the BoatRegistry
        boatRegistry.registerPowerBoat(address(newPowerBoat));
        return address(newPowerBoat);
    }
}
