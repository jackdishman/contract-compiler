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
        booty = new BootyToken(1000);
    }

    function test_initialSetup() public {
        assertEq(booty.owner(), initialOwner);
        assertEq(booty.balanceOf(initialOwner), 1000);
    }

    function test_mint() public {
        booty.mint(newOwner, 1000);
        assertEq(booty.balanceOf(newOwner), 1000);
    }

    function testFail_mintAsNonOwner() public {
        booty.transferOwnership(newOwner);
        booty.mint(newOwner, 1000);
    }

    function test_transferOwnership() public {
        booty.transferOwnership(newOwner);
        assertEq(booty.owner(), newOwner);
    }

    function testFail_transferOwnershipAsNonOwner() public {
        booty.transferOwnership(newOwner);
        booty.transferOwnership(newOwner);
    }

    function test_transfer() public {
        booty.transfer(newOwner, 100);
        assertEq(booty.balanceOf(newOwner), 100);
    }

    function testFail_transferMoreThanBalance() public {
        booty.transfer(newOwner, 1001);
    }
}
