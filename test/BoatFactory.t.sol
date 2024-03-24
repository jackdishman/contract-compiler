// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/boats/Engine.sol";
import "../contracts/boats/Record.sol";
import "../contracts/boats/Boat.sol";
import "../contracts/boats/PowerBoat.sol";
import "../contracts/boats/BoatFactory.sol";
import "../contracts/boats/BoatRegistry.sol";

contract EngineTest is Test {
    BoatFactory boatFactory;
    BoatRegistry boatRegistry;

    function setUp() public {
        // create BoatREgistry
        boatRegistry = new BoatRegistry();
        boatFactory = new BoatFactory(
            address(boatRegistry)
        );
    }

    function test_initialSetup() public {
        assertEq(boatFactory.getBoatRegistryAddress(), address(boatRegistry));
    }

}
