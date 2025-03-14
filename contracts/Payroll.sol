// SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version


contract Payroll{

    error InvalidSalary(uint256 salary);
    error InvalidRating(uint256 rating);

    function calculatePaycheck(uint256 salary, uint256 rating) public pure returns(uint256 result){

        result = salary;

        if(salary < 0){
            revert InvalidSalary(salary);
        }
        
        else if(rating > 8 && rating <= 10){
            salary += salary * 10 / 100;

        }else if (rating < 0 || rating > 10){
            revert InvalidRating(rating);

        }

    }
}