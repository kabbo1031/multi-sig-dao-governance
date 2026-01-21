// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiSig {
    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Confirm(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required;

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public confirmed;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "Owners required");
        require(_required > 0 && _required <= _owners.length, "Invalid required");
        for (uint i = 0; i < _owners.length; i++) {
            isOwner[_owners[i]] = true;
            owners.push(_owners[i]);
        }
        required = _required;
    }

    receive() external payable { emit Deposit(msg.sender, msg.value); }

    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner {
        transactions.push(Transaction(_to, _value, _data, false));
        emit Submit(transactions.length - 1);
    }

    function confirm(uint _txId) external onlyOwner {
        require(!confirmed[_txId][msg.sender], "Already confirmed");
        confirmed[_txId][msg.sender] = true;
        emit Confirm(msg.sender, _txId);
    }

    function execute(uint _txId) external {
        Transaction storage transaction = transactions[_txId];
        uint count = 0;
        for (uint i = 0; i < owners.length; i++) {
            if (confirmed[_txId][owners[i]]) count++;
        }
        require(count >= required, "Not enough signatures");
        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "TX failed");
        emit Execute(_txId);
    }
}
