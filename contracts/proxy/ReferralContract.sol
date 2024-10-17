// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract ReferralContract is ReentrancyGuard {
    address public owner;
    uint public signatureGoal;
    uint public currentSignatures;
    bool public isComplete;

    mapping(address => bool) public hasSigned;
    mapping(address => bool) public allowedReferrals;
    uint public maxSigners = 10;

    event ReferralAccepted(address indexed referrer, address indexed referral);
    event ReferralGoalMet(address indexed owner);
    event ReferralAdded(address indexed owner, address indexed referral);

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can perform this action."
        );
        _;
    }

    constructor(
        address _owner,
        uint _signatureGoal,
        address[] memory initialReferrals
    ) {
        require(
            _signatureGoal > 0 && _signatureGoal <= maxSigners,
            "Signature goal must be between 1 and 10."
        );
        owner = _owner;
        signatureGoal = _signatureGoal;
        currentSignatures = 0;
        isComplete = false;

        for (uint i = 0; i < initialReferrals.length; i++) {
            address referral = initialReferrals[i];
            require(referral != address(0), "Invalid referral address.");
            allowedReferrals[referral] = true;
            emit ReferralAdded(_owner, referral);
        }
    }

    function acceptReferral() external nonReentrant {
        require(
            currentSignatures < maxSigners,
            "Maximum number of signers reached."
        );
        require(!isComplete, "Referral process is already complete.");
        require(
            allowedReferrals[msg.sender],
            "You are not allowed to accept this referral."
        );
        require(
            !hasSigned[msg.sender],
            "You have already signed this referral."
        );

        hasSigned[msg.sender] = true;
        currentSignatures++;

        emit ReferralAccepted(owner, msg.sender);

        if (currentSignatures >= signatureGoal) {
            isComplete = true;
            emit ReferralGoalMet(owner);
        }
    }

    function addReferral(address referralAddress) external onlyOwner {
        require(referralAddress != address(0), "Invalid referral address.");
        allowedReferrals[referralAddress] = true;
        emit ReferralAdded(owner, referralAddress);
    }

    function updateSignatureGoal(uint newSignatureGoal) external onlyOwner {
        require(
            newSignatureGoal > 0 && newSignatureGoal <= maxSigners,
            "Signature goal must be between 1 and 10."
        );
        require(
            currentSignatures < newSignatureGoal,
            "New signature goal must be greater than current signatures."
        );
        signatureGoal = newSignatureGoal;
    }
}

contract ReferralContractFactory {
    mapping(uint => ReferralContract) public referralContracts;
    uint public contractCount;

    event ReferralContractCreated(
        address indexed owner,
        address referralContractAddress
    );

    function createReferralContract(
        uint _signatureGoal,
        address[] calldata initialReferrals
    ) external {
        ReferralContract newContract = new ReferralContract(
            msg.sender,
            _signatureGoal,
            initialReferrals
        );
        referralContracts[contractCount] = newContract;
        contractCount++;
        emit ReferralContractCreated(msg.sender, address(newContract));
    }

    function getReferralContract(
        uint index
    ) external view returns (ReferralContract) {
        require(index < contractCount, "Invalid index.");
        return referralContracts[index];
    }
}
