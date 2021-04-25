pragma solidity ^0.4.23;

import "./libs/RBAC.sol";
import "./interfaces/NodeListInterface.sol";

contract Package is RBAC {

    NodeListInterface nodeListContract;

    event Packinglog(address nodeAddress, string LogType, bytes RootHash);

    constructor(address _nodeListAddr) public {
        initialOwner = msg.sender;
        nodeListContract = NodeListInterface(_nodeListAddr);
    }

    function triggerLog(string _logName, bytes _rootHash) public {
        require(nodeListContract.isNode(msg.sender) == true);
        emit Packinglog(msg.sender, _logName, _rootHash);
    }
}
