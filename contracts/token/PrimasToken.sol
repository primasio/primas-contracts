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

    function PrimasToken() {
        initialAmount = 100000000 * 10 ** decimals;
        balances[msg.sender] = initialAmount;
        totalSupply = initialAmount;
        initialOwner = msg.sender;
        deployTime = block.timestamp;

        incentivesPool = 0;
        lastInflationDayStart = 0;
    }

    modifier ownerOnly() {
        require(msg.sender == initialOwner);
        _;
    }


    /* ====================== Inflation related methods ============================ */

    unit lastInflationDayStart;

    function inflate() returns (bool success) {

        unit currentTime = block.timestamp;

        unit currentDayStart = currentTime / ( 24 * 3600 );

        if(lastInflationDayStart == currentDayStart)
        {
            return false;
        }

        lastInflationDayStart = currentDayStart;

        unit currentInflationRateDoubled = 20 - ( currentTime - deployTime ) / ( 365 * 24 * 3600 );

        if(currentInflationRateDoubled <= 0)
        {
            return false;
        }

        inflationAmount = initialAmount * currentInflationRateDoubled / 2;

        incentivesPool += inflationAmount;
        totalSupply += inflationAmount;

        return true;
    }

    /* ====================== Incentives related methods ============================ */

    modifier incentivesOperatorsOnly () {
        require(incentivesOperators[msg.sender] == 1);
        _;
    }

    function updateIncentivesOperator(address _operator, unit _value) ownerOnly() returns (bool success) {
        if(_value != 0)
        {
            incentivesOperators[_operator] = 1;
        }else{
            incentivesOperators[_operator] = 0;
        }

        return true;
    }

    function incentivesIn(unit _value) incentivesOperatorsOnly () returns (bool success) {

        require(balances[msg.sender] >= _value && incentivesPool + _value > incentivesPool);

        balances[msg.sender] -= _value;
        incentivesPool += _value;

        return true;
    }

    function incentivesOut(unit amount) incentivesOperatorsOnly () returns (bool success) {
        require( incentivesPool >= _value && balances[msg.sender] + _value > balances[msg.sender]);

        incentivesPool -= _value;
        balances[msg.sender] += _value;

        return true;
    }
}