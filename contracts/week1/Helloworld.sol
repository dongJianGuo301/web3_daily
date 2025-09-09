// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Helloworld {

    uint public age =0;

    function addAge() public returns(uint) {
        return age ++;
    }
}