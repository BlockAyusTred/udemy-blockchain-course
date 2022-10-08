// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.14;

contract TheBlockchianMessenger {

    string public message;
    uint public updatedCount;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function updateMessage(string memory _message) public {
        if (msg.sender == owner) {
            message = _message;
            updatedCount++;
        }
    }

}