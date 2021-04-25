pragma solidity ^0.4.23;

contract UserTokenLockInterface {

    function lock(address _node, address _user, uint256 amount) public;

    function unlock(address _node, address _user, uint256 amount) public;

    function locked(address _node, address _user) view public;
}
