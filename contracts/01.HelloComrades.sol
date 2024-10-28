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
        require(msg.sender != leader, unicode"必须下属才能说");
        _;
    }

    /*
     * =========================
     * Fucntions 函数
     * =========================
     */

    /// @notice 用于领导说“同志们好”
    /// @dev 只能在step为0的时候调用
    /// @param content：当前领导说的内容
    /// return 当前的调用状态，true为成功
    function hello(string calldata content) external onlyLeader returns (bool) {
        if (step != 0) {
            revert(UNKNOWN);
        }
        if (!review(content, unicode"同志们好")) {
            revert MyError(unicode"必须说：同志们好！");
        }
        step = 1;
        emit Step(step);
        return true;
    }

    /// @notice 用于同志们说"领导好"
    /// @dev 只能在step为1的时候调用，只能同志们调用，并且只能说“领导好”
    /// @param content：当前同志们说的内容
    /// @return 当前的调用状态，true为成功
    function helloRes(string calldata content)
        external
        onlySubordinate
        returns (bool)
    {
        if (step != 1) {
            revert(UNKNOWN);
        }
        if (!review(content, unicode"领导好")) {
            revert MyError(unicode"必须说：领导好");
        }
        step = 2;
        emit Step(step);
        return true;
    }

    /// @notice 用于领导说“同志们辛苦了”
    /// @dev 只能在step为2的时候调用，只能领导调用，并且只能说“同志们辛苦了”
    /// @param content：当前同志们说的内容
    /// @return 当前的调用状态，true为成功
    function comfort(string calldata content)
        external
        payable
        onlyLeader
        returns (bool)
    {
        if (step != 2) {
            revert(UNKNOWN);
        }
        if (!review(content, unicode"同志们辛苦了")) {
            revert MyError(unicode"必须说：同志们辛苦了");
        }
        if (msg.value < 2 ether) {
            revert MyError(unicode"给钱！！！最少给2个以太币！");
        }
        step = 3;
        emit Step(step);
        emit Log("comfort", msg.sender, msg.value, msg.data);
        return true;
    }

    /// @notice 用于同志们说"为人民服务"
    /// @dev 只能在step为3的时候调用，只能同志们调用，并且只能说“为人民服务”
    /// @param content：当前同志们说的内容
    /// @return 当前的调用状态，true为成功
    function comfortRes(string calldata content)
        external
        onlySubordinate
        returns (bool)
    {
        if (step != 3) {
            revert(UNKNOWN);
        }
        if (!review(content, unicode"为人民服务")) {
            revert MyError(unicode"必须说：为人民服务");
        }
        step = 4;
        emit Step(step);
        return true;
    }

    /// @notice 用于领导对合约的销毁
    /// @dev 只能在step为4的时候调用，只能领导调用
    /// @return 当前的调用状态，true为成功
    function destruct()
        external
        payable
        onlyLeader
        returns (bool)
    {
        if (step != 4) {
            revert(UNKNOWN);
        }
        emit Log("destruct", msg.sender, address(this).balance, msg.data);
        selfdestruct(payable(msg.sender));
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
