pragma solidity 0.5.0;
contract AquaProtocolInterface {
  function callbackDepositFiat(string memory _result, uint256 _id) public;
  function callbackWithdrawFiat(string memory _result, uint256 _id) public;
}
