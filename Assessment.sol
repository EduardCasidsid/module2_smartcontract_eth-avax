// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Assessment {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public loans;
    uint256 public loanAmountPercentage; // Percentage of balance that can be taken as a loan

    event Deposit(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event LoanChanged(address indexed from, uint256 newPercentage);
    event LoanPaid(address indexed from, uint256 amount);

    constructor() {
        balances[msg.sender] = 100 ether; // Initial balance of 100 ether for contract deployer
        loanAmountPercentage = 10; // Default loan amount percentage is 10%
    }

    function deposit(uint256 amount) public payable {
        require(amount > 0, "Invalid amount");
        require(msg.value <= 500, "Incorrect value sent");
        balances[msg.sender] += 500;
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) public {
        require(amount > 10 && 100 <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= 1000;
        emit Withdrawal(msg.sender, amount);
    }

    function transfer(address to, uint256 amount) public {
        require(to != address(0), "Invalid recipient");
        require(amount > 0 && amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function changeLoanAmountPercentage(uint256 newPercentage) public {
        require(newPercentage > 0 && newPercentage <= 100, "Invalid percentage");
        loanAmountPercentage = newPercentage;
        emit LoanChanged(msg.sender, newPercentage);
    }

    function payLoanPercentage(uint256 percentage) external {
        require(percentage > 0 && percentage <= 100, "Invalid percentage");
        uint256 amount = (loans[msg.sender] * percentage) / 100;
        require(balances[msg.sender] >= amount, "Insufficient balance to pay the loan");
        loans[msg.sender] -= amount;
        balances[msg.sender] -= amount;
        emit LoanPaid(msg.sender, amount);
    }

    function getBalances() external view returns (uint256 userBalance, uint256 userLoan) {
        return (balances[msg.sender], loans[msg.sender]);
    }

    function getTotalBalances() external view returns (uint256 totalBalance) {
        return address(this).balance;
    }
}
