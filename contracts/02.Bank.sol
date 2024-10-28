// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.17;

// 存钱罐合约：多次存，一次取，取完就销毁
contract Bank {

    address public immutable owner;

    event Deposit(address _ads,uint256 amount);
    event Withdraw(uint256 amount);

    constructor(){
        owner = msg.sender;
    }

    function withdraw() external {
        require(msg.sender == owner,"Not owner address");
        uint balance = address(this).balance;
        emit Withdraw(balance);
        payable(msg.sender).transfer(balance);
    }

    function getBalance() external view returns(uint256){
        return address(this).balance;
    }

    receive() external payable{
        emit Deposit(msg.sender,msg.value);
    }
}

// 