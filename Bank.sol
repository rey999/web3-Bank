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
        uint256 money = countAndMoney[userAddr];
        if(money == 0){
            userAddrs.push(userAddr);
        }
        countAndMoney[userAddr] += msg.value;

        updateTop3(userAddr);

    }
    function updateTop3(address user) internal {
        uint256 money = countAndMoney[user];
        // 第一名
        if (money > countAndMoney[top3[0]]) {
            // 后移
            top3[2] = top3[1];
            top3[1] = top3[0];
            top3[0] = user;

        }
        // 第二名
        else if (user != top3[0] &&
            money > countAndMoney[top3[1]]) {
            top3[2] = top3[1];
            top3[1] = user;

        }
        // 第三名
        else if (
            user != top3[0] &&
            user != top3[1] &&
            money > countAndMoney[top3[2]]
        ) {
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
