// SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version

contract Asset{

    string public symbol;
    string public name;
    uint256 public initialSupply;
    address payable public receiver;

    constructor(string memory _symbol, string memory _name ,uint256 _initialSupply){
        symbol = _symbol;
        name = _name;
        initialSupply = _initialSupply;
    }

    function transferFunc() external payable{
        require(msg.value > 0, "Must send Ether");

        receiver.transfer(msg.value);

    }
}

interface IExternalContract {
    function transferFunc() external payable;
}

contract AssetFactory{

    Asset[] public newAsset;

    mapping(string => address) public storeAsset;

    function newAssetFactory(string memory _symbol, string memory _name ,uint256 _initialSupply) public {

        Asset asset = new Asset(_symbol, _name, _initialSupply);
        newAsset.push(asset);
        storeAsset[_name] = msg.sender;

    }

    function callTransfer(address _owner) public payable {
        IExternalContract(_owner).transferFunc{value: msg.value}();
      
    }


}