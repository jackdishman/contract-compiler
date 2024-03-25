// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/boats/Boat.sol";
import "../contracts/boats/Image.sol";
import "../contracts/boats/Record.sol";

contract BoatTest is Test {
    Boat boat;
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

    // test removing an image as non owner
    function testFail_removeImageNonOwner() public {
        boat.addImage("https://example.com/image1.jpg", "Image 1");
        boat.transferOwnership(newOwner);
        boat.removeImage(0);
    }

    // test removing an image with an out of bounds index
    function testFail_removeImageOutOfBounds() public {
        boat.addImage("https://example.com/image1.jpg", "Image 1");
        boat.removeImage(1);
    }

    function test_getRecordsAsOwner() public {
        boat.addRecord("title 1", "description 1", "https://example.com/image1.pdf", "pdf");
        boat.addRecord("title 2", "description 2", "https://example.com/image2.pdf", "pdf");
        boat.addRecord("title 3", "description 3", "https://example.com/image3.pdf", "pdf");
        Record[] memory records = boat.getRecords();
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
        boat.addRecord("title 1", "description 1", "https://example.com/image1.pdf", "pdf");
        boat.transferOwnership(newOwner);
        boat.getRecords();
    }

    function test_removeRecord() public {
        boat.addRecord("title 1", "description 1", "https://example.com/image1.pdf", "pdf");
        boat.addRecord("title 2", "description 2", "https://example.com/image2.pdf", "pdf");
        boat.addRecord("title 3", "description 3", "https://example.com/image3.pdf", "pdf");
        boat.removeRecord(1);
        Record[] memory records = boat.getRecords();
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
        boat.addRecord("title 1", "description 1", "https://example.com/image1.pdf", "pdf");
        boat.transferOwnership(newOwner);
        boat.removeRecord(0);
    }

    function testFail_removeRecordOutOfBounds() public {
        boat.addRecord("title 1", "description 1", "https://example.com/image1.pdf", "pdf");
        boat.removeRecord(1);
    }

    function test_getHullType() public {
        assertEq(boat.getHullType(), "Center Console");
    }
}
