// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";

contract DeployToken is Script {
    function run() public returns(Token) {
        vm.startBroadcast();
        Token token = new Token("CatToken", "CAT", 10000e18);
        vm.stopBroadcast();
        return token;
    }
}
