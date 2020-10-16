// SPDX-License-Identifier: GPL-3.0
pragma solidity >0.6.99 <0.8.0;

contract HelloWorld {
    bytes32 message;

    constructor(bytes32 theMessage) {
        message = theMessage;
    }

    function getMessage() public view returns (bytes32) {
        return message;
    }

}

