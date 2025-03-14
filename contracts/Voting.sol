// SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version

contract Voting{

    struct Voter {
        bool hasVoted;
        uint256 choice;
    }

     mapping(address => Voter) public voters;

     function registerVote(uint256 _choice) public {

        require(!voters[msg.sender].hasVoted, "you voted already");
        voters[msg.sender].choice = _choice;
        voters[msg.sender].hasVoted= true;

     }

     function getVoterStatus(address _voter) public view returns (Voter memory){

        return voters[_voter];


     }
}