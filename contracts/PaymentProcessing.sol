// SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version

import "@openzeppelin/contracts/access/AccessControl.sol";

library PaymentLib{

    function transferETH(address to, uint256 value) internal  {
        require(value > 0, "Insufficient amount");
        (bool success, ) = to.call{value: value}("");
        require(success, "Fails to send ethers");
        
    }

    function isContract(address to) internal view returns (bool){
        uint256 size;
        assembly{size := extcodesize(to)}
        return true;

    }
}

contract PaymentProcess is AccessControl{

   
   
    bytes32 public constant TREASURY_ROLE = keccak256("TREASURY_ROLE");
    address public recipientTreasury;
    address public treasuryAddressOwner;

    uint256 public allocationPercentage;
    
    
    event treasuryAllocationUpdate(uint256 newPercentage);
    event PaymentTransfer(address indexed _to, address indexed _owner , uint256 _value);

    constructor(uint256 _allocationPercentage)  {
        treasuryAddressOwner = msg.sender;
        _allocationPercentage = allocationPercentage;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(TREASURY_ROLE, msg.sender);
    }

    modifier onlyAdmin() {
        require(hasRole(TREASURY_ROLE, msg.sender), "Not authorized");
        _;
    }


    function processPayment(address to, uint256 value) public onlyAdmin{
        require(PaymentLib.isContract(to), "Account is not a contract");
        PaymentLib.transferETH(to, value);
        emit PaymentTransfer(to, msg.sender, value);

    }

        function setAllocationPercentage(uint256 _newPercentage) external onlyAdmin {
        require(_newPercentage <= 10000, "Percentage cannot exceed 100%"); 
        allocationPercentage = _newPercentage;
        emit treasuryAllocationUpdate(_newPercentage);  
    }

   
    function calculateTreasuryAmount(uint256 amount) external view returns (uint256) {
        return (amount * allocationPercentage) / 10000;  
    }


}