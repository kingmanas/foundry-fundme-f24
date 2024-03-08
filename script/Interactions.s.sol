// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script , console} from "lib/forge-std/src/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script{
    uint256 constant SEND_VALUE = 0.01 ether;
    function fundFundMe(address mostRecentlyDeployed) public {
        
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        
        console.log("Funded FundMe with %s",SEND_VALUE);
    }
function run() external {
    address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);//gets the most latest deployed contract file from latest.json
    vm.startBroadcast();
    fundFundMe(mostRecentlyDeployed);
    vm.stopBroadcast();
}
}
contract WithdrawFundMe is Script{
    uint256 constant SEND_VALUE = 0.01 ether;
    function withdrawFundMe(address mostRecentlyDeployed) public {
        
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        
        console.log("Funded FundMe with %s",SEND_VALUE);
    }
function run() external {
    address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);//gets the most latest deployed contract file from latest.json
    vm.startBroadcast();
    withdrawFundMe(mostRecentlyDeployed);
    vm.stopBroadcast();
}
}