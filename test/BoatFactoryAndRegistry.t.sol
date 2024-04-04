// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/boats/Engine.sol";
import "../contracts/boats/Record.sol";
import "../contracts/boats/Boat.sol";
import "../contracts/boats/PowerBoat.sol";
import "../contracts/boats/BoatFactory.sol";
import "../contracts/boats/BoatRegistry.sol";

contract BoatFactoryTest is Test {
    BoatFactory public boatFactory;
    BoatRegistry public boatRegistry;
    // create guest
    address public guest = address(0x1);

    function setUp() public {
        
        boatRegistry = new BoatRegistry();
        boatFactory = new BoatFactory(
            address(boatRegistry)
        );
    }

    function test_initialSetup() public {
        assertEq(boatFactory.getBoatRegistryAddress(), address(boatRegistry));
    }

    function test_createBoat() public {
        Boat boat = boatFactory.createBoat(
            address(this),
            "Boat1",
            "Manufacturer1",
            "HullType1",
            2021,
            10
        );
        assertEq(boat.name(), "Boat1");
        assertEq(boat.manufacturer(), "Manufacturer1");
        assertEq(boat.hullType(), "HullType1");
        assertEq(boat.year(), 2021);
        assertEq(boat.length(), 10);

        // Check if the boat is registered in the BoatRegistry
        Boat boatFromRegistry = Boat(boatRegistry.getUnverifiedBoat(address(boat)));
        assertEq(address(boatFromRegistry), address(boat));
    }
    
    function test_verifyBoat() public {
        Boat boat = boatFactory.createBoat(
            address(this),
            "Boat1",
            "Manufacturer1",
            "HullType1",
            2021,
            10
        );
        // set HIN and verify
        boat.setHIN("HIN1");
        boatRegistry.verifyBoat(address(boat), boat.HIN());

        // Check if the boat is in verifiedBoats in the BoatRegistry
        Boat boatFromRegistry = Boat(boatRegistry.getVerifiedBoat(boat.HIN()));
        assertEq(address(boatFromRegistry), address(boat));
    }

    function test_rejectBoat() public {
        Boat boat = boatFactory.createBoat(
            address(this),
            "Boat1",
            "Manufacturer1",
            "HullType1",
            2021,
            10
        );
        boatRegistry.rejectBoat(address(boat));

        // Check if the boat is not in unverifiedBoats in the BoatRegistry
        Boat boatFromRegistry = Boat(boatRegistry.getUnverifiedBoat(address(boat)));
        assertEq(address(boatFromRegistry), address(0));
    }

    function test_createBoatAsGuest() public {
        vm.prank(guest);
        Boat boat = boatFactory.createBoat(
            guest,
            "Boat1",
            "Manufacturer1",
            "HullType1",
            2021,
            10
        );
        assertEq(boat.name(), "Boat1");
        assertEq(boat.manufacturer(), "Manufacturer1");
        assertEq(boat.hullType(), "HullType1");
        assertEq(boat.year(), 2021);
        assertEq(boat.length(), 10);

        // Check if the boat is registered in the BoatRegistry
        Boat boatFromRegistry = Boat(boatRegistry.getUnverifiedBoat(address(boat)));
        assertEq(address(boatFromRegistry), address(boat));
    }

    function testFail_creatBoatAsGuestAndVerify() public {
        vm.prank(guest);
        Boat boat = boatFactory.createBoat(
            guest,
            "Boat1",
            "Manufacturer1",
            "HullType1",
            2021,
            10
        );
        boat.setHIN("HIN1");
        boatRegistry.verifyBoat(address(boat), boat.HIN());
    }

    function testFail_rejectBoatAsGuest() public {
        vm.prank(guest);
        Boat boat = boatFactory.createBoat(
            guest,
            "Boat1",
            "Manufacturer1",
            "HullType1",
            2021,
            10
        );
        vm.prank(guest);
        boatRegistry.rejectBoat(address(boat));

        // check if the boat is still in the unverifiedBoats in the BoatRegistry
        Boat boatFromRegistry = Boat(boatRegistry.getUnverifiedBoat(address(boat)));
        assertEq(address(boatFromRegistry), address(boat));
        
        // reject boat from registry owner
        vm.prank(address(this));
        boatRegistry.rejectBoat(address(boat));

        // Check if the boat is not in unverifiedBoats in the BoatRegistry
        Boat boatFromRegistry2 = Boat(boatRegistry.getUnverifiedBoat(address(boat)));
        assertEq(address(boatFromRegistry2), address(0));

    }

    // function test_createBoatAsGuestAndAdminVerify() public {
    //     vm.prank(guest);
    //     Boat boat = boatFactory.createBoat(
    //         guest,
    //         "Boat1",
    //         "Manufacturer1",
    //         "HullType1",
    //         2021,
    //         10
    //     );
    //     boat.setHIN("HIN1");
    //     vm.prank(address(this));
    //     boatRegistry.verifyBoat(address(boat), boat.HIN());
        
    //     // Check if the boat is in verifiedBoats in the BoatRegistry
    //     Boat boatFromRegistry = Boat(boatRegistry.getVerifiedBoat(boat.HIN()));
    //     assertEq(address(boatFromRegistry), address(boat));
    // }
}
