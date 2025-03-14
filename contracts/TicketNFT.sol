// SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TicketNFT is ERC721{

    uint256 private _tokenIdCounter;
    address public raffleHouseOwner;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        raffleHouseOwner = msg.sender;
    }

    modifier onlyRaffleHouseOwner(){
        require(msg.sender == raffleHouseOwner, "Only RaffleHouse can mint tickets");
        _;
    }

    function mint(address to) external onlyRaffleHouseOwner returns (uint256) {
        _tokenIdCounter++;
        uint256 tokenId = _tokenIdCounter;
        _safeMint(to, tokenId);
        return tokenId;
    }
    
}