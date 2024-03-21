// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract IBoat {
    function getDetails() public view virtual returns (string memory, string memory, uint, uint, string[] memory);
}

contract Boat is IBoat {
    address public owner;
    string public name;
    string public manufacturer;
    uint public year;
    uint public length;
    string[] public images;

    constructor(string memory _name, string memory _manufacturer, uint _year, uint _length, string[] memory _images) {
        name = _name;
        manufacturer = _manufacturer;
        year = _year;
        length = _length;
        images = _images;
        owner = msg.sender;
    }

    function setName(string memory _name) public {
        name = _name;
    }

    function addImage(string memory _image) public {
        images.push(_image);
    }

    function removeImage(uint _index) public {
        require(_index < images.length, "Index out of bounds");
        for (uint i = _index; i < images.length - 1; i++) {
            images[i] = images[i + 1];
        }
        images.pop();
    }

    function getImages() public view returns (string[] memory) {
        return images;
    }

    // Implementing the abstract method from IBoat
    function getDetails() public view override returns (string memory, string memory, uint, uint, string[] memory) {
        return (name, manufacturer, year, length, images);
    }
}
