// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "contracts/week1/Bank.sol";

contract BigBank is Bank {

    // 存款金额必须大于0.001 ether的修饰符
    modifier minimumDeposit() {
        require(msg.value > 0.001 ether, "Deposit must be greater than 0.001 ether");
        _;
    }

    function deposit() private override  {

    }
}