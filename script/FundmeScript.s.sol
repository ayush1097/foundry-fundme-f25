// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/Fundme.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        address usdethpriceFeed = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(usdethpriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
// 0x694AA1769357215DE4FAC081bf1f309aDC325306 is the Sepolia ETH/USD price feed address
// https://docs.chain.link/data-feeds/price-feeds/addresses#sepolia
// Note: The address might change in the future, so always check the latest documentation for the correct address.
// This script deploys the FundMe contract with the specified price feed address.
// You can run this script using the command: forge script script/FundmeScript.s.sol --broadcast --rpc-url $SEPOLIA_RPC_URL --private-key <your_private_key>
