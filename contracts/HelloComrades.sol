// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.17;

contract HelloComrades {
    /*
     * =========================
     * State Variables
     * =========================
     */

    address public immutable leader;

    /*
     * =========================
     * Events
     * =========================
     */
    event Log(string tag, address from, uint256 amount, bytes data);

    constructor() {
        
    }

    /*
     * =========================
     * Helper 辅助函数
     * =========================
     */
    /*
     * =========================
     * Helper 辅助函数
     * =========================
     */

    function review2(string calldata content, string calldata correctContent)
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
