// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.17;

contract WETH {
    constructor() {
        // owner = msg.sender;
    }

    string public constant name = "Wrapped Ether";
    string public constant symbol = "WETH";
    uint8 public constant decimals = 18;

    //event
    event Approval(
        address indexed src,
        address indexed delegateAds,
        uint256 amount
    );
    event Transfer(address indexed src, address indexed toAdds, uint256 amount);
    event Deposit(address indexed src, uint256 amount);
    event Withdraw(address indexed src, uint256 amount);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount_) public payable {
        // 取钱逻辑
        require(balanceOf[msg.sender] >= amount_, unicode"余额不足"); // 检测
        balanceOf[msg.sender] -= amount_; // 写状态变量
        payable(msg.sender).transfer(amount_); // 真正操作
        emit Withdraw(msg.sender, amount_);
    }

    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }

    function approval(address delegateAds_, uint256 amount_)
        public
        returns (bool)
    {
        allowance[msg.sender][delegateAds_] = amount_;
        emit Approval(msg.sender, delegateAds_, amount_);
        return true;
    }
    // 普通转账
    function transfer(address toAds_,uint256 amount_) public returns(bool){
        return transferFrom(msg.sender,toAds_,amount_);
    }

    // 转账：授权转账或普通转账
    function transferFrom(address src,address toAds_,uint256 amount_) public returns(bool){
        if(msg.sender != src){
            require(allowance[src][msg.sender]>=amount_,unicode"余额不足");
            allowance[src][msg.sender] -= amount_;
        }
        balanceOf[src] -= amount_;
        balanceOf[toAds_] += amount_;

        emit Transfer(src,toAds_,amount_);
        return true;
    }
    // 接收转账会调用的方法
    receive() external payable{
        deposit();
    }
}