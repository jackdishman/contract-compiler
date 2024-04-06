// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Boat.sol";

contract BoatFactory {
    string public name;

    event BoatCreated(address boatAddress);

    constructor(string memory _name) {
        name = _name;
    }

    // Function to create a new Boat
    function createBoat(
        address initialOwner,
        string memory _name,
        string memory _manufacturer,
        string memory _hullType,
        uint _year,
        uint _length,
        string memory _metadata,
        string memory _location
    ) public returns (address) {
        // Create a new Boat and assign ownership to the initialOwner
        Boat newBoat = new Boat(
            initialOwner,
            _name,
            _manufacturer,
            _hullType,
            _year,
            _length,
            _metadata,
            _location
        );

        // Emit an event with the address of the created Boat
        emit BoatCreated(address(newBoat));

        // Return the address of the newly created Boat
        return address(newBoat);
    }
}
