//SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Event is ERC721, Ownable{

    uint256 public immutable date;
    string public location;
    uint256 public ticketAvailability;
    address public immutable organizer;
    bool public immutable isPriceCapSet;
    address public whiteListedAddress;

    uint256 private _nextTokenId;

    error NoMoreTokens();

    constructor(
        address minter,
        string memory eventName, 
        uint256 _date, 
        string memory _location, 
        address _organizer,
        uint256 _ticketAvailability, 
        bool _isPriceCapSet, 
        address _whiteListedAddress
        )
        ERC721(eventName, "")
        Ownable(minter)
    {
        date = _date;
        location = _location;
        organizer = _organizer;
        isPriceCapSet = _isPriceCapSet;
        ticketAvailability = _ticketAvailability;
        if(_isPriceCapSet){
            whiteListedAddress = _whiteListedAddress;
        }
       
    }

    function safeMint(address to) public onlyOwner {
        if(_nextTokenId == ticketAvailability){
            revert NoMoreTokens();
        }
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
       
    }


    function _update(
        address to,
        uint256 tokenId,
        address auth
        ) internal override  returns (address) {
            if(isPriceCapSet && msg.sender != owner() && to != whiteListedAddress){
                revert ("Invalid transfer{price cap}");
            }

            return super._update(to, tokenId, auth);
        
    }

     
}