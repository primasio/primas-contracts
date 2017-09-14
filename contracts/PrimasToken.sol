pragma solidity ^0.4.8;

import "./StandardToken.sol";

contract PrimasToken is StandardToken {

    string public name = "Primas Token";
    uint8 public decimals = 18;
    string public symbol = "PST";
    string public version = 'V1.0';
    address initialOwner;
    unit initialAmount;
    unit deployTime;

    unit incentivesPool;
    unit lastInflationDayStart;

    address incentiveDistributors;

    function PrimasToken() {
        initialAmount = 100000000 * 10 ** decimals;
        balances[msg.sender] = initialAmount;
        totalSupply = initialAmount;
        initialOwner = msg.sender;
        deployTime = block.timestamp;

        incentivesPool = 0;
        lastInflationDayStart = 0;
    }

    function inflation() returns (bool success) {

        unit currentTime = block.timestamp;

        unit currentDayStart = currentTime / ( 24 * 3600 );

        if(lastInflationDayStart == currentDayStart)
        {
            return;
        }

        lastInflationDayStart = currentDayStart;

        unit currentInflationRateDoubled = 20 - ( currentTime - deployTime ) / ( 365 * 24 * 3600 );

        if(currentInflationRateDoubled <= 0)
        {
            return;
        }

        inflationAmount = initialAmount * currentInflationRateDoubled / 2;

        incentivesPool += inflationAmount;
        totalSupply += inflationAmount;
    }
}