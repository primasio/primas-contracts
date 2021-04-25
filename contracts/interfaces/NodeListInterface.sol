pragma solidity ^0.4.23;

contract NodeListInterface {

    function addNode(address nodeAddress, address coldAddress, address incentiveAddress) public;

    function removeNode(address nodeAddress) public;

    function isNode(address nodeAddress) view public returns (bool);

    function getNodeColdAddress(address nodeAddress) view public returns (address);

    function getNodeIncentiveAddress(address nodeAddress) view public returns (address);
}
