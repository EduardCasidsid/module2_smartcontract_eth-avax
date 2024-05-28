import { useState, useEffect } from "react";
import { ethers } from "ethers";
import atm_abi from "../artifacts/contracts/Assessment.sol/Assessment.json";

export default function HomePage() {
  const [ethWallet, setEthWallet] = useState(undefined);
  const [account, setAccount] = useState(undefined);
  const [atm, setATM] = useState(undefined);
  const [balance, setBalance] = useState(undefined);
  const [transactionHistory, setTransactionHistory] = useState([]);
  const [interestRate, setInterestRate] = useState(undefined);
  const [loanAmount, setLoanAmount] = useState(0); // Added loan amount state
  const [paidLoan, setPaidLoan] = useState(false); // Added state for paid loan

  const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"; // Update with actual address
  const atmABI = atm_abi.abi;

  const getWallet = async () => {
    if (window.ethereum) {
      setEthWallet(new ethers.providers.Web3Provider(window.ethereum));
    }
  };

  const handleAccount = async () => {
    if (ethWallet) {
      const accounts = await ethWallet.listAccounts();
      if (accounts.length > 0) {
        console.log("Account connected: ", accounts[0]);
        setAccount(accounts[0]);
        getATMContract();
      } else {
        console.log("No account found");
      }
    }
  };

  const connectAccount = async () => {
    try {
      await window.ethereum.request({ method: "eth_requestAccounts" });
      handleAccount();
    } catch (error) {
      console.error("Error connecting account:", error);
    }
  };

  const getATMContract = async () => {
    const network = await ethWallet.getNetwork();
    console.log("Network:", network);
    if (network.chainId === 1337 || network.chainId === 31337) {
      // Localhost or Hardhat network
      const signer = ethWallet.getSigner();
      const atmContract = new ethers.Contract(contractAddress, atmABI, signer);
      setATM(atmContract);
    } else {
      console.error("Unsupported network");
    }
  };

  const getBalance = async () => {
    if (atm) {
      const balance = await atm.getBalance();
      setBalance(balance.toNumber());
      console.log("Balance fetched: ", balance.toNumber());
    }
  };

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
  

  const initUser = () => {
    if (!ethWallet) {
      return <p>Please install Metamask in order to use this ATM.</p>;
    }

    if (!account) {
      return <button onClick={connectAccount}>Please connect your Metamask wallet</button>;
    }

    if (balance === undefined) {
      getBalance();
    }

    return (
      <div>
        <p>Your Account: {account}</p>
        <p>Your Balance: {balance}</p>
        <button onClick={deposit}>Deposit 1000</button>
        <button onClick={withdraw}>Withdraw 500 ETH</button>
        <div>
          <button onClick={() => changeLoanAmount(20)}>Set Loan to 20%</button>
          <button onClick={() => changeLoanAmount(40)}>Set Loan to 40%</button>
        </div>
        {paidLoan ? (
          <p>Loan has been paid.</p>
        ) : (
          <div>
            <p>Loan Amount: {loanAmount}</p>
            <button onClick={payLoan}>Pay Loan</button>
          </div>
        )}
      </div>
    );
  };

  useEffect(() => {
    getWallet();
  }, []);

  return (
    <main className="container">
      <header>
        <h1>WELCOME TO MY LOAN ACCOUNT</h1>
      </header>
      {initUser()}
      <style jsx>{`
        .container {
          text-align: center;
        }
      `}</style>
    </main>
  );
}


