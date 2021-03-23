pragma solidity ^0.5.0;

contract IERC721 {
  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

  function balanceOf(address _owner) external view returns (uint256);
  function ownerOf(uint256 _tokenId) external view returns (address);
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
  function approve(address _approved, uint256 _tokenId) external payable;
  
  function create(string memory _issuerId, string memory _series, uint256 _numberFrom, uint256 _numberTo, uint256 _price) public;
   function create(string memory _name, uint256 _price) public;
   
     function create(string memory _name, string memory _typeOf, uint256 _date, uint256 _price) public;
}

