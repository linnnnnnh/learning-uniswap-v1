// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";
import {Exchange} from "../src/Exchange.sol";
import {DeployToken} from "../script/DeployToken.s.sol";

contract DeployExchange is Script {
    Token token;

    function run() public returns(Token, Exchange) {
        DeployToken deployToken = new DeployToken();
        token = deployToken.run();
        Exchange exchange = new Exchange(address(token));
        return (token, exchange);
    }
}
