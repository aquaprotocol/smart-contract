pragma solidity 0.5.0;
import "AquaProtocolInterface.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/ownership/Ownable.sol";
contract BankFunctionOracle is Ownable {
  uint private randNonce = 0;
  uint private modulus = 1000;
  
  mapping(uint256=>bool) pendingRequests;

  event InvokeFiatDepositEvent(
    uint256 amount,
    string bankAccountNumber,
    uint256 id
  );
  
  event InvokeFiatWithdrawEvent(
    uint256 amount,
    string bankAccountNumber, 
    uint256 id
  );
  
  event SetFiatDepositResultEvent(
    string _result,
    address _callerAddress,
    uint256 _id
  );
  
  event SetFiatWithdrawResultEvent(
    string _result, 
    address _callerAddress, 
    uint256 _id
  );
  
  function invokeFiatDeposit(
    uint256 _amount,
    string memory _bankAccountNumber
  ) public returns (uint256) {
    randNonce++;
    uint id = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % modulus;
    pendingRequests[id] = true;
    emit InvokeFiatDepositEvent(_amount, _bankAccountNumber, id);
    return id;
  }

  function invokeFiatWithdraw(
    uint256 _amount, 
    string memory _bankAccountNumber
  ) public returns (uint256) {
    randNonce++;
    uint id = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % modulus;
    pendingRequests[id] = true;
    emit InvokeFiatWithdrawEvent(_amount, _bankAccountNumber, id);
    return id;
  }

  function SetFiatDepositResult(
    string memory _result,
    address _callerAddress,
    uint256 _id
  ) public onlyOwner {
    require(pendingRequests[_id], "This request is not in my pending list.");
    delete pendingRequests[_id];
    AquaProtocolInterface aquaProtocolInterface;
    aquaProtocolInterface = AquaProtocolInterface(_callerAddress);
    aquaProtocolInterface.callbackDepositFiat(_result, _id);
    emit SetFiatDepositResultEvent(_result, _callerAddress,_id);
  }

  function SetFiatWithdrawResult(
    string memory _result, 
    address _callerAddress, 
    uint256 _id
  ) public onlyOwner {
    require(pendingRequests[_id], "This request is not in my pending list.");
    delete pendingRequests[_id];
    AquaProtocolInterface aquaProtocolInterface;
    aquaProtocolInterface = AquaProtocolInterface(_callerAddress);
    aquaProtocolInterface.callbackWithdrawFiat(_result, _id);
    emit SetFiatWithdrawResultEvent(_result, _callerAddress,_id);
  }
}
