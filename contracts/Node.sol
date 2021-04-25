pragma solidity ^0.4.23;

import "./libs/RBAC.sol";
import "./interfaces/TokenInterface.sol";
import "./interfaces/NodeListInterface.sol";

contract Node is RBAC {

    TokenInterface tokenContract;
    NodeListInterface nodeListContract;

    uint256 nodeDepositAmount = 150000 * 10 ** 18;
    mapping(address => bool) nodeWhitelist;

    constructor(address _tokenAddr, address _nodeListAddr) public {
        initialOwner = msg.sender;
        tokenContract = TokenInterface(_tokenAddr);
        nodeListContract = NodeListInterface(_nodeListAddr);
    }

    function addNodeToWhitelist(address nodeAddress) public onlyOwner {
        nodeWhitelist[nodeAddress] = true;
    }

    function removeNodeFromWhitelist(address nodeAddress) public onlyOwner {
        nodeWhitelist[nodeAddress] = false;
    }

    function isInWhitelist(address nodeAddress) view public returns(bool) {
        return nodeWhitelist[nodeAddress] == true;
    }

    function joinNode(address coldAddress, address incentiveAddress) public {
        require(isInWhitelist(msg.sender) == true);
        tokenContract.tokenLock(coldAddress, nodeDepositAmount);
        nodeListContract.addNode(msg.sender, coldAddress, incentiveAddress);
    }

    function quitNode() public {
        require(isInWhitelist(msg.sender) == true);
        require(nodeListContract.isNode(msg.sender) == true);
        address coldAddress = nodeListContract.getNodeColdAddress(msg.sender);
        tokenContract.tokenUnlock(coldAddress, nodeDepositAmount, address(0), 0);
        nodeListContract.removeNode(msg.sender);
    }
}
