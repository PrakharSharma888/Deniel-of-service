// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Good{
    address public currentWinner;
    uint public currentAuctionPrice;
    mapping (address => uint) public balances;

    constructor() {
        currentWinner = msg.sender;
    }

    function setCurrentAuctionPrice() public payable{
        require(msg.value > currentAuctionPrice, "Needs to be more then the Current Auction Price");
        balances[currentWinner] += currentAuctionPrice;
        currentAuctionPrice = msg.value;
        currentWinner = msg.sender;
        
    }

    function withdraw() public payable {
        require(msg.sender != currentWinner, "Current Winner cant withdraw money eight now!");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value : amount}("");
        require(sent, "Failed to send Ether");

    }
}