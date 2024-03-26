// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Boat is Initializable, OwnableUpgradeable {
    string public name;
    string public manufacturer;
    uint public year;
    uint public length;
    string[] public images;

    function initialize(address _owner, string memory _name, string memory _manufacturer, uint _year, uint _length, string[] memory _images) public onlyInitializing {
        __Ownable_init(_owner);
        name = _name;
        manufacturer = _manufacturer;
        year = _year;
        length = _length;
        images = _images;
    }

    /**
     * @dev Allows the owner to change the name of the boat.
     * @param _newName The new name for the boat.
     */
    function changeName(string memory _newName) public onlyOwner {
        name = _newName;
    }
}
