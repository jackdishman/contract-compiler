// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/boats/Boat.sol";
import "../contracts/boats/Engine.sol";
import "../contracts/boats/Image.sol";
import "../contracts/boats/Record.sol";

contract BoatTest is Test {
    Boat boat;
    Engine engine;
    address initialOwner;
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
            21
        );
        engine = new Engine(
            initialOwner,
            250,
            "Suzuki",
            2023
        );
    }

    function test_initialSetup() public {
        assertEq(boat.owner(), initialOwner);
        assertEq(boat.name(), "Boaty McBoatface");
        assertEq(boat.manufacturer(), "Boston Whaler");
        assertEq(boat.year(), 2021);
        assertEq(boat.length(), 21);
        assertEq(engine.owner(), initialOwner);
        assertEq(engine.horsePower(), 250);
        assertEq(engine.brand(), "Suzuki");
        assertEq(engine.engineYear(), 2023);
    }

    function test_setName() public {
        console.log("Boat owner: ", boat.owner());
        boat.setName("Boaty McBoatface II");
        assertEq(boat.name(), "Boaty McBoatface II");
    }

    function testFail_setNameAsNonOwner() public {
        boat.transferOwnership(newOwner);
        boat.setName("Boaty McBoatface II");
    }

    function test_addImage() public {
        boat.addImage("https://jackdishman.com/image1.png", "Image 1");
        boat.addImage("https://jackdishman.com/image2.png", "Image 2");
        boat.addImage("https://jackdishman.com/image3.png", "Image 3");
        Image[] memory images = boat.getImages();
        assertEq(images.length, 3);
        assertEq(images[0].url(), "https://jackdishman.com/image1.png");
        assertEq(images[0].label(), "Image 1");
        assertEq(images[1].url(), "https://jackdishman.com/image2.png");
        assertEq(images[1].label(), "Image 2");
        assertEq(images[2].url(), "https://jackdishman.com/image3.png");
        assertEq(images[2].label(), "Image 3");
    }

    function testFail_addImageAsNonOwner() public {
        boat.transferOwnership(newOwner);
        boat.addImage("https://jackdishman.com/image1.png", "Image 1");
    }

    function test_removeImage() public {
        boat.addImage("https://example.com/image1.jpg", "Image 1");
        boat.addImage("https://example.com/image2.jpg", "Image 2");
        boat.addImage("https://example.com/image3.jpg", "Image 3");
        boat.removeImage(1);
        Image[] memory images = boat.getImages();
        assertEq(images.length, 2);
        assertEq(images[0].url(), "https://example.com/image1.jpg");
        assertEq(images[0].label(), "Image 1");
        assertEq(images[1].url(), "https://example.com/image3.jpg");
        assertEq(images[1].label(), "Image 3");
    }

    function testFail_removeImageAsNonOwner() public {
        boat.addImage("https://example.com/image1.jpg", "Image 1");
        boat.transferOwnership(newOwner);
        boat.removeImage(0);
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

    function test_removeRecord() public {
        engine.addRecord("title 1", "description 1", "https://example.com/image1.pdf", "pdf");
        engine.addRecord("title 2", "description 2", "https://example.com/image2.pdf", "pdf");
        engine.addRecord("title 3", "description 3", "https://example.com/image3.pdf", "pdf");
        engine.removeRecord(1);
        Record[] memory records = engine.getRecords();
        assertEq(records.length, 2);
        assertEq(records[0].title(), "title 1");
        assertEq(records[0].description(), "description 1");
        assertEq(records[0].data(), "https://example.com/image1.pdf");
        assertEq(records[0].kind(), "pdf");
        assertEq(records[1].title(), "title 3");
        assertEq(records[1].description(), "description 3");
        assertEq(records[1].data(), "https://example.com/image3.pdf");
        assertEq(records[1].kind(), "pdf");
    }

    function testFail_removeRecordAsNonOwner() public {
        engine.addRecord("title 1", "description 1", "https://example.com/image1.pdf", "pdf");
        engine.transferOwnership(newOwner);
        engine.removeRecord(0);
    }

    function testFail_removeRecordOutOfBounds() public {
        engine.addRecord("title 1", "description 1", "https://example.com/image1.pdf", "pdf");
        engine.removeRecord(1);
    }

    function testFail_getRecordsAsNonOwner() public {
        engine.addRecord("title 1", "description 1", "https://example.com/image1.pdf", "pdf");
        engine.transferOwnership(newOwner);
        engine.getRecords();
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

}
