// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BoatRegistry {
    address[] public boats;
    address[] public powerBoats;

    // Events for boat registrations
    event BoatRegistered(address indexed boatAddress);
    event PowerBoatRegistered(address indexed powerBoatAddress);

    function registerBoat(address _boatAddress) public {
        boats.push(_boatAddress);
        emit BoatRegistered(_boatAddress);
    }

    function registerPowerBoat(address _powerBoatAddress) public {
        powerBoats.push(_powerBoatAddress);
        emit PowerBoatRegistered(_powerBoatAddress);
    }
}
