// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Script } from "forge-std/Script.sol";
import { ThunderLoan } from "../src/protocol/ThunderLoan.sol";

contract DeployThunderLoan is Script {
    function run() public {
        vm.startBroadcast();
        new ThunderLoan();
        vm.stopBroadcast();
    }
}
