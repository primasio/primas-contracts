pragma solidity ^0.4.23;

contract NodeInterface {

    function addNodeToWhitelist(address nodeAddress) public;

    function removeNodeFromWhitelist(address nodeAddress) public;

    function isInWhitelist(address nodeAddress) view public returns(bool);

    function joinNode(address coldAddress, address incentiveAddress) public;

    function quitNode() public;
}
