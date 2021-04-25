pragma solidity ^0.4.23;

import "./libs/RBAC.sol";

contract NodeList is RBAC {

    struct NodeInstance {
        bool exist;
        address coldAddress;
        address incentiveAddress;
    }

    mapping(address => NodeInstance) private nodes;

    constructor() public {
        initialOwner = msg.sender;
    }

    function addNode(address nodeAddress, address coldAddress, address incentiveAddress) public onlyRole("NodeListOperator") {
        nodes[nodeAddress].coldAddress = coldAddress;
        nodes[nodeAddress].incentiveAddress = incentiveAddress;
        nodes[nodeAddress].exist = true;
    }

    function removeNode(address nodeAddress) public onlyRole("NodeListOperator") {
        nodes[nodeAddress].exist = false;
    }

    function isNode(address nodeAddress) view public returns (bool) {
        return nodes[nodeAddress].exist == true;
    }

    function getNodeColdAddress(address nodeAddress) view public returns (address) {
        return nodes[nodeAddress].coldAddress;
    }

    function getNodeIncentiveAddress(address nodeAddress) view public returns (address) {
        return nodes[nodeAddress].incentiveAddress;
    }
}
