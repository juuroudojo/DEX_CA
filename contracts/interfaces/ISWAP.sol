// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

interface ISWAP {
    function exchange_with_best_rate(address _from, address _to, uint256 _amount, uint256 _expected, address _receiver) external payable returns(uint256);
}