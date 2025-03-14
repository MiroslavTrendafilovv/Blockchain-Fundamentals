// SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version

contract ERC721{

    string public _name = "EventTicketNFT";
    string public _symbol = "ETN";
    mapping (uint256 tokenID => address) private _owners;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => uint256) private _balances;
    mapping(address => uint256[]) private _ownedTokens;

    
    address public owner;
    error ERC721InvalidReceiver();
    error ERC721InvalidSender();

    struct Event {
        string eventName;    
        string date;    
        string seatNumber; 
    }

    mapping (uint256 => Event) public metadata;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    constructor (){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    function name() public view virtual returns (string memory){
        return string(abi.encodePacked(_name));
    }

    function symbol() public view virtual returns (string memory){
        return string(abi.encodePacked(_symbol));

    }

    function ownerOf(uint256 tokenId) public virtual returns (address){
        _owners[tokenId] = owner;
        return _owners[tokenId];

    }

    function safeTransferFrom(address from, address to, uint256 tokenId) external payable{
        if(from != msg.sender){
            revert("Unauthorized: No transfer permission");
        }
        if(to == address(0)){
            revert("ZeroAddress: Invalid recipient address");
        }
       if (_owners[tokenId] != from){
            revert("Unauthorized: Not the owner of this token");
       }
       _owners[tokenId] = to;

       emit Transfer(from,to,tokenId);
 
    }

    function _mint(address to, uint256 tokenId) external onlyOwner{

        require(to != address(0), "ERC721: mint to the zero address");

        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId); 
    }

    function Metadata(uint256 tokenId, string memory eventName, string memory date, string memory seatNumber) public {
        metadata[tokenId] = Event(eventName, date, seatNumber);

    }

     function transferTicket(address from, address to, uint256 tokenId) external onlyOwner {
        require(from == _owners[tokenId], "You are not the owner of this ticket");
        require(to != address(0), "Cannot transfer to the zero address");

        // Transfer the ticket to the new owner
        _owners[tokenId] = to;
     }

}

contract nftTicket is ERC721{
}