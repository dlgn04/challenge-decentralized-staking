// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IExampleExternalContract {
    function complete() external payable;
}

contract Staker {
    event Stake(address indexed staker, uint256 amount);

    mapping(address => uint256) public balances;
    uint256 public constant threshold = 1 ether;

    IExampleExternalContract public exampleExternalContract;

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = IExampleExternalContract(exampleExternalContractAddress);
    }

    function stake() public payable {
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender, msg.value);
    }
}
