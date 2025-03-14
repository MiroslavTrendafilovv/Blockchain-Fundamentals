//SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version

import {Event} from "./Event.sol";

enum BuyingOption{
    FixedPrice,
    Bidding
}

struct EventData{
    uint256 ticketPrice;
    BuyingOption salesType;
    uint256 salesEnd; //timestamp
}

error InvalidInput(string info);
error AlreadyListed();
error MustBeOrganizer();
error WrongBuyingOption();
error ProfitDistibutionFailed();


contract Marketplace{
    uint256 constant MIN_SALE_PERIOD = 24 hours;
    uint256 constant SALE_FEE = 0.1 ether;

    mapping(address => EventData) public events;
    mapping(address => uint256) public profits;

    event NewEvent(address indexed newEvent);

    address public immutable feeCollector;

    constructor(address feeCollector_){
        feeCollector = feeCollector_;
    }

    function createEvent(
        string memory eventName, 
        uint256 _date, 
        string memory _location, 
        uint256 ticketPrice, 
        BuyingOption salesType,  
        uint256 salesEnd,
        uint256  ticketAvailability,
        bool isPriceCapSet,
        address whiteListedAddress

        ) external {

        address newEvent = address(
            new Event(address(this), eventName, _date, _location,  msg.sender, ticketAvailability, isPriceCapSet, whiteListedAddress)
        );

        emit NewEvent(newEvent);

        _listEvent(newEvent, ticketPrice, salesType, salesEnd);

      
    }

    function listEvent(
        address newEvent, 
        uint256 ticketPrice, 
        BuyingOption salesType,  
        uint256 salesEnd
        ) external {

            if (msg.sender != Event(newEvent).organizer()){
                revert MustBeOrganizer();

            }

            _listEvent(newEvent, ticketPrice, salesType, salesEnd);
        
            
    }

    function buyOneSecondMarker(address event_, uint256 ticketId, address owner) external payable{

          if(events[event_].salesType != BuyingOption.FixedPrice){
            revert WrongBuyingOption();
        }


        if(msg.value != events[event_].ticketPrice){
            revert InvalidInput("Invalid Value!");
        }
        
        profits[Event(event_).organizer()] += msg.value - SALE_FEE;
        profits[feeCollector] += SALE_FEE;

        Event(event_).safeTransferFrom(owner, msg.sender, ticketId);

    }

    function _listEvent(
        address newEvent, 
        uint256 ticketPrice, 
        BuyingOption salesType,  
        uint256 salesEnd
     ) internal {

            //TODO: Ensure External Event Contract is compatible to IEvent
            if (salesEnd < block.timestamp + MIN_SALE_PERIOD){
                revert InvalidInput("salesEnd is Invalid!");
            }

            if (ticketPrice < SALE_FEE){
                revert InvalidInput("Ticket Price must be higher than Sale Fee");

            }
            if (events[newEvent].salesEnd != 0){
                revert AlreadyListed();
            }

            events[newEvent] = EventData({
            ticketPrice: ticketPrice,
            salesType: salesType,
            salesEnd: salesEnd
        });


     }


     // TODO: Check for REENTRANCY Posibilities
     function buyTicket(address event_) external payable{

        if(events[event_].salesType != BuyingOption.FixedPrice){
            revert WrongBuyingOption();
        }


        if(msg.value != events[event_].ticketPrice){
            revert InvalidInput("Invalid Value!");
        }
        
        profits[Event(event_).organizer()] += msg.value - SALE_FEE;
        profits[feeCollector] += SALE_FEE;

        Event(event_).safeMint(msg.sender);

     }

     function withdrawProfit(address to) external payable{
        //transfer
        //send
        //call
        uint256 profit = profits[msg.sender];
       (bool success,) = to.call{value: profit}("");
       if(!success){
        revert ProfitDistibutionFailed();

       }
       profits[msg.sender] = 0;

     }





    
}