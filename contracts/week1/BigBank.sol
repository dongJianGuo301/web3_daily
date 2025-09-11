// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "contracts/week1/Bank.sol";

contract BigBank is Bank {
// 存款金额必须大于0.001 ether的修饰符
    modifier minimumDeposit() {
        require(msg.value > 0.001 ether, "Deposit must be > 0.001 ether");
        _;
    }

    // 重写deposit方法，应用minimumDeposit修饰符
    function deposit() public override payable minimumDeposit {
        super.deposit();  // 调用父合约的deposit实现
    }

    // // 重写receive函数，应用最低存款要求
    // receive() external payable minimumDeposit {
    //     super.receive();
    // }

}