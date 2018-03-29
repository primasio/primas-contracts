pragma solidity ^0.4.0;

import "./TokenInterface.sol";

contract Incentive {

    address initialOwner;
    address nodeOperator;

    TokenInterface PST;

    function Incentive(address tokenAddress) {
        initialOwner = msg.sender;
        PST = TokenInterface(tokenAddress);
    }

    modifier permissionNodeOnly() {
        require(msg.sender == nodeOperator);
        _;
    }

    modifier ownerOnly() {
        require(msg.sender == initialOwner);
        _;
    }

    function updateNode(address _nodeAddress) public ownerOnly() {
        nodeOperator = _nodeAddress;
    }

    function grantIncentives(address[] recipients, uint[] amounts) public permissionNodeOnly() {
        PST.incentivesOut(recipients, amounts);
    }

}
