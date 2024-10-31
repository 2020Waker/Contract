// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.17;

/*
    两种角色：
    1. 受益人 
    2. 资助人 funders  mapping=>address => funder

    状态变量
        筹资目标数量：
        当前筹集数量
        资助者列表
        资助者人数
*/
contract CrowdFunding {
    address public immutable beneficiary;
    uint256 public immutable goalAmount; // 目标筹集数量

    uint256 public fundingAmount; // 当前筹集的数量
    mapping(address => uint256) public funders; //

    mapping(address => bool) private fundersInserted;
    address[] public fundersKey;

    bool public AVAILABLED = true;

    constructor(address ads_, uint256 amount_) {
        beneficiary = ads_;
        goalAmount = amount_;
    }

    struct funder {
        string name;
        uint256 amount;
    }

    // 捐钱
    function contribute() external payable {
        require(AVAILABLED, "CrowdFunding closed!");
        funders[msg.sender] += msg.value;
        fundingAmount += msg.value;

        if (!fundersInserted[msg.sender]) {
            // 1.检查
            fundersInserted[msg.sender] = true; // 2.修改状态
            fundersKey.push(msg.sender); // 3.操作
        }
    }
    // 关闭合约并转账给被捐助者
    function close() external returns (bool) {
        // 检查
        if (goalAmount > fundingAmount) {
            return false;
        }
        uint256 amount = fundingAmount;
        // 修改
        fundingAmount = 0;
        AVAILABLED = false;
        // 操作
        payable(beneficiary).transfer(amount);
        return true;
    }

    // 获取捐赠者的数量
    function fundersLength() public view returns(uint256){
        return fundersKey.length;
    }
}
