// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Record {
    string public title;
    string public description;
    string public data;
    string public kind;

    constructor(string memory _title, string memory _description, string memory _data, string memory _kind) {
        title = _title;
        description = _description;
        data = _data;
        kind = _kind;
    }
}
