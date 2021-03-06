pragma solidity ^0.7.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.7/contracts/token/ERC20/ERC20.sol";

contract PLCurrency is ERC20 {
  
  constructor (
    string memory name,
    string memory symbol
  ) ERC20(name, symbol) {
    _mint(msg.sender, 100 * 10 ** uint(decimals()));
  }
}
