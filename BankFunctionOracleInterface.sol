pragma solidity 0.5.0;
contract BankFunctionOracleInterface {
  function invokeFiatDeposit(uint256 _amount, string memory _bankAccountNumber) public returns (uint256);
  function invokeFiatWithdraw(uint256 _amount, string memory _bankAccountNumber) public returns (uint256);
}

