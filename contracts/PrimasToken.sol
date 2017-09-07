pragma solidity ^0.4.8;

import "./StandardToken.sol";

contract PrimasToken is StandardToken {

    string public name = "Primas Token";
    uint8 public decimals = 18;
    string public symbol = "PST";
    string public version = 'V1.0';
    address initialOwner;

    function PrimasToken() {
        initialAmount = 100000000 * 10 ** decimals;
        balances[msg.sender] = initialAmount;
        totalSupply = initialAmount;
        initialOwner = msg.sender;
    }
}