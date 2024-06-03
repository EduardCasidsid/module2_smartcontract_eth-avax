// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

//import "hardhat/console.sol";

contract Assessment {
    address payable public owner;
    uint256 public balance;

    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);

    constructor(uint initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
    }

    function getBalance() public view returns(uint256){
        return balance;
    }

    function deposit(uint256 _amount) public payable {
        uint _previousBalance = balance;

        // make sure this is the owner
        require(msg.sender == owner, "You are not the owner of this account");

        // perform transaction
        balance += _amount;

        // assert transaction completed successfully
        assert(balance == _previousBalance + _amount);

        // emit the event
        emit Deposit(_amount);
    }

    // custom error
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public {
        require(msg.sender == owner, "You are not the owner of this account");
        uint _previousBalance = balance;
        if (balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _withdrawAmount
            });
        }

        // withdraw the given amount
        balance -= _withdrawAmount;

        // assert the balance is correct
        assert(balance == (_previousBalance - _withdrawAmount));

        // emit the event
        emit Withdraw(_withdrawAmount);


 const executeTransaction = async (transaction) => {
    try {
      const receipt = await transaction.wait();
      console.log("Transaction hash:", receipt.transactionHash);
      console.log("Gas used:", receipt.gasUsed.toString());
      console.log("Block number:", receipt.blockNumber);
      console.log("Confirmations:", receipt.confirmations);
      getBalance();
      // Add transaction to history
      setTransactionHistory([...transactionHistory, receipt]);
    } catch (error) {
      console.error("Transaction error:", error);
    }
  };

  const deposit = async () => {
    if (atm) {
      const tx = await atm.deposit(1000);
      executeTransaction(tx);
    }
  };

  const withdraw = async () => {
    if (atm) {
      const tx = await atm.withdraw(500);
      executeTransaction(tx);
    }
  };

  const changeLoanAmount = (percentage) => {
    const newLoanAmount = balance * (percentage / 100);
    setLoanAmount(newLoanAmount);
  };

  const payLoan = () => {
    if (balance >= loanAmount) {
      const newBalance = balance - loanAmount;
      setBalance(newBalance);
      setPaidLoan(true);
    } else {
      console.log("Insufficient funds to pay the loan.");
    }
  };
    }
}
