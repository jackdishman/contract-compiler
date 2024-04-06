// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/boats/Boat.sol";

contract BoatTest is Test {
    address boatAddress;
    address initialOwner;
    Boat boat;
    // create new address
    address newOwner = address(0x1);

    // This function runs before each test function
    function setUp() public {
        initialOwner = address(this);
        boat = new Boat(
            initialOwner,
            "Boaty McBoatface",
            "Boston Whaler",
            "Center Console",
            2021,
            21,
            "This is a boat",
            "Boston, MA"
        );
        boatAddress = address(boat);
    }

    function test_initialSetup() public {
        assertEq(boat.owner(), initialOwner);
        assertEq(boat.name(), "Boaty McBoatface");
        assertEq(boat.manufacturer(), "Boston Whaler");
        assertEq(boat.hullType(), "Center Console");
        assertEq(boat.year(), 2021);
        assertEq(boat.length(), 21);
    }

    function test_setName() public {
        boat.setName("Boaty McBoatface II");
        assertEq(boat.name(), "Boaty McBoatface II");
    }

    function testFail_setNameAsNonOwner() public {
        boat.transferOwnership(newOwner);
        boat.setName("Boaty McBoatface II");
    }

    function test_getIsStolen() public {
        assertEq(boat.isStolen(), false);
    }

    function test_setIsStolen() public {
        boat.markStolen(true);
        assertEq(boat.isStolen(), true);
    }

    function test_checkIsStolenByDefault() public {
        Boat newBoat = new Boat(
            initialOwner,
            "Boaty McBoatface",
            "Boston Whaler",
            "Center Console",
            2021,
            21,
            "This is a boat",
            "Boston, MA"
        );
        assertEq(newBoat.isStolen(), false);
    }

    function test_setIsStolenTwice() public {
        boat.markStolen(true);
        boat.markStolen(false);
        assertEq(boat.isStolen(), false);
    }

    function testFail_setIsStolenAsNonOwner() public {
        boat.transferOwnership(newOwner);
        boat.markStolen(true);
    }

    function test_getHullType() public {
        assertEq(boat.hullType(), "Center Console");
    }

    function test_getManufacturer() public {
        assertEq(boat.manufacturer(), "Boston Whaler");
    }

    function test_getYear() public {
        assertEq(boat.year(), 2021);
    }

    function test_getLength() public {
        assertEq(boat.length(), 21);
    }

    function test_setHIN() public {
        boat.setHIN("123456789");
        assertEq(boat.HIN(), "123456789");
    }

    function testFail_setHINAsNonOwner() public {
        boat.transferOwnership(newOwner);
        boat.setHIN("123456789");
    }

    function testFail_setHINTwice() public {
        boat.setHIN("123456789");
        boat.setHIN("987654321");
    }

    function test_setLocation() public {
        boat.setLocation("Boston, MA");
        assertEq(boat.location(), "Boston, MA");
    }

    function testFail_setLocationAsNonOwner() public {
        boat.transferOwnership(newOwner);
        boat.setLocation("Boston, MA");
    }

    function test_setLocationTwice() public {
        boat.setLocation("Boston, MA");
        boat.setLocation("New York, NY");
    }

    function test_setMetadata() public {
        boat.setMetadata("This is a boat");
        assertEq(boat.metadata(), "This is a boat");
    }

    function testFail_setMetadataAsNonOwner() public {
        boat.transferOwnership(newOwner);
        boat.setMetadata("This is a boat");
    }

    function test_setMetadataTwice() public {
        boat.setMetadata("This is a boat");
        boat.setMetadata("This is a boat");
    }

    function test_transferOwnership() public {
        boat.transferOwnership(newOwner);
        assertEq(boat.owner(), newOwner);
    }

    function testFail_transferOwnershipAsNonOwner() public {
        boat.transferOwnership(newOwner);
        boat.transferOwnership(initialOwner);
    }
}
