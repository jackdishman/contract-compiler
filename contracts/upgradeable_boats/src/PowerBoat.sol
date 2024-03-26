// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Boat.sol";
import "./Engine.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract PowerBoat is OwnableUpgradeable {
    Boat public boat;
    Engine[] public engines;

    uint256 public constant MAX_ENGINES = 6;

    function initialize(address _owner, address _boatAddress, address[] memory _engineAddresses) public initializer {
        __Ownable_init(_owner);
        require(_engineAddresses.length <= MAX_ENGINES, "Cannot initialize with more than 6 engines.");
        boat = Boat(_boatAddress);
        
        for (uint i = 0; i < _engineAddresses.length; i++) {
            require(_engineAddresses[i] != address(0), "Engine address cannot be the zero address.");
            engines.push(Engine(_engineAddresses[i]));
        }
    }

    function addEngine(address _newEngineAddress) public onlyOwner {
        require(_newEngineAddress != address(0), "New engine address cannot be the zero address.");
        require(engines.length < MAX_ENGINES, "Maximum number of engines reached.");
        engines.push(Engine(_newEngineAddress));
    }

    function swapEngine(uint _engineIndex, address _newEngineAddress) public onlyOwner {
        require(_newEngineAddress != address(0), "New engine address cannot be the zero address.");
        require(_engineIndex < engines.length, "Engine index out of bounds.");
        engines[_engineIndex] = Engine(_newEngineAddress);
    }

    /**
     * @dev Allows the owner to remove an engine by index.
     * @param _engineIndex The index of the engine in the array to be removed.
     */
    function removeEngine(uint _engineIndex) public onlyOwner {
        require(_engineIndex < engines.length, "Engine index out of bounds.");
        
        // Swap the engine to remove with the last one, then remove the last one (more gas efficient than shifting elements)
        engines[_engineIndex] = engines[engines.length - 1];
        engines.pop();
    }
}
