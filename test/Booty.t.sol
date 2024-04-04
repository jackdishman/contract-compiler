// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/token/Booty.sol";

contract BootyTest is Test {
    BootyToken booty;
    address initialOwner;
    address newOwner = address(0x1);

    function setUp() public {
        initialOwner = address(this);
        booty = new BootyToken(
            initialOwner,
            "Booty",
            "OO",
            100,
            1000
        );
    }

    function test_initialSetup() public {
        console.log("Hourly Rate: ", booty.hourlyRate());
        console.log("Multiplier: ", booty.multiplier());
        assertEq(booty.owner(), initialOwner);
        assertEq(booty.hourlyRate(), 100);
        assertEq(booty.multiplier(), 1000);
    }

    // test sending 5 hours worth of rewards
    function test_mint() public {
        console.log("Balance of newOwner before minting: ", booty.balanceOf(newOwner));
        booty.mint(newOwner, 5, "Minting 5 minutes of tokens");
        console.log("Balance of newOwner after minting: ", booty.balanceOf(newOwner));
        assertEq(booty.balanceOf(newOwner), booty.getConversionRate(5));
    }

    function testFail_mintAsNonOwner() public {
        booty.transferOwnership(newOwner);
        booty.mint(newOwner, 1000, "Minting 1000 tokens");
    }

    function test_transferOwnership() public {
        booty.transferOwnership(newOwner);
        assertEq(booty.owner(), newOwner);
    }

    function testFail_transferOwnershipAsNonOwner() public {
        booty.transferOwnership(newOwner);
        booty.transferOwnership(newOwner);
    }

    function test_transfer() public 
    {
        // send 100 tokens to initialOwner
        booty.mint(initialOwner, 100, "Minting 100 tokens");
        booty.transfer(newOwner, 100);
    }

    function testFail_transferMoreThanBalance() public {
        booty.transfer(newOwner, 1001);
    }
}
