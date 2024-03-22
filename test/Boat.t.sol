// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../contracts/boats/Boat.sol";

contract BoatTest is Test {
    Boat boat;
    address initialOwner;

    // This function runs before each test function
    function setUp() public {
        initialOwner = address(this);
        boat = new Boat(
            initialOwner,
            "Boaty McBoatface",
            "Boston Whaler",
            2021,
            21,
            new string[](0)
        );
    }

    function testInitialSetup() public {
        assertEq(boat.owner(), initialOwner);
        assertEq(boat.name(), "Boaty McBoatface");
        assertEq(boat.manufacturer(), "Boston Whaler");
        assertEq(boat.year(), 2021);
        assertEq(boat.length(), 21);
    }

    function testSetName() public {
        console.log("Boat owner: ", boat.owner());
        boat.setName("Boaty McBoatface II");
        assertEq(boat.name(), "Boaty McBoatface II");
    }
}
