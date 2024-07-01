// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "forge-std/console.sol";

pragma solidity ^0.8.20;

contract Exchange {
    address public tokenAddress;

    constructor(address _tokenAddress) {
        require(_tokenAddress != address(0), "Token address is invalid.");

        tokenAddress = _tokenAddress;
    }

    // Uniswap makes anyone can add liquidity to the pool.
    function addLiquidity(uint256 _tokenAmount) public payable {
        IERC20 token = IERC20(tokenAddress);
        console.log("msg.sender in code: %s", msg.sender);

        token.transferFrom(msg.sender, address(this), _tokenAmount);
    }

    // Function to check the total reserve of the token with its token address
    function getReserve() public view returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    // Calculate the pricing using the formula (x + Δx)(y − Δy)= xy
    // x: inputReserve
    // y: outputReserve
    // Δy: outputAmount (what you want to get in exchange)
    // Δx : inputAmount (what you want to trade)
    // Calculate Δy --> Δy = yΔx / (x + Δx)
    function getAmount(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) public pure returns (uint256) {
        require(
            inputReserve > 0 && outputReserve > 0,
            "Reserves must be greater than 0."
        );

        return (inputAmount * outputReserve) / (inputReserve + inputAmount);
    }

    // Get the amount of token that you can buy with ETH
    function getTokenAmount(uint256 _ethSold) public view returns (uint256) {
        require(_ethSold > 0, "ETH sold must be greater than 0.");

        uint256 tokenReserve = getReserve();

        return getAmount(_ethSold, address(this).balance, tokenReserve);
    }

    // Get the amount of ETH that you can buy with token
    function getEthAmount(uint256 _tokenSold) public view returns (uint256) {
        require(_tokenSold > 0, "Token sold must be greater than 0.");

        uint256 tokenReserve = getReserve();

        return getAmount(_tokenSold, tokenReserve, address(this).balance);
    }

    // Swap ETH to token
    // _minTokens is a minimal amount of tokens the user wants to get in exchange for their ethers
    function ethToTokenSwap(uint256 _minTokens) public payable {
        uint256 tokenReserve = getReserve();
        uint256 tokensBought = getAmount(
            msg.value,
            address(this).balance - msg.value,
            tokenReserve
        );

        require(tokensBought >= _minTokens, "insufficient output amount");

        IERC20(tokenAddress).transfer(msg.sender, tokensBought);
    }

    // Swap token to ETH
    // _minTokens is a minimal amount of tokens the user wants to get in exchange for their ethers
    function tokenToEthSwap(uint256 _tokensSold, uint256 _minEth) public {
        uint256 tokenReserve = getReserve();
        uint256 ethBought = getAmount(
            _tokensSold,
            tokenReserve,
            address(this).balance
        );

        require(ethBought >= _minEth, "insufficient output amount");

        IERC20(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            _tokensSold
        );
        payable(msg.sender).transfer(ethBought);
    }
}
