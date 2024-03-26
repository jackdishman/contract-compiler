// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BoatRegistry {
    address[] public boats;
    address[] public powerBoats;
    address[] public engines;

    // Events for boat registrations
    event BoatRegistered(address indexed boatAddress);
    event PowerBoatRegistered(address indexed powerBoatAddress);
    event EngineRegistered(address indexed engineAddress);

    constructor() {}

    function registerBoat(address _boatAddress) public {
        boats.push(_boatAddress);
        emit BoatRegistered(_boatAddress);
    }

    function registerPowerBoat(address _powerBoatAddress) public {
        powerBoats.push(_powerBoatAddress);
        emit PowerBoatRegistered(_powerBoatAddress);
    }

    function registerEngine(address _engineAddress) public {
        engines.push(_engineAddress);
        emit EngineRegistered(_engineAddress);
    }
}
