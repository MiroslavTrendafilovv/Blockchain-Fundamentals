// SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version

contract DefiSavings{

    struct SavingsAccount{
        uint256 balance;
        address owner;
        uint256 creationTime;
        uint256 lockPeriod;
        bool hasWithdrawn;

    }
    mapping(address => SavingsAccount[]) public savingsAccounts;

    function createSavingsPlan(uint256 _lockPeriod) external payable{

         require(msg.value > 0, "You must send some ether to create a savings plan");

        SavingsAccount memory NewAccount = SavingsAccount({
            balance: msg.value,
            owner: msg.sender,
            creationTime: block.timestamp,
            lockPeriod: _lockPeriod,
            hasWithdrawn: false
        });

        savingsAccounts[msg.sender].push(NewAccount);
        
    }

    function viewSavingsPlan(uint256 index) external view returns(uint256 balance, uint256 creationTime, uint256 lockPeriod){

        require(index < savingsAccounts[msg.sender].length, "Invalid savings plan index");

        SavingsAccount memory account = savingsAccounts[msg.sender][index];

        return (account.balance, account.creationTime, account.lockPeriod);


    }

    function withdrawFunds(uint256 index) external {

        require(index < savingsAccounts[msg.sender].length, "Invalid savings plan index");

        SavingsAccount storage account = savingsAccounts[msg.sender][index];

        require(block.timestamp >= account.creationTime + account.lockPeriod, "Lock period has not expired yet");

        uint256 amountToWithdraw = account.balance;

        require(amountToWithdraw > 0, "No funds to withdraw");

        account.balance = 0;

        payable(msg.sender).transfer(amountToWithdraw);


    }


}