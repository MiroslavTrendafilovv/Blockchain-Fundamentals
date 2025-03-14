// SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

interface ILoyaltyPoints {

    function rewardPoints(address customer, uint256 points) external ;


    function redeemPoints(address customer, uint256 points) external returns(bool);

}


 abstract contract BaseLoyaltyProgram is ILoyaltyPoints{

    mapping(address => uint256) public rewardCustomers;
    address public eligableCustomer;
    bool public checkPoints;
    

    constructor(){
        eligableCustomer = msg.sender;
        checkPoints = false;
    }




    function rewardPoints(address customer, uint256 points) external virtual {
        rewardCustomers[customer] += points;  // Add points to the customer’s balance
    }

    function redeemPoints(address customer, uint256 points) external virtual  returns(bool) {
        require(rewardCustomers[customer] >= points, "Insufficient points");

        rewardCustomers[customer] -= points;
        return true;

    }

}
 contract BrewBeanPoints is ERC20, BaseLoyaltyProgram{

    mapping(address => uint256) public ownerPoints;

    mapping(address => bool) public cafeesCustomers;

    address public owner;

    bool public autorized;

    event Rewarded(address indexed cafe, address indexed customer, uint256 points);
    event Redeemed(address indexed customer, uint256 points);

    modifier onlyAuthorizedCafe() {
        require(cafeesCustomers[msg.sender], "Not an authorized cafe");
        _;
    }

   
    constructor() ERC20("BrewBean Points", "BBP") {}



    function rewardPoints(address customer, uint256 points) external override onlyAuthorizedCafe {
       super.rewardPoints(customer, points); 
        _mint(customer, points);  
        emit Rewarded(msg.sender, customer, points);
       

    }

    

    function redeemPoints(address customer, uint256 points) external override onlyAuthorizedCafe  returns (bool){
        require(ownerPoints[customer] >= points, "Insufficient points");
        super.redeemPoints(customer, points);

        _burn(customer, points);
        ownerPoints[customer] -= points;
        cafeesCustomers[customer] = true;


    
        return true;


    }




  
}