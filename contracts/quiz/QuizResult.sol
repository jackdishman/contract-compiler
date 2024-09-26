// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract QuizResult is ERC721URIStorage, Ownable {
    uint256 public tokenIdCounter;

    // Mapping of quiz_id to proctor's Ethereum address
    mapping(uint256 => address) public quizProctors;

    // Event emitted when a quiz result NFT is minted
    event QuizResultMinted(
        address indexed quizTaker,
        uint256 indexed tokenId,
        uint256 quizId,
        uint8 score,
        uint256 timeCompleted,
        string metadataURI
    );

    // Constructor that initializes the ERC721 name and symbol
    constructor() ERC721("Dish Quiz Result", "DQR") Ownable(msg.sender) {}

    /**
     * @dev Set the proctor's Ethereum address for a quiz.
     * @param quizId The ID of the quiz
     * @param proctorAddress The Ethereum address of the proctor (from proctor_fid)
     */
    function setQuizProctor(
        uint256 quizId,
        address proctorAddress
    ) external onlyOwner {
        quizProctors[quizId] = proctorAddress;
    }

    /**
     * @dev Mint a new quiz result NFT to the quiz taker. Only the quiz proctor can mint.
     * @param quizTaker The address of the quiz taker who receives the NFT
     * @param quizId The ID of the quiz
     * @param score The score achieved by the quiz taker
     * @param timeCompleted The timestamp when the quiz was completed
     * @param metadataURI The URI pointing to the quiz answers stored off-chain
     */
    function mintQuizResult(
        address quizTaker,
        uint256 quizId,
        uint8 score,
        uint256 timeCompleted,
        string memory metadataURI
    ) external {
        require(
            quizProctors[quizId] == msg.sender,
            "Only the assigned proctor can mint results for this quiz"
        );

        tokenIdCounter += 1;
        uint256 newTokenId = tokenIdCounter;

        _mint(quizTaker, newTokenId);
        _setTokenURI(newTokenId, metadataURI);

        emit QuizResultMinted(
            quizTaker,
            newTokenId,
            quizId,
            score,
            timeCompleted,
            metadataURI
        );
    }
}
