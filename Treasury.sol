pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/token/ERC20/ERC20.sol";
import {ERC20Detailed} from 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/token/ERC20/ERC20Detailed.sol';
import {SafeERC20} from 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/token/ERC20/SafeERC20.sol';

contract Treasury is ERC20, ERC20Detailed  {

  using SafeERC20 for ERC20Detailed;

  event Mint(
    address a,
    uint256 amount
  );
  
  event Burn(
    address a,
    address b,
    uint256 amount
  );
  
  event BurnFiat(
    address a,
    address b,
    uint256 amount
  );
  
  event InternalTransfer(
    address _target,
    uint256 _amount
  );

  constructor () 
  public ERC20Detailed("PLCOIN", "PLC",18) {
    _mint(msg.sender, 100 * 10 ** uint(18));
  }


  function mint(
    address onBehalfOf, 
    uint256 amount
  ) public {
    _mint(onBehalfOf, amount);
    emit Mint(onBehalfOf, amount);
  }

  function burn(
    address asset,
    address receiverOfUnderlying,
    address user,
    uint256 amount
  ) external {
    _burn(user, amount);
    ERC20Detailed(asset).safeTransfer(receiverOfUnderlying, amount);
    emit Burn(user, receiverOfUnderlying, amount);
  }

  function burnFiat(
    address asset,
    address receiverOfUnderlying,
    address user,
    uint256 amount
  ) external {
    _burn(user, amount);
    emit BurnFiat(user, receiverOfUnderlying, amount);
  }

  function internalTransfer(
    address asset, 
    address _target, 
    uint256  _amount
  ) external {
    _transfer(asset, _target, _amount);
    emit InternalTransfer(_target, _amount);
  }
  
}
