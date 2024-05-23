// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Munchkins.sol";

contract Donut is ERC721, Ownable {
    uint256 private _currentTokenId;
    Munchkins private munchkinsToken;
    uint256 public munchkinsPerDonut = 100 * 10 ** 18; // Amount of Munchkins per burned Donut

    constructor(
        address initialOwner,
        Munchkins _munchkinsToken
    ) ERC721("Donut", "DONUT") Ownable(initialOwner) {
        munchkinsToken = _munchkinsToken;
        transferOwnership(initialOwner);
    }

    function safeMint(address to) public onlyOwner {
        _currentTokenId++;
        uint256 newTokenId = _currentTokenId;
        _safeMint(to, newTokenId);
    }

    function burnForMunchkins(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "You do not own this Donut");

        _burn(tokenId);
        munchkinsToken.transfer(msg.sender, munchkinsPerDonut);
    }

    function setMunchkinsPerDonut(uint256 amount) external onlyOwner {
        munchkinsPerDonut = amount;
    }
}
