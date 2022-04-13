// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {
    //functions to perform safe math operations that would replace intuite preventative measure

    // function to add r = x+y
    function add(uint x, uint y) internal pure returns(uint256){
        uint256 r = x + y;
        require(r >= x, 'SafeMath: Addtion Overflow');
        return r;
    }

    // function substract r = x - y
    function sub(uint x, uint y) internal pure returns(uint256){
        require(x <= y, 'SafeMath: Substraction Overflow');
        uint256 r = x - y;
        return r;
    }

    // function multiply r = x * y
    function mul(uint x, uint y) internal pure returns(uint256){
        // gas optimization
        if(x == 0) {
            return 0;
        }
        uint256 r = x * y;
        require(r/x == y, 'SafeMath: Multiplication Overflow');
        return r;
    }

    // function division r = x / y
    function div(uint x, uint y) internal pure returns(uint256){
        require(y > 0, 'SafeMath: Division Overflow');
        uint256 r = x / y;
        return r;
    }

    // gas spending remains untouched
    function mod(uint x, uint y) internal pure returns(uint256){
        require(y != 0, 'SafeMath: modulo by zero');
        return x % y;
    }


}