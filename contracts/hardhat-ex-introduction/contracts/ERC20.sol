// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract SimpleToken is ERC20, Ownable { 
    
    constructor() ERC20("SimpleToken", "STK") Ownable(msg.sender) {}


    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
         
     } 
     
 }