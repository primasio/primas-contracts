pragma solidity ^0.4.8;

contract TokenInterface {

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    event Lock(address userAddress, uint256 amount);

    event Unlock(address userAddress, uint256 amount);

    event Inflate (uint256 incentivesPoolValue);

    function inflate() public returns (uint256);

    function getIncentivesPool() view public returns (uint256);

    function incentivesIn(address[] _users, uint256[] _values) public returns (bool success);

    function incentivesOut(address[] _users, uint256[] _values) public returns (bool success);

    function tokenLock(address _userAddress, uint256 _value) public;

    function tokenUnlock(address _userAddress, uint256 _amount, address _to, uint256 _toAmount) public;

    function transferAndLock(address _userAddress, address _to, uint256 _value) public;

    function balanceOf(address _owner) view public returns (uint256 balance);

    function transfer(address _to, uint256 _value) public returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    function approve(address _spender, uint256 _value) public returns (bool success);

    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
}

