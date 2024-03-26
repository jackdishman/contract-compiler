// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BoatLicense {
    address public owner;
    address[] public yacht_clubs;
    string public profile_photo;

    constructor(string memory _profile_photo) {
        profile_photo = _profile_photo;
        owner = msg.sender;
    }

    function setProfilePhoto(string memory _profile_photo) public {
        profile_photo = _profile_photo;
    }

    function addYachtClub(address _yacht_club) public {
        yacht_clubs.push(_yacht_club);
    }

    function removeYachtClub(uint _index) public {
        require(_index < yacht_clubs.length, "Index out of bounds");
        for (uint i = _index; i < yacht_clubs.length - 1; i++) {
            yacht_clubs[i] = yacht_clubs[i + 1];
        }
        yacht_clubs.pop();
    }

    function getYachtClubs() public view returns (address[] memory) {
        return yacht_clubs;
    }

    function getProfilePhoto() public view returns (string memory) {
        return profile_photo;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    function isMemberOfYachtClub(address _yacht_club) public view returns (bool) {
        for (uint i = 0; i < yacht_clubs.length; i++) {
            if (yacht_clubs[i] == _yacht_club) {
                return true;
            }
        }
        return false;
    }
}