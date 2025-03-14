// SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract SoftCoin is ERC20 {
    constructor() ERC20("SoftCoin", "SOFT") {}

    
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }


}


contract UniCoin is ERC20{

     constructor() ERC20("UniCoin", "UNI") {}

     function trade(address owner, uint256 value) external {
      
        require(ERC20(address(this)).balanceOf(owner) >= value, "Not enough SoftCoin balance");
        
        
        bool success = ERC20(address(this)).transferFrom(owner, address(this), value);
        require(success, "Transfer of SoftCoin failed");
    
        _mint(owner, value);
     }

  

}