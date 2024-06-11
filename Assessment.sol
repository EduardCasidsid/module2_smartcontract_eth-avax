// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Assessment {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public loans;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    function changeLoanAmount(uint256 _percentage) external {
        require(_percentage <= 100, "Percentage should be less than or equal to 100");
        loans[msg.sender] = (balances[msg.sender] * _percentage) / 100;
    }

    function payLoan() external {
        require(balances[msg.sender] >= loans[msg.sender], "Insufficient balance to pay the loan");
        balances[msg.sender] -= loans[msg.sender];
        loans[msg.sender] = 0;
    }

    function transfer(address _recipient, uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
    }
}
