// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title BankBoo - ระบบฝาก/ถอน/ตรวจสอบยอด ETH
contract BankBoo {
    mapping(address => uint256) private savings;

    event Deposited(address indexed account, uint256 amount);
    event Withdrawn(address indexed account, uint256 amount);

    function deposit() external payable {
        require(msg.value > 0, "Amount must be greater than zero");
        savings[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        uint256 current = savings[msg.sender];
        require(amount <= current, "Insufficient balance");

        savings[msg.sender] = current - amount;

        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "ETH transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    function checkBalance() external view returns (uint256) {
        return savings[msg.sender];
    }
}
