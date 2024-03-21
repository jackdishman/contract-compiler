// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Boat.sol";
import "./Engine.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract PowerBoat is OwnableUpgradeable {
    Boat public boat;
    Engine public engine;

    function initialize(address _boatAddress, address _engineAddress) public initializer {
        __Ownable_init(msg.sender);
        boat = Boat(_boatAddress);
        engine = Engine(_engineAddress);
    }
}
