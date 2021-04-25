pragma solidity ^0.4.23;

import "./libs/RBAC.sol";
import "./libs/SafeMath.sol";

contract UserTokenLock is RBAC {

    using SafeMath for uint256;

    mapping(address => mapping(address => uint256)) private nodeLockedTokens;

    constructor() public {
        initialOwner = msg.sender;
    }

    function lock(address _node, address _user, uint256 _amount) public onlyRole("Locker") {
        nodeLockedTokens[_node][_user] = nodeLockedTokens[_node][_user].add(_amount);
    }

    function unlock(address _node, address _user, uint256 _amount) public onlyRole("Unlocker") {
        require(nodeLockedTokens[_node][_user] >= _amount);
        nodeLockedTokens[_node][_user] = nodeLockedTokens[_node][_user].sub(_amount);
    }

    function locked(address _node, address _user) view public returns(uint256) {
        return nodeLockedTokens[_node][_user];
    }
}
