// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Good{
    address public currentWinner;
    uint public currentAuctionPrice;

    constructor() {
        currentWinner = msg.sender;
    }

    function setCurrentAuctionPrice() public payable{
        require(msg.value > currentAuctionPrice, "Needs to be more then the Current Auction Price");
        (bool sent,) = currentWinner.call{value : currentAuctionPrice}("");
        if(sent){
            currentWinner = msg.sender;
            currentAuctionPrice = msg.value;
        } 
    }
}