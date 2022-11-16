//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {ICURVE} from "./interfaces/ICURVE.sol";
import {IUNISWAP} from "./interfaces/IUNISWAP.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {IWETH9} from "./interfaces/IWETH9.sol";
import "@uniswap/v3-core/contracts/interfaces/callback/IUniswapV3SwapCallback.sol";
// import '@uniswap/v3-periphery/contracts/libraries/CallbackValidation.sol';

contract DEX1 {
    IUNISWAP constant private uniswapPool = IUNISWAP(0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8);
    address constant private uni = 0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8;
    ICURVE constant private curvePool = ICURVE(0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7);
    address constant private curve = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
    address constant private usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant private dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant private weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    uint160 constant twopack = 22522342068230174545691635725418394000;

    function swapWETHToDai() external payable{
        uint amount = msg.value;
        swapUni(amount);

        uint usd = IERC20(usdc).balanceOf(address(this));
        IERC20(usdc).approve(curve, usd);
        
        curvePool.exchange(1, 0, usd, 0);
        
        uint am = IERC20(dai).balanceOf(address(this));
        IERC20(dai).transfer(msg.sender, am);
    }

    function swapUni(uint amount) private {
        int256 _amount = int256(amount);
        IERC20(weth).approve(uni, amount);

        uniswapPool.swap(address(this), false, _amount, twopack, '0x');
    }

    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata _data
    ) external {
        require(amount0Delta > 0 || amount1Delta > 0);
        (uint256 amountToPay) =
            amount0Delta > 0
                ? ( uint256(amount0Delta))
                : ( uint256(amount1Delta));
        pay(msg.sender, amountToPay);
      
    }

    function pay(
        address recipient,
        uint256 value
        ) internal {
        IWETH9(weth).deposit{value: value}();
        IWETH9(weth).transfer(recipient, value);
    }
    
    receive() external payable {}

}