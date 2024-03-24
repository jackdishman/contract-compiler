// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Image {
    string public url;
    string public label;

    constructor(string memory _url, string memory _label) {
        url = _url;
        label = _label;
    }
}
