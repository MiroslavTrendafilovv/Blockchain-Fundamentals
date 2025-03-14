// SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version


contract Compound{



    function calculateCompoundInterest(uint256 principal, uint256 rate, uint256 number) public pure returns (uint256 balance){
            balance = principal;

            for (uint256 i = 0; i < number; i++) {
            balance = balance * (100 + rate) / 100; 
            }
        

            return balance;

        


    }



}