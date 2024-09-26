// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract DISHToken {
    // Token details
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;

    // Mapping to keep track of balances
    mapping(address => uint256) public balanceOf;

    // Address of the contract owner
    address public owner;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed to, uint256 value);

    // Constructor to initialize the token name, symbol, and mint initial supply
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ) {
        owner = msg.sender;
        name = _name;
        symbol = _symbol;
        uint256 supplyWithDecimals = _initialSupply * 10 ** uint256(decimals);
        totalSupply = supplyWithDecimals;
        balanceOf[owner] = supplyWithDecimals;
        emit Transfer(address(0), owner, supplyWithDecimals); // Emit the transfer event for the premint
    }

    // Modifier to allow only owner to perform certain actions
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can execute this function"
        );
        _;
    }

    // Transfer function to transfer tokens
    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Mint function to allow the owner to mint unlimited tokens
    function mint(
        address _to,
        uint256 _value
    ) public onlyOwner returns (bool success) {
        totalSupply += _value;
        balanceOf[_to] += _value;
        emit Mint(_to, _value);
        emit Transfer(address(0), _to, _value); // Emit the transfer event for the minting
        return true;
    }
}
