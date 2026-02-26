// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Bank{

    mapping(address=>uint256) public countAndMoney;

    address [] public userAddrs;

    address [3] public top3;

    address owner;

    constructor(){
        owner = msg.sender;
    }

    function saveMoney() public payable {
        require(msg.value > 0,"value must be more than 0");

        address userAddr = msg.sender;
        // 如果是新用户，则加入userAddrs数组
        if (countAndMoney[userAddr] == 0) {
            userAddrs.push(userAddr);
        }
        
        countAndMoney[userAddr] += msg.value;
        updateTop3(userAddr);
    }
    
    function updateTop3(address user) internal {
        uint256 money = countAndMoney[user];
        // ---------- Step1: 如果已在榜单，先移除 ----------
        for (uint i = 0; i < 3; i++) {
            if (top3[i] == user) {
                for (uint j = i; j < 2; j++) {
                    top3[j] = top3[j + 1];
                }
                top3[2] = address(0);
                break;
            }
        }

        // ---------- Step2: 插入排序 ----------
        if (money > countAndMoney[top3[0]]) {
            top3[2] = top3[1];
            top3[1] = top3[0];
            top3[0] = user;

        } else if (money > countAndMoney[top3[1]]) {
            top3[2] = top3[1];
            top3[1] = user;
        } else if (money > countAndMoney[top3[2]]) {
            top3[2] = user;
        }
    }


    function getTop3() external view returns(address[3] memory){
        return top3;
    }

    function withdraw() external {
        require(msg.sender == owner);
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable { }

    fallback() external payable { }
    
}
