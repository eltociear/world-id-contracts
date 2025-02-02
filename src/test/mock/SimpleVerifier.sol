// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ITreeVerifier} from "../../interfaces/ITreeVerifier.sol";

/// @title Simple Verifier
/// @author Worldcoin
/// @notice A dumb verifier to make it easy to fuzz test successes and failures.
contract SimpleVerifier is ITreeVerifier {
    uint256 batchSize;

    event VerifiedProof(uint256 batchSize);

    constructor(uint256 _batchSize) {
        batchSize = _batchSize;
    }

    function verifyProof(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[1] memory input
    ) external override returns (bool result) {
        delete b;
        delete c;
        delete input;
        result = a[0] % 2 == 0;

        if (result) {
            emit VerifiedProof(batchSize);
        }
    }
}

library SimpleVerify {
    function isValidInput(uint256 a) public pure returns (bool) {
        return a % 2 == 0;
    }

    function calculateInputHash(
        uint32 startIndex,
        uint256 preRoot,
        uint256 postRoot,
        uint256[] calldata identityCommitments
    ) public pure returns (bytes32 hash) {
        bytes memory bytesToHash =
            abi.encodePacked(startIndex, preRoot, postRoot, identityCommitments);

        hash = keccak256(bytesToHash);
    }
}
