pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/ownership/Ownable.sol";
import {SafeMath} from 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/math/SafeMath.sol';

contract BasePicture is Ownable {

  using SafeMath for uint256;
  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;


  event NewPictureEvent(uint256 id, string name, uint256 _price, uint256 _id);

  struct Picture {
    string name;
    uint256 price;
    uint256 id;
  }

  Picture[] public pictures;

  mapping (uint => address) public pictureToOwner;
  mapping (address => uint) ownerPictureCount;

  function _createPicture(
    string memory _name,
    uint256 _price,
    uint256 _id
  ) internal {
    uint id = pictures.push(Picture(_name, _price, _id)) - 1;
    pictureToOwner[id] = msg.sender;
    ownerPictureCount[msg.sender] = ownerPictureCount[msg.sender].add(1);
    emit NewPictureEvent(id, _name,  _price, _id);
  }

  function _generateRandomId(
    string memory _name
  ) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_name)));
    return rand % dnaModulus;
  }

  function creatPicture(
    string memory _name, 
    uint256 _price
  ) internal {
    uint randId = _generateRandomId(_name);
    randId = randId - randId % 100;
    _createPicture(_name, _price, randId);
  }
  
  modifier onlyOwnerOf(uint _paperId) {
    require(msg.sender == pictureToOwner[_paperId]);
    _;
  }
}
