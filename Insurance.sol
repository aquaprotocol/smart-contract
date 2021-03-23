pragma solidity ^0.5.0;

import {SafeMath} from 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/math/SafeMath.sol';
import {IERC721} from './IERC721.sol';
import "./BaseInsurance.sol";

contract Insurance is BaseInsurance, IERC721 {

  using SafeMath for uint256;

  mapping (uint => address) insuranceApprovals;

  function balanceOf(address _owner) external view returns (uint256) {
    return ownerInsuranceCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return insuranceToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerInsuranceCount[_to] = ownerInsuranceCount[_to].add(1);
    ownerInsuranceCount[msg.sender] = ownerInsuranceCount[msg.sender].sub(1);
    insuranceToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    require (insuranceToOwner[_tokenId] == msg.sender || insuranceApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    insuranceApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }
  
  function create(string memory _issuerId, string memory _series, uint256 _numberFrom, uint256 _numberTo, uint256 _price) public {
  }
  
function create(string memory _name, uint256 _price) public {}
  
  function create(string memory _name, string memory _typeOf, string memory _date, uint256 _price) public {
        creatInsurance(_name, _typeOf, _date, _price);
  }

}
