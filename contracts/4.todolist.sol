// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.17;

contract TodoList {
    constructor() {}

    struct Task {
        string name;
        bool isCompleted;
    }
    Task[] public TaskList;

    // uint256 currentId = 0;
    // uint256[] IdArray = [];

    function createTask(string memory name_) external {
        TaskList.push(Task({name: name_, isCompleted: false}));
    }

    function renameTask1(uint256 index_, string calldata newName_) external {
        // 方法1：直接修改，修改一个属性的时候比较省gas
        TaskList[index_].name = newName_;
    }

    function renameTask2(uint256 index_, string calldata newName_) external {
        // 方法2：合适修改多个属性值
        Task storage temp = TaskList[index_];
        temp.name = newName_;
    }

    function toggleTaskStatus(uint256 index_) external {
        TaskList[index_].isCompleted = !TaskList[index_].isCompleted;
    }

    function modiStatus(uint256 index_, bool status) external {
        TaskList[index_].isCompleted = status;
    }

    function getStatus1(uint256 index_)
        external
        view
        returns (string memory name_, bool status_)
    {
        Task memory temp = TaskList[index_];
        return (temp.name, temp.isCompleted);
    }
    // storage: 1次拷贝
    //  预期： get2的gas费比较低，相对于 get1
    function getStatus2(uint256 index_)
        external
        view
        returns (string memory name_, bool status_)
    {
        Task storage temp = TaskList[index_];
        return (temp.name, temp.isCompleted);
    }
}

/*
需求：
1.创建任务
- 8点到公园里玩：false
2.修改任务名称
- 任务名写错的时候
3.修改完成状态：8点好公园里玩：true
- 手动指定完成 或者未完成
- 自动切换 toggle
    - 如果未完成状态下，改为完成
    - 如果完成状态，改为未完成
4.获取任务
    - 任务ID
*/
