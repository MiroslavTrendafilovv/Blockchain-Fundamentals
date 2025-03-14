// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;


contract PaymentProcessor {

    mapping(address => uint256) public balances;

    modifier OwnerAddress(address _owner){
          require(balances[_owner] > 0, "We don't found such as client");
    _;
    }

    function ReceivePayment() external payable {

        require(msg.value > 0, "Payment must be greater than 0");
        balances[msg.sender] += msg.value;

    }

    function CheckBalance(address _adr) external view OwnerAddress(_adr) returns(uint256){

        return balances[_adr];

    }

    function refundPayment(address customer, uint _amount) public virtual {
        require(_amount <= balances[customer], "Insufficient balance for refund");

        balances[customer] -= _amount;

        payable(customer).transfer(_amount);

    }

}

contract Merchant is PaymentProcessor {

    uint public loyaltyThreshold = 1 ether;

    function refundPayment(address customer, uint _amount)  public override{

        uint refundAmount = _amount;

        if(balances[customer] >= loyaltyThreshold){
            uint bonus = (_amount * 1) / 100;
            refundAmount = _amount + bonus;
        }

        super.refundPayment(customer, refundAmount);

    }

}



