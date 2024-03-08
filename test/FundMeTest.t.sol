// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test , console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {PriceConvertor} from "../src/PriceConvertor.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
   FundMe fundMe;
   address USER = makeAddr("user");
   uint256 constant SEND_VALUE = 0.1 ether;
   uint256 constant STARTING_BALANCE = 10 ether;
   uint256 constant GAS_PRICE = 1;


modifier funded(){
  vm.prank(USER);
  fundMe.fund{value: SEND_VALUE}();
  _;
}

function setUp() external { //setUp always runs first.
      DeployFundMe deployFundMe = new DeployFundMe();
      fundMe = deployFundMe.run();
      vm.deal(USER , STARTING_BALANCE);
}

function testMindollarISFive() public {
  assertEq(fundMe.MIN_USD(),0.0001e18);
}
function testOwnerIdMsgSender() public {
    assertEq(fundMe.getOwner(),msg.sender);//Fundme test is calling the contract and thus it should be the owner.
    // console.log(msg.sender);
    // console.log(fundMe.i_owner());
}
function testPriceFeedVersionIsAccurate() public {
  uint256 version = fundMe.getVersion();
  console.log(version);
  assertEq(version,4);
}
// function testPriceFeedVersionIsAccuratePrice() public {
//   uint256 version = PriceConvertor.getVersion();
//   console.log(version);
//   assertEq(version,4);
// }
function fundMeFailsWithoutEnoughEth() public {
  vm.expectRevert();
  fundMe.fund();
}
function testUpdatesDataStructure() public funded {
//  vm.prank(USER);//used to specify a msg.sender to the next transaction
//   fundMe.fund{value : SEND_VALUE}();
  uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
  assertEq(amountFunded,SEND_VALUE);
}

function testAddsFundersToArray() public funded {

  address funder = fundMe.getFunder(0);
  assertEq(funder , USER);

}

function testOnlyOwnerCanWithdrawFunds() public funded {
 

  vm.expectRevert();
  vm.prank(USER);//vm skips the next vm as its operation
  fundMe.withdraw();

}
function testWithdrawWithASingleFunder() public funded {
  //Arrange
  uint256 startingOwnerBalance = fundMe.getOwner().balance;
  uint256 startingFundMeBalance = address(fundMe).balance;

  // ACT
  // uint256 startGas = gasleft(); // used to check gas used between our desired functions
  // vm.txGasPrice(GAS_PRICE);
  vm.prank(fundMe.getOwner());
  fundMe.withdraw();
  // uint256 endGas = gasleft();
  // uint256 gasUsed = startGas - endGas;
  // console.log(gasUsed);

  // Assert
  uint256 endingOwnersBalance = fundMe.getOwner().balance;
  uint256 endingFundMeBalance = address(fundMe).balance;
  assertEq(endingFundMeBalance,0);
  assertEq(startingFundMeBalance + startingOwnerBalance,endingOwnersBalance);

}

function testWithdrawFromMultipleFunders() public funded {

  // Arrange
  uint160 numberOfFunders = 10;
  uint160 startingIndex = 1;
  for(uint160 i = startingIndex;i<numberOfFunders;i++){
    // hoax(address(i),SEND_VALUE);
    // vm.prank(address(i));
    vm.deal(address(i),SEND_VALUE);
    fundMe.fund{value: SEND_VALUE}();
  }
  uint256 startingOwnerBalance = fundMe.getOwner().balance;
  uint256 startingFundMeBalance = address(fundMe).balance;

  // Act
  vm.prank(fundMe.getOwner());
  fundMe.withdraw();

  // Assert
  assert(address(fundMe).balance == 0);
  assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);

}
 
}