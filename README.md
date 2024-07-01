## Learn Uniswap V1 with Programming DeFi - Uniswap series by Ivan Kuznetsov

**Links to the series:**
[Part 1](https://jeiwan.net/posts/programming-defi-uniswap-1/)
[Part 2](https://jeiwan.net/posts/programming-defi-uniswap-2/)
[Part 3](https://jeiwan.net/posts/programming-defi-uniswap-3/)

_This repository is created for learning purposes and to record my personal learning path._

Uniswap V1 was released in November 2018 and only allowed swaps between ether and a token. 

## Programming DeFi - Uniswap series [Part 1](https://jeiwan.net/posts/programming-defi-uniswap-1/) 

### Concepts learned

- **Automated market maker:** 

    Uniswap allows anyone to be a market maker, so providing liquidity to the DEX.

- **Constant product market maker:** 

    `x ∗ y = k` 
  
    `x` and `y` are ether reserve and token reserve, or vice versa.  
    `k` is a constant. 

- **Pricing function:** 

    `(x + Δx)(y − Δy) = xy`

    `Δx` and `Δy` are the amounts of ether and token to be swapped.
    `x` and `y` are the amounts of ether and token in the reserve.

    If we want to find `Δy`, we use `Δy = yΔx / (x + Δx)`

    This formula produces a hyperbola which makes the reserves never be 0. It also create a slippage: when more tokens are traded compared to reserves, the price goes up.

### Smart contracts learned

Two smart contracts: ERC20 Token contract and Exchange contract.

**Functions in Exchange:**

- `addLiquidity()`: anyone can add liquidity to the DEX
- `getAmount()`: use the `Δy = yΔx / (x + Δx)` formula to calculate the amount of tokens received for a given amount of ether (or vice versa)
- `getTokenAmount()` and `getEthAmount()`: get the amount of token(or ETH) that you can buy with ETH(or token)
- `ethToTokenSwap()` and `tokenToEthSwap()`: implement the swapping 

