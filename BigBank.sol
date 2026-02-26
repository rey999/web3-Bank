// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
import "Bank.sol";

contract BigBank is Bank {

    constructor(address admin){
        owner = admin;
    }

    modifier validAmount(){
        require(msg.value >= 0.001 * 1 ether);
        _;
    }

    function saveMoney() public payable override validAmount {
        super.saveMoney();
    }


}