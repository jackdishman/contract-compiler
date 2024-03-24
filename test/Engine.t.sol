// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/boats/Engine.sol";
import "../contracts/boats/Record.sol";

contract EngineTest is Test {
    Engine engine;
    address initialOwner;
    // create new address
    address newOwner = address(0x1);

    // This function runs before each test function
    function setUp() public {
        initialOwner = address(this);
        engine = new Engine(
            initialOwner,
            250,
            "Suzuki",
            2023
        );
    }

    function test_initialSetup() public {
        assertEq(engine.owner(), initialOwner);
        assertEq(engine.horsePower(), 250);
        assertEq(engine.brand(), "Suzuki");
        assertEq(engine.engineYear(), 2023);
    }

    function test_getRecordsAsOwner() public {
        engine.addRecord("title 1", "description 1", "https://example.com/image1.pdf", "pdf");
        engine.addRecord("title 2", "description 2", "https://example.com/image2.pdf", "pdf");
        engine.addRecord("title 3", "description 3", "https://example.com/image3.pdf", "pdf");
        Record[] memory records = engine.getRecords();
        assertEq(records.length, 3);
        assertEq(records[0].title(), "title 1");
        assertEq(records[0].description(), "description 1");
        assertEq(records[0].data(), "https://example.com/image1.pdf");
        assertEq(records[0].kind(), "pdf");
        assertEq(records[1].title(), "title 2");
        assertEq(records[1].description(), "description 2");
        assertEq(records[1].data(), "https://example.com/image2.pdf");
        assertEq(records[1].kind(), "pdf");
        assertEq(records[2].title(), "title 3");
        assertEq(records[2].description(), "description 3");
        assertEq(records[2].data(), "https://example.com/image3.pdf");
        assertEq(records[2].kind(), "pdf");
    }

    function testFail_getRecordsAsNonOwner() public {
        engine.addRecord("title 1", "description 1", "https://example.com/image1.pdf", "pdf");
        engine.transferOwnership(newOwner);
        engine.getRecords();
    }

    function test_addRecord() public {
        engine.addRecord("title 1", "description 1", "https://example.com/image1.pdf", "pdf");
        engine.addRecord("title 2", "description 2", "https://example.com/image2.pdf", "pdf");
        engine.addRecord("title 3", "description 3", "https://example.com/image3.pdf", "pdf");
        Record[] memory records = engine.getRecords();
        assertEq(records.length, 3);
        assertEq(records[0].title(), "title 1");
        assertEq(records[0].description(), "description 1");
        assertEq(records[0].data(), "https://example.com/image1.pdf");
        assertEq(records[0].kind(), "pdf");
        assertEq(records[1].title(), "title 2");
        assertEq(records[1].description(), "description 2");
        assertEq(records[1].data(), "https://example.com/image2.pdf");
        assertEq(records[1].kind(), "pdf");
        assertEq(records[2].title(), "title 3");
        assertEq(records[2].description(), "description 3");
        assertEq(records[2].data(), "https://example.com/image3.pdf");
        assertEq(records[2].kind(), "pdf");
    }

    function testFail_addRecordAsNonOwner() public {
        engine.transferOwnership(newOwner);
        engine.addRecord("title 1", "description 1", "https://example.com/image1.pdf", "pdf");
    }
}
