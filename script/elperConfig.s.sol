// SPDX-License-Identifier: MIT

// What we will be doing-->>>>
// 1. Deploy mocks when we are on a local anvil chain.
// 2. Keep track of contract addresses accross different chains.

pragma solidity ^0.8.19;

import {Script} from "lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

NetworkConfig public activeNetworkConfig;

uint8 public constant DECIMALS = 8;
int256 public constant INITIAL_PRICE = 200e8;

struct NetworkConfig{
    address priceFeed;
}
constructor(){
    if(block.chainid == 11155111){
        activeNetworkConfig = getSepoliaEthconfig();
    }else if(block.chainid ==  1101){
        activeNetworkConfig = polygonEthconfig();
    }
    else{
        activeNetworkConfig = getOrCreateAnvilEthConfig();
    }
}
    function getSepoliaEthconfig() public pure returns(NetworkConfig memory){
          NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed : 0x694AA1769357215DE4FAC081bf1f309aDC325306});
          return sepoliaConfig;
    }
    function polygonEthconfig() public pure returns(NetworkConfig memory){
          NetworkConfig memory polygonConfig = NetworkConfig({priceFeed : 0x97d9F9A00dEE0004BE8ca0A8fa374d486567eE2D});
          return polygonConfig;
    }
    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory){

        if(activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }
      //pricefeed address

    //   1. Deploy the mocks
    // 2. Return the mock address

    vm.startBroadcast();
    MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS,INITIAL_PRICE);
    vm.stopBroadcast();

    NetworkConfig memory anvilConfig = NetworkConfig({
        priceFeed : address(mockPriceFeed)
    });
    return anvilConfig;
    }

}