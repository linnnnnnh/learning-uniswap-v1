// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";
import {Exchange} from "../src/Exchange.sol";
import {DeployExchange} from "../script/DeployExchange.s.sol";

contract ExchangeTest is Test {
    Token token;
    Exchange exchange;

    address alice = makeAddr("Alice");
    uint256 WAD = 1e18;

    function setUp() public {
        DeployExchange deployExchange = new DeployExchange();
        (token, exchange) = deployExchange.run();

        vm.deal(alice, 2000 ether);
    }

    function test_AddLiquidity() public {
        assertEq(exchange.getReserve(), 0);
        assertEq(token.balanceOf(msg.sender), 10000 * WAD);

        vm.startPrank(msg.sender);
        token.approve(address(exchange), 2000);
        exchange.addLiquidity{value: 2 ether}(2000);
        vm.stopPrank();
        assertEq(exchange.getReserve(), 2000);
        assertEq(token.balanceOf(msg.sender), (10000 * WAD) - 2000);
    }

    modifier addedLiquidity() {
        vm.startPrank(msg.sender);
        token.approve(address(exchange), 2000 * WAD);
        exchange.addLiquidity{value: 1000 ether}(2000 * WAD);
        vm.stopPrank();
        _;
    }

    function test_GetTokenAmount() public addedLiquidity {
        // The formula (x + Δx)(y − Δy)= xy makes reserves inifite, never be 0!
        assertEq(exchange.getTokenAmount(1 * WAD), 1998001998001998001);

        // It also causes price slippage: the bigger the amount of tokens traded in relative to reserves, the higher the price would be.
        assertEq(exchange.getTokenAmount(100 * WAD), 181818181818181818181);
        assertEq(exchange.getTokenAmount(1000 * WAD), 1000 * WAD);
    }

    function test_GetEthAmount() public addedLiquidity {
        // The formula (x + Δx)(y − Δy)= xy makes reserves inifite, never be 0!
        assertEq(exchange.getEthAmount(2 * WAD), 999000999000999000);

        // It also causes price slippage: the bigger the amount of tokens traded in relative to reserves, the higher the price would be.
        assertEq(exchange.getEthAmount(100 * WAD), 47619047619047619047);
        assertEq(exchange.getEthAmount(2000 * WAD), 500 * WAD);
    }
}
