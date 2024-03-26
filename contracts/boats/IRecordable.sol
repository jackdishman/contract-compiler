// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRecordable {
    // Images
    function addImage(string memory _url, string memory _label) external;
    function removeImage(uint _index) external;
    function getImages() external view returns (string[] memory);

    // Records, restricted to owner
    function addRecord(string memory _title, string memory _description, string memory _url, string memory _label) external;
    function removeRecord(uint _index) external;
    function getRecords() external view returns (string[] memory);
}
