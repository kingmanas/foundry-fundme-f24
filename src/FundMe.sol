// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


import {AggregatorV3Interface} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import {PriceConvertor} from "./PriceConvertor.sol";

contract FundMe{
    using PriceConvertor for uint256;
    uint256 public immutable MIN_USD = 0.0001e18;
    address private immutable i_owner;
    address[] public s_funders;
    mapping(address => uint256) public s_addressToAmountFunded;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
    i_owner = msg.sender;
    s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable{
    require(msg.value>MIN_USD , "Zyada Bhej Lavde");
    s_funders.push(msg.sender);
s_addressToAmountFunded[msg.sender] += msg.value;
    }
    function withdraw() public {
        require(msg.sender == i_owner , "Nikal Lavde");
        for(uint256 fundersIndex=0;fundersIndex<s_funders.length;fundersIndex++){
address funder = s_funders[fundersIndex];
s_addressToAmountFunded[funder] = 0;
        }
        // funders = new funders[](0);
        //call
        (bool callSuccess ,) = payable(msg.sender).call{value:address(this).balance}("");
        require(callSuccess , "Call Nahi Lagi");
    }
  function getPrice() public view returns(uint256){
        
        (,int256 answer,,,) = s_priceFeed.latestRoundData();
        return uint256(answer) * 1e18;
    }
    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice*ethAmount) / 1e18;
        return ethAmountInUsd;
    }



    function getVersion() public view returns(uint256){
        AggregatorV3Interface pricefeed =AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return pricefeed.version();
    }
    // receive() external payable{
    //     fund();
    // }
    // fallback() external payable{
    //     fund();
    // }
    //Getter function(View and oure functions)

    function getAddressToAmountFunded(address funder) external view returns(uint256){
        return s_addressToAmountFunded[funder];
    }
    function getFunder(uint256 number) external view returns(address){
        return s_funders[number];
    }
    function getOwner() external view returns(address){
        return i_owner;
    }
}

