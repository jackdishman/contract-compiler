// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Boat.sol";
import "./BoatRegistry.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BoatFactory is Ownable {
    BoatRegistry public boatRegistry;

    event BoatCreated(address indexed boatAddress);

    constructor(address _boatRegistryAddress) Ownable(msg.sender) {
        boatRegistry = BoatRegistry(_boatRegistryAddress);
    }

    // Function to set the BoatRegistry address
    function setBoatRegistry(address _boatRegistryAddress) public onlyOwner(){
        boatRegistry = BoatRegistry(_boatRegistryAddress);
    }

    function createBoat(
        address initialOwner,
        string memory _name, 
        string memory _manufacturer, 
        string memory _hullType,
        uint _year, 
        uint _length
    ) public returns (Boat) {
        Boat boat = new Boat(
            initialOwner,
            _name, 
            _manufacturer, 
            _hullType,
            _year, 
            _length
        );
        emit BoatCreated(address(boat));
        boatRegistry.registerBoat(address(boat));
        return boat;
    }

    function getBoatRegistryAddress() public view returns (address) {
        return address(boatRegistry);
    }
}
