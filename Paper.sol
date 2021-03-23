pragma solidity ^0.5.0;

import {SafeMath} from 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/math/SafeMath.sol';
import {IERC721} from './IERC721.sol';
import "./BasePaper.sol";


/// TODO: Replace this with natspec descriptions
contract Paper is BasePaper, IERC721 {

  using SafeMath for uint256;

  mapping (uint => address) paperApprovals;

  function balanceOf(address _owner) external view returns (uint256) {
    return ownerPaperCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return paperToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerPaperCount[_to] = ownerPaperCount[_to].add(1);
    ownerPaperCount[msg.sender] = ownerPaperCount[msg.sender].sub(1);
    paperToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    require (paperToOwner[_tokenId] == msg.sender || paperApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    paperApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }
  
  function create(string memory _issuerId, string memory _series, uint256 _numberFrom, uint256 _numberTo, uint256 _price) public {
      creatPaper(_issuerId, _series, _numberFrom, _numberTo, _price);
  }

  function create(string memory _name, uint256 _price) public {}
 
  function create(string memory _name, string memory _typeOf, uint256 _date, uint256 _price) public {}   
}
