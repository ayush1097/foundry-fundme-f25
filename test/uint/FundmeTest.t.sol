// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/Fundme.sol";
import {DeployFundMe} from "../../script/FundmeScript.s.sol";

contract FundmeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe fundmeScript = new DeployFundMe();
        fundMe = fundmeScript.run();
        vm.deal(USER, STARTING_BALANCE); // Give USER 10 ETH
    }

    function testMinDollorisfive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testmeOwner() public view {
        console.log(fundMe.getOwner());
        console.log(address(this));
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        if (block.chainid == 11155111) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 4);
        } else if (block.chainid == 1) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 6);
        }
    }

    function testFundFailsWIthoutEnoughETH() public {
        vm.expectRevert();
        // 1 ETH is less than 5 USD
        fundMe.fund();
    }

    function testFundUpdatesFundDataStructure() public {
        vm.prank(USER); // next tx will be from USER
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawFromASingleFunder() public funded {
        uint256 startingFundMeBalance = address(fundMe).balance; //0.1 ether
        uint256 startingUserBalance = fundMe.getOwner().balance;
        //console.log(startingFundMeBalance);
        //console.log(startingUserBalance);

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        //console.log(endingFundMeBalance);
        // console.log(endingOwnerBalance);

        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingUserBalance + startingFundMeBalance);
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        uint160 numberOfFunders = 10;
        uint160 startFundersIndex = 1; // start from 1 to avoid the USER address
        for (uint160 i = 1; i < numberOfFunders + startFundersIndex; i++) {
            hoax(address(i), SEND_VALUE); // Create a new address with SEND_VALUE
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingFundMeBalance = address(fundMe).balance; // 1 ether
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        //console.log(startingFundMeBalance);
        //console.log(startingOwnerBalance);

        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startFundersIndex = 1; // start from 1 to avoid the USER address
        for (uint160 i = 1; i < numberOfFunders + startFundersIndex; i++) {
            hoax(address(i), SEND_VALUE); // Create a new address with SEND_VALUE
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingFundMeBalance = address(fundMe).balance; // 1 ether
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        //console.log(startingFundMeBalance);
        //console.log(startingOwnerBalance);

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
    }
}
