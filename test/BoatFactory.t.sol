// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/boats/Boat.sol";
import "../contracts/boats/BoatFactory.sol";

contract BoatFactoryTest is Test {
    BoatFactory public boatFactory;
    address public boatOwner;

    function setUp() public {
        boatFactory = new BoatFactory("test");
        boatOwner = address(0x123); // Example owner address; replace as needed
    }

    function testCreateBoat() public {
        // Parameters for the boat
        string memory name = "Voyager";
        string memory manufacturer = "Oceanic";
        string memory hullType = "Monohull";
        uint year = 2022;
        uint length = 30;
        string memory metadata = "Metadata info";
        string memory location = "Marina Bay";

        // Create the boat using the factory
        address boatAddr = boatFactory.createBoat(
            boatOwner,
            name,
            manufacturer,
            hullType,
            year,
            length,
            metadata,
            location
        );

        // Check that the boat was created
        assertTrue(boatAddr != address(0), "Boat should have a valid address");

        // // Check that the boat's ownership is correctly set
        Boat boat = Boat(boatAddr);
        assertEq(boat.owner(), boatOwner, "Boat owner should be set correctly");

        // // Optionally check other properties of the boat
        assertEq(boat.name(), name, "Boat name should match");
        assertEq(
            boat.manufacturer(),
            manufacturer,
            "Boat manufacturer should match"
        );
        assertEq(boat.hullType(), hullType, "Boat hull type should match");
        assertEq(boat.year(), year, "Boat year should match");
        assertEq(boat.length(), length, "Boat length should match");
        assertEq(boat.metadata(), metadata, "Boat metadata should match");
        assertEq(boat.location(), location, "Boat location should match");
    }

    function testFactoryName() public {
        assertEq(boatFactory.name(), "test", "Factory name should match");
    }

    function testCreateBoatAsNewOwner() public {
        address newOwner = address(0x456);
        vm.startPrank(newOwner);
        address newBoatAddress = boatFactory.createBoat(
            newOwner,
            "Voyager",
            "Oceanic",
            "Monohull",
            2022,
            30,
            "Metadata info",
            "Marina Bay"
        );
        vm.stopPrank();
        Boat newBoat = Boat(newBoatAddress);
        assertEq(
            newBoat.owner(),
            newOwner,
            "Boat owner should be set correctly"
        );
    }
}
