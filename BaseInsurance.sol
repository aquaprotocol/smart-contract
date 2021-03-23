pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/ownership/Ownable.sol";
import {SafeMath} from 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/math/SafeMath.sol';

contract BaseInsurance is Ownable {

  using SafeMath for uint256;

  event NewInsurance(uint id, string name, string typeOf, string date, uint256 _price, uint256 _id);
    
  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;

  struct Insurance {
    string name;
    string typeOf;
    string date;
    uint256 price;
    uint256 id;
  }

  Insurance[] public insurances;

  mapping (uint => address) public insuranceToOwner;
  mapping (address => uint) ownerInsuranceCount;

  function _createInsurance(string memory _name, string memory _typeOf, string memory _date,  uint256 _price, uint256 _id) internal {
    uint id = insurances.push(Insurance(_name, _typeOf, _date, _price, _id)) - 1;
    insuranceToOwner[id] = msg.sender;
    ownerInsuranceCount[msg.sender] = ownerInsuranceCount[msg.sender].add(1);
    emit NewInsurance(id, _name, _typeOf, _date, _price, _id);
  }

  function _generateRandomId(string memory _name) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_name)));
    return rand % dnaModulus;
  }

  function creatInsurance(string memory _name, string memory _typeOf, string memory _date, uint256 _price) internal {
    uint randId = _generateRandomId(_name);
    randId = randId - randId % 100;
    _createInsurance(_name, _typeOf, _date, _price, randId);
  }

  modifier onlyOwnerOf(uint _paperId) {
    require(msg.sender == insuranceToOwner[_paperId]);
    _;
  }
}
