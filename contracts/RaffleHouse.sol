// SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version

import "./TicketNFT.sol";


contract RaffleHouse{

    struct Raffle{
        uint256 ticketPrice;
        uint256 startTime;
        uint256 endTime;
        string name;
        string symbol;
        address ticketNFT;
        uint256 totalTickets;
        uint256 winningTicketId;
        bool winnerSelected;
    }

    mapping(uint256 => Raffle) public raffles;
    uint256 public raffleIdCounter;

    event RaffleCreated(uint256 raffleId, string name, string symbol, uint256 ticketPrice, uint256 startTime, uint256 endTime);
    event TicketPurchased(uint256 raffleId, address buyer, uint256 ticketId);
    event WinnerSelected(uint256 raffleId, uint256 winningTicketId);
    event PrizeClaimed(uint256 raffleId, address winner, uint256 amount);

    error InvalidETHAmount();
    error RaffleNotActive();
    error RaffleNotFound();
    error NoTicketsPurchased();
    error WinnerAlreadySelected();
    error OnlyWinnerCanClaim();

    function createRaffle(
        uint256 ticketPrice,
        uint256 startTime,
        uint256 endTime,
        string memory name,
        string memory symbol
    ) external {
        require(startTime < endTime, "Invalid time range");

        raffleIdCounter++;
        uint256 raffleId = raffleIdCounter;

        TicketNFT ticketNFT = new TicketNFT(name, symbol);
        raffles[raffleId] = Raffle({
            ticketPrice: ticketPrice,
            startTime: startTime,
            endTime: endTime,
            name: name,
            symbol: symbol,
            ticketNFT: address(ticketNFT),
            totalTickets: 0,
            winningTicketId: 0,
            winnerSelected: false
        });

        emit RaffleCreated(raffleId, name, symbol, ticketPrice, startTime, endTime);
    }

    function buyTicket(uint256 raffleId) external payable {
        Raffle storage raffle = raffles[raffleId];
        if (raffle.ticketNFT == address(0)) revert RaffleNotFound();
        if (block.timestamp < raffle.startTime || block.timestamp > raffle.endTime) revert RaffleNotActive();
        if (msg.value != raffle.ticketPrice) revert InvalidETHAmount();

        uint256 ticketId = TicketNFT(raffle.ticketNFT).mint(msg.sender);
        raffle.totalTickets++;

        emit TicketPurchased(raffleId, msg.sender, ticketId);
    }

    function selectWinner(uint256 raffleId) external {
        Raffle storage raffle = raffles[raffleId];
        if (raffle.ticketNFT == address(0)) revert RaffleNotFound();
        if (block.timestamp < raffle.endTime) revert RaffleNotActive();
        if (raffle.totalTickets == 0) revert NoTicketsPurchased();
        if (raffle.winnerSelected) revert WinnerAlreadySelected();

        uint256 winningTicketIndex = uint256(
            keccak256(abi.encodePacked(block.timestamp, block.prevrandao, raffle.totalTickets))
        ) % raffle.totalTickets;

        raffle.winningTicketId = winningTicketIndex + 1; // Ticket IDs start from 1
        raffle.winnerSelected = true;

        emit WinnerSelected(raffleId, raffle.winningTicketId);
    }

    function claimPrize(uint256 raffleId) external {
        Raffle storage raffle = raffles[raffleId];
        if (raffle.ticketNFT == address(0)) revert RaffleNotFound();
        if (!raffle.winnerSelected) revert WinnerAlreadySelected();

        address winner = TicketNFT(raffle.ticketNFT).ownerOf(raffle.winningTicketId);
        if (msg.sender != winner) revert OnlyWinnerCanClaim();

        uint256 prizeAmount = raffle.totalTickets * raffle.ticketPrice;
        (bool success, ) = winner.call{value: prizeAmount}("");
        require(success, "Transfer failed");

        emit PrizeClaimed(raffleId, winner, prizeAmount);
    }


}