pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/token/ERC20/ERC20.sol";
import {ERC20Detailed} from 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/token/ERC20/ERC20Detailed.sol';
import {SafeERC20} from 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/token/ERC20/SafeERC20.sol';
import {SafeMath} from 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/math/SafeMath.sol';
import {IERC721} from "./IERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/ownership/Ownable.sol";
import "./Treasury.sol";
import "./BankFunctionOracleInterface.sol";

contract AquaProtocol is Ownable {
    
    using SafeMath for uint256;
    using SafeERC20 for ERC20Detailed;
    
    BankFunctionOracleInterface private oracleInstance;
    
    mapping(uint256=>bool) myRequests;
    mapping(address => address) internal assetList;
    
    address tokenAddress;
    address private oracleAddress;
    
    event Deposit(
        address indexed reserve,
        address user,
        address indexed onBehalfOf,
        uint256 amount
  );
  
      event Withdraw(
        address indexed reserve,
        address user,
        address indexed onBehalfOf,
        uint256 amount
  );
  
    event CallbackDepositFiatEvent (
        string _result, 
        uint256 _id
  );
    event DepositFiatEvent(string bankAccountAddress, uint256 amount);
    event NewOracleAddressEvent(address oracleAddress);
    
    event BuyPaperEvent(address owner, string issuerId, string series, uint256 numberFrom, uint256 numberTo, uint256 amount);
    
    event BuyArtEvent(address owner, string name,  uint256 amount);
  
    function deposit(
    address asset,
    uint256 amount,
    address onBehalfOf
  ) external {
      
    //tokenAddress  = assetList[asset];
    tokenAddress = asset;
      
    Treasury(tokenAddress).mint(onBehalfOf, amount);
    
    ERC20Detailed(asset).safeTransferFrom(msg.sender, tokenAddress, amount);

    emit Deposit(asset, msg.sender, onBehalfOf, amount);
  }
  
    function depositFiat(
    address asset,
    uint256 amount,
    string calldata bankAccountAddress,
    address ethAddress
  ) external {
      
    //tokenAddress  = assetList[asset];
      
    tokenAddress = asset;
    
    Treasury(tokenAddress).mint(ethAddress, amount);
    
    uint256 id = oracleInstance.invokeFiatDeposit(amount, bankAccountAddress);
    myRequests[id] = true;
  
    emit DepositFiatEvent(bankAccountAddress, amount);
  }
  
      function withdraw(
    address asset,
    address ethAddress,
    uint256 amount,
    address onBehalfOf
  ) external {
     
    Treasury(asset).burn(ethAddress, onBehalfOf, msg.sender, amount);
    
    emit Withdraw(asset, msg.sender, onBehalfOf, amount);
  }
  
        function withdrawFiat(
    address asset,
    address ethAddress,
    string calldata bankAccountAddress,
    uint256 amount,
    address onBehalfOf
  ) external {
    Treasury(asset).burnFiat(ethAddress, onBehalfOf, msg.sender, amount);
   uint256 id = oracleInstance.invokeFiatWithdraw(amount, bankAccountAddress);
    myRequests[id] = true;  
    emit Withdraw(asset, msg.sender, onBehalfOf, amount);
  }
  
  function buyPaper(
  address asset,
  address tokenAddress,
  address operator,
        uint256 amount,
        string memory issuerId,
        string memory series,
        uint256 numberFrom,
        uint256 numberTo) public {

     Treasury(asset).internalTransfer(asset, operator, amount);

      IERC721(tokenAddress).create(issuerId, series, numberFrom, numberTo, amount);
      
      emit BuyPaperEvent(msg.sender, issuerId, series, numberFrom, numberTo, amount);
  }
  
  
  
    function buyArt(
  address asset,
  address tokenAddress,
  address operator,
        uint256 amount,
        string memory name)
        public {

     Treasury(asset).internalTransfer(asset, operator, amount);

      IERC721(tokenAddress).create(name, amount);
      
      emit BuyArtEvent(msg.sender, name,  amount);
  }
  
      function buyInsurance(
  address asset,
  address tokenAddress,
  address operator,
  
        uint256 amount,
        string memory name,
       string memory _typeOf, 
       uint256 _date
       )
        public {

     Treasury(asset).internalTransfer(asset, operator, amount);

      IERC721(tokenAddress).create(name, _typeOf, _date, amount);
      
      emit BuyArtEvent(msg.sender, name,  amount);
  }
  
    function callbackDepositFiat(string memory _result, uint256 _id) public onlyOracle {
    require(myRequests[_id], "This request is not in my pending list.");
    delete myRequests[_id];
    emit CallbackDepositFiatEvent(_result, _id);
  }
  
      function callbackWithdrawFiat(string memory _result, uint256 _id) public onlyOracle {
    require(myRequests[_id], "This request is not in my pending list.");
    delete myRequests[_id];
    emit CallbackDepositFiatEvent(_result, _id);
  }

  function setOracleInstanceAddress(address _oracleInstanceAddress) public onlyOwner {
      oracleAddress = _oracleInstanceAddress;
    oracleInstance = BankFunctionOracleInterface(oracleAddress);
    emit NewOracleAddressEvent(oracleAddress);
  }
  
  modifier onlyOracle {
    require(msg.sender == oracleAddress, "You are not authorized to call this function.");
    _;
  }

}

