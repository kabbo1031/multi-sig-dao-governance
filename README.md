# Multi-Sig DAO Governance

This repository contains a secure, minimalist implementation of a Multi-Signature wallet designed for DAO (Decentralized Autonomous Organization) treasury management. It follows the "M-of-N" authorization pattern.

### Features
* **Threshold Signatures:** Transactions require a predefined number of confirmations before execution.
* **Proposal Management:** On-chain record of all proposed transactions.
* **Native Asset Support:** Handles ETH and ERC20 token transfers.
* **Flat Architecture:** All logic contained in the root for easy auditing.

### How it Works
1. **Submit:** Any owner can propose a transaction.
2. **Confirm:** Other owners provide cryptographic signatures (confirmations).
3. **Execute:** Once the threshold is met, anyone can trigger the execution.
