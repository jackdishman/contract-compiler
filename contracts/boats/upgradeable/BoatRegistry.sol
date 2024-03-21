// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract BoatRegistry is Initializable, OwnableUpgradeable {
    address[] public boats;
    address[] public powerBoats;
    mapping(address => bool) public isRegistered;
    mapping(address => bool) private isRegistrarAllowed;

    event BoatRegistered(address indexed boatAddress);
    event PowerBoatRegistered(address indexed powerBoatAddress);

    function initialize(address[] memory _allowedRegistrars) public initializer {
        __Ownable_init(msg.sender);
        for (uint i = 0; i < _allowedRegistrars.length; i++) {
            isRegistrarAllowed[_allowedRegistrars[i]] = true;
        }
    }

    modifier onlyAllowedRegistrar() {
        require(isRegistrarAllowed[msg.sender], "Caller is not allowed to register");
        _;
    }

    function updateRegistrarStatus(address _registrar, bool _status) public onlyOwner {
        isRegistrarAllowed[_registrar] = _status;
    }

    function registerBoat(address _boatAddress) public onlyAllowedRegistrar {
        require(!isRegistered[_boatAddress], "Boat is already registered.");
        boats.push(_boatAddress);
        isRegistered[_boatAddress] = true;
        emit BoatRegistered(_boatAddress);
    }

    function registerPowerBoat(address _powerBoatAddress) public onlyAllowedRegistrar {
        require(!isRegistered[_powerBoatAddress], "PowerBoat is already registered.");
        powerBoats.push(_powerBoatAddress);
        isRegistered[_powerBoatAddress] = true;
        emit PowerBoatRegistered(_powerBoatAddress);
    }
}
