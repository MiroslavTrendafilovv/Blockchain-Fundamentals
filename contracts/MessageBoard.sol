// SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version

contract MessageBoard{

    mapping(address => string) public messages;

    function storeMessage(string memory _message) public{
        messages[msg.sender] = _message;
    }

    function previewMessage() public view returns (string memory){

        string memory draftMessage = string(abi.encodePacked("Draft:", messages[msg.sender]));
        return draftMessage;


    }
}