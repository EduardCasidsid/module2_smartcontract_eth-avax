// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Assessment {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => bool) public loanStatus;
    uint256 public interestRate = 10; // 10%

    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);
    event LoanTaken(address indexed account, uint256 amount);
    event LoanRepaid(address indexed account, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function takeLoan(uint256 amount) external {
        require(!loanStatus[msg.sender], "You already have a pending loan");
        require(amount <= balances[msg.sender], "Insufficient balance for loan");
        uint256 interest = (amount * interestRate) / 100;
        balances[msg.sender] -= amount + interest;
        loanStatus[msg.sender] = true;
        emit LoanTaken(msg.sender, amount);
    }

    function repayLoan() external payable {
        require(loanStatus[msg.sender], "No pending loan to repay");
        uint256 amount = balances[msg.sender];
        balances[msg.sender] += msg.value;
        if (msg.value >= amount) {
            loanStatus[msg.sender] = false;
            emit LoanRepaid(msg.sender, amount);
        }
    }

    function setInterestRate(uint256 rate) external onlyOwner {
        interestRate = rate;
    }
}
