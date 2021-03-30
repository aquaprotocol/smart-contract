pragma solidity ^0.5.0;

import {SafeMath} from 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/math/SafeMath.sol';
import {IERC721} from './IERC721.sol';
import "./BasePicture.sol";


/// TODO: Replace this with natspec descriptions
contract Picture is BasePicture, IERC721 {

  using SafeMath for uint256;

  mapping (uint => address) pictureApprovals;

  function balanceOf(
    address _owner
  ) external view returns (uint256) {
    return ownerPictureCount[_owner];
  }

  function ownerOf(
    uint256 _tokenId
  ) external view returns (address) {
    return pictureToOwner[_tokenId];
  }

  function _transfer(
    address _from, 
    address _to,
    uint256 _tokenId
  ) private {
    ownerPictureCount[_to] = ownerPictureCount[_to].add(1);
    ownerPictureCount[msg.sender] = ownerPictureCount[msg.sender].sub(1);
    pictureToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) external payable {
    require (pictureToOwner[_tokenId] == msg.sender || pictureApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(
    address _approved,
    uint256 _tokenId
  ) external payable onlyOwnerOf(_tokenId) {
    pictureApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

  function create(
    string memory _issuerId, 
    string memory _series,
    uint256 _numberFrom,
    uint256 _numberTo,
    uint256 _price
  ) public {}

  function create(
    string memory _name,
    uint256 _price
  ) public {
    creatPicture(_name, _price);
  }
  
  function create(
    string memory _name,
    string memory _typeOf,
    string memory _date, 
    uint256 _price
  ) public {}
  
}
