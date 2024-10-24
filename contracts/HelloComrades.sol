// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.17;

contract HelloComrades {
    /*
     * =========================
     * State Variables
     * =========================
     */
    /*
    0:等待领导说“同志们好”
    1:等待同志们回复“领导好”
    2:等待领导说“同志们辛苦了”
    3:等待同志们回复“为人民服务”
    4:等待销毁合约
    */
    uint8 public step = 0;
    address public immutable leader;
    string internal constant UNKNOWN =
        unicode"我不知道如何处理它，你找有关部门吧！";
    /*
     * =========================
     * Events
     * =========================
     */

    event Step(uint8);
    event Log(string tag, address from, uint256 amount, bytes data);

    /// 这里的错误信息会被打印出来
    error MyError(string msg);

    constructor(address leader_) {
        require(leader_ != address(0), "invalid address!");
        leader = leader_;
    }

    /*
     * =========================
     * Modifier
     * =========================
     */
    modifier onlyLeader() {
        require(msg.sender == leader, unicode"必须领导才能说");
        _;
    }
    modifier onlySubordinate() {
        require(msg.sender != leader, unicode"下属才能说");
        _;
    }

    /*
     * =========================
     * Fucntions 函数
     * =========================
     */
    function hello(string calldata content) external onlyLeader returns (bool) {
        if (step != 0) {
            revert(UNKNOWN);
        }
        if (!review(content,unicode"同志们好")) {
            revert MyError(unicode"必须说：同志们好！");
        }
        step = 1;
        emit Step(step);
        return true;
    }

    /*
     * =========================
     * Helper 辅助函数
     * =========================
     */

    function review(string calldata content, string memory correctContent)
        private
        pure
        returns (bool)
    {
        return
            keccak256(abi.encodePacked(content)) ==
            keccak256(abi.encodePacked(correctContent));
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

/**
疑问：calldata的用法
bytes的用法
keccake256
abi.encodePacked的用法

receive fallback的用法
*/
