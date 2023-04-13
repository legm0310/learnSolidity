// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Tether {
  string public name = 'Mock Tether Token';
  string public symbol = 'mUSDT';
  uint256 public totalSupply = 1000000000000000000000000;
  uint8 public decimals = 18;

  event Transfer(
    address indexed _from,
    address indexed _to,
    uint _value
  );

  event Approval(
    address indexed _owner,
    address indexed _spender,
    uint _value
  );

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  constructor() {
    balanceOf[msg.sender] = totalSupply;
  }

  function transfer(address _to, uint _value) public returns (bool success) {
    // require that the value is greater or equal for transfer
    require(balanceOf[msg.sender] >= _value); 
    // transfer the amount and subtract the balance
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value) public returns (bool success) {
    allowance[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  //제 3자가 가스비를 대신 지불하고 from에서 to주소로 토큰을 지불함
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    require(_value <= balanceOf[_from]);
    require(_value <= allowance[_from][msg.sender]);
    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    allowance[msg.sender][_from] -= _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
  }
}