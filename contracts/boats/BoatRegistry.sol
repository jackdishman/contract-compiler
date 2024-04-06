// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Boat.sol";

contract BoatRegistry is Ownable {
    mapping(address => Boat) public unverifiedBoats;
    mapping(string => Boat) public verifiedBoats;

    uint public unverifiedBoatCount;
    uint public verifiedBoatCount;

    // Events for boat registrations
    event BoatRegistered(address indexed boatAddress);
    event BoatVerified(address indexed boatAddress);

    constructor(address initialOwner) Ownable(initialOwner) {}

    function registerBoat(address _boatAddress) public {
        unverifiedBoats[_boatAddress] = Boat(_boatAddress);
        unverifiedBoatCount++;
        emit BoatRegistered(_boatAddress);
    }

    function getAllUnverifiedBoatAddresses()
        public
        view
        returns (address[] memory)
    {
        address[] memory addresses = new address[](unverifiedBoatCount);
        for (uint i = 0; i < unverifiedBoatCount; i++) {
            addresses[i] = address(unverifiedBoats[addresses[i]]);
        }
        return addresses;
    }

    function getAllVerifiedBoats() public view returns (Boat[] memory) {
        Boat[] memory boats = new Boat[](verifiedBoatCount);
        for (uint i = 0; i < verifiedBoatCount; i++) {
            boats[i] = verifiedBoats[boats[i].HIN()];
        }
        return boats;
    }

    function verifyBoat(
        address _boatAddress,
        string memory _HIN
    ) public onlyOwner {
        require(bytes(_HIN).length > 0, "HIN cannot be empty");
        Boat boat = unverifiedBoats[_boatAddress];
        verifiedBoats[_HIN] = boat;
        emit BoatVerified(_boatAddress);
        verifiedBoatCount++;
        delete unverifiedBoats[_boatAddress];
        unverifiedBoatCount--;
    }

    function getVerifiedBoat(string memory _HIN) public view returns (Boat) {
        return verifiedBoats[_HIN];
    }

    function getUnverifiedBoat(
        address _boatAddress
    ) public view returns (Boat) {
        return unverifiedBoats[_boatAddress];
    }

    function rejectBoat(address _boatAddress) public onlyOwner {
        delete unverifiedBoats[_boatAddress];
        unverifiedBoatCount--;
    }

    function removeVerifiedBoat(string memory _HIN) public onlyOwner {
        delete verifiedBoats[_HIN];
        verifiedBoatCount--;
    }

    function getUnverifiedBoatsWithHIN()
        public
        view
        returns (address[] memory)
    {
        address[] memory addresses = new address[](unverifiedBoatCount);
        for (uint i = 0; i < unverifiedBoatCount; i++) {
            if (bytes(unverifiedBoats[addresses[i]].HIN()).length > 0) {
                addresses[i] = address(unverifiedBoats[addresses[i]]);
            }
        }
        return addresses;
    }
}
