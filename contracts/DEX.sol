//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import {IUniswapV2Router02} from '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {ISWAP} from "./interfaces/ISWAP.sol";
import {IUniswapV2Factory} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract DEX {
    IUniswapV2Router02 constant private uniSwapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    ISwapRouter private constant uniswapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    ISWAP constant private swap = ISWAP(0x55B916Ce078eA594c10a874ba67eCc3d62e29822);

    // address constant private curvePool = 0xbebc44782c7db0a1a60cb6fe97d0b483032ff1c7;
    IERC20 constant private DAI = IERC20(0xaD6D458402F60fD3Bd25163575031ACDce07538D);
    IERC20 constant private USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    address constant private usdcAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant private daiAddress = 0xaD6D458402F60fD3Bd25163575031ACDce07538D;
    address constant private swapAdress = 0x55B916Ce078eA594c10a874ba67eCc3d62e29822;
    IUniswapV2Factory constant private Factory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);

    address[] path;

    constructor() {
        address WETH = uniSwapRouter.WETH();
        path.push(WETH);
        path.push(usdcAddress);
    }


    function swapWETHtoDAI() external payable {
        
        
        // _tradeOnUniswap(msg.value, 0);
        _tradeOnV3(msg.value);
        _tradeOnCurve(msg.sender);

        (bool success,) = msg.sender.call{ value: address(this).balance }("");
        require(success, "refund failed");
    }


    function _tradeOnUniswap(uint _amount, uint amountOutMin) public {
        uint deadline = block.timestamp + 15 minutes;
    
        uniSwapRouter.swapExactETHForTokens{value: _amount}(amountOutMin, path, address(this), deadline);
    }

    function _tradeOnV3 ( uint amountIn) public {
        address tokenIn = uniSwapRouter.WETH();
        address tokenOut = daiAddress;
        uint24 fee = 3000;
        address recipient = address(this);
        // address recipient = msg.sender;
        uint160 sqrtPriceLimitX96 = 0;
        uint deadline = block.timestamp + 15 minutes;
        uint amountOutMin = amountIn *95/100 ;
        
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams(
        tokenIn,
        tokenOut,
        fee,
        recipient,
        deadline,
        amountIn,
        amountOutMin,
        sqrtPriceLimitX96
        );

        uniswapRouter.exactInputSingle(params);
    }

	function _tradeOnCurve (address to) public {
	    uint amount = USDC.balanceOf(address(this));
        uint minOut = amount * 98 / 100;

        USDC.approve(swapAdress, amount);

        // swap.exchange(curvePool, USDC, DAI, amount, minOut, to);
        swap.exchange_with_best_rate(usdcAddress, daiAddress, amount, minOut, to);

	}

    // Registry.find_pool_for_coins(address in, address out, i: uint256 = 0) → address: view
    // Registry.get_coin_indices(pool: address, _from: address, _to: address) → (int128, int128, bool): view
}


//     function createPair() external {
//         address WETH = uniSwapRouter.WETH();
//         address pair = Factory.createPair(WETH, usdcAddress);
//         addLiquidityETH( address token,
//   uint amountTokenDesired,
//   uint amountTokenMin,
//   uint amountETHMin,
//   address to,
//   uint deadline
// ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
        
//     }
