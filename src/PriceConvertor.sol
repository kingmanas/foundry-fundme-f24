// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19; 

import {AggregatorV3Interface} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


library PriceConvertor{
     function getPrice( AggregatorV3Interface pricefeed) public view returns(uint256){
       
        (,int256 answer,,,) = pricefeed.latestRoundData();
        return uint256(answer) * 1e18;
    }
    function getConversionRate(uint256 ethAmount ,AggregatorV3Interface priceFeed) public view returns(uint256){
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice*ethAmount) / 1e18;
        return ethAmountInUsd;
    }



    function getVersion() public view returns(uint256){
        AggregatorV3Interface pricefeed =AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return pricefeed.version();
    }
}