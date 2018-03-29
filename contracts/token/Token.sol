pragma solidity ^0.4.8;

import "./StandardToken.sol";
import "./Ownable.sol";


contract Token is StandardToken, Ownable {

    /**** Properties ************/
    string public name;
    uint public decimals;
    string public symbol;
    string public version;
    address initialOwner;
    uint initialAmount;
    uint deployTime;

    // 增发
    uint lastInflationDayStart;
    // 奖励池
    uint incentivesPool;
    // 奖励
    address incentivesOperateContract;
    // 用户锁定的 PST
    mapping(address => uint) private memberStorage;
    // 发布文章锁定的 PST
    mapping(bytes32 => uint) private contentStorage;
    // 锁定时间
    mapping(bytes32 => uint) private tokenLockStorage;
    // 状态锁定信息
    mapping(bytes32 => uint256) private statusLockStorage;

    // 允许调用的合约地址
    mapping(address => bool) private linkContract;
    // 允许调用的node节点
    mapping(address => bool) private nodeOperator;


    /*** Events ****************/
    event Lock(
        address userAddress,
        uint resourceType,
        bytes resourceDNA,
        uint amount,
        uint expire
        );

    event Inflate (
        uint256 incentivesPoolValue
        );

    /*** Modifiers *************/

    modifier ownerOnly() {
        require(msg.sender == initialOwner);
        _;
    }

    modifier permissionContractOnly() {
        require(linkContract[msg.sender] == true);
        _;
    }

    modifier permissionNodeOnly() {
        require(nodeOperator[msg.sender] == true);
        _;
    }

    function updatePermissionContract(address _contract) ownerOnly() returns(bool) {
        require(linkContract[_contract] == false);
        linkContract[_contract] = true;
        return true;
    }

    function updatePermissionNode(address _operator) ownerOnly() returns(bool) {
        require(nodeOperator[_operator] == false);
        nodeOperator[_operator] = true;
        return true;
    }

    function deletePermissionContract(address _contract) ownerOnly() returns(bool) {
        require(linkContract[_contract] == true);
        linkContract[_contract] = false;
        return true;
    }

    function deletePermissionNode(address _operator) ownerOnly() returns(bool) {
        require(nodeOperator[_operator] == true);
        nodeOperator[_operator] = false;
        return true;
    }

    /*** Constructor *************/
    function Token() public {
        name = "Primas Token";
        decimals = 18;
        symbol = "PST";
        version = "V1.0";
        initialAmount = 100000000 * 10 ** decimals;
        balances[msg.sender] = initialAmount;
        totalSupply = initialAmount;
        initialOwner = msg.sender;
        deployTime = block.timestamp;
        incentivesPool = 0;
        lastInflationDayStart = 0;
    }

    /************* Methods *************/

    /* ====================== Inflation related methods ============================ */


    function inflate() public permissionNodeOnly() returns (uint) {

        uint currentTime = block.timestamp;

        uint currentDayStart = currentTime / 1 days;

        uint inflationAmount;

        require(lastInflationDayStart != currentDayStart);

        lastInflationDayStart = currentDayStart;

	    uint createDurationYears = (currentTime - deployTime) / 1 years;

	    if (createDurationYears < 1) {

            inflationAmount = initialAmount / 10 / 365;

        } else {

            inflationAmount = initialAmount / 1000 * (100 - (5 * createDurationYears * 1000)) / 365 ;
        }

        incentivesPool += inflationAmount;
        totalSupply += inflationAmount;

        Inflate(incentivesPool);

        return incentivesPool;
    }

    /// @dev Return incentives poll token amount
    function getIncentivesPool() view public returns (uint) {
        return incentivesPool;
    }

    /* ====================== Incentives related methods ============================ */

    function incentivesIn(address[] _users, uint[] _values) public permissionContractOnly() returns (bool success) {

        require(_users.length == _values.length);

        for (uint i = 0; i < _users.length; i++) {

            require(balances[_users[i]] - memberStorage[_users[i]]>= _values[i] && incentivesPool + _values[i] > incentivesPool);

            incentivesPool -= _values[i];

            balances[_users[i]] += _values[i];

            Transfer(_users[i], address(0), _values[i]);
        }
        return true;
    }

     function incentivesOut(address[] _users, uint[] _values) public permissionContractOnly() returns (bool success) {

        require(_users.length == _values.length);

        for (uint i = 0; i < _users.length; i++) {

            require(incentivesPool >= _values[i] && balances[_users[i]] + memberStorage[_users[i]] + _values[i] > balances[_users[i]]);

            incentivesPool -= _values[i];

            balances[_users[i]] += _values[i];

            Transfer(address(0), _users[i], _values[i]);
        }
    }


    // 对内容提供锁定 PST 功能
    function tokenTimeLock(address userAddress, bytes dna, uint value, uint releaseTime) public permissionContractOnly() {
        bytes32 lockReason = keccak256(userAddress, dna);

        require(releaseTime > now);

        require(contentStorage[lockReason] == 0);

        require(balanceOf(userAddress) >= value);

        memberStorage[userAddress] += value;

        contentStorage[lockReason] = value;

        tokenLockStorage[lockReason] = releaseTime;

        Lock(userAddress, 1, dna, value, releaseTime);

        contentTokenLockInfo[userAddress].push(lockReason);
    }

    function autoReleaseLockToken(address _userAddress) returns(uint) {

        uint256 amount;

        for (uint i = 0; i < contentTokenLockInfo[_userAddress].length; i++) {

            var dna = contentTokenLockInfo[_userAddress][i];

            var contentLockTime = tokenLockStorage[dna];
            var contentLockValue = contentStorage[dna];

            if ( now > contentLockTime && contentLockValue > 0) {
                amount += contentLockValue;
            }
        }

        return amount;
    }

    // 解锁 PST 锁定状态
    function tokenTimeUnlock(address userAddress, bytes dna) public permissionContractOnly() {

        bytes32 lockReason = keccak256(userAddress, dna);

        require(tokenLockStorage[lockReason] > now);

        var lockAmount = contentStorage[lockReason];

        contentStorage[lockReason] -= lockAmount;

        memberStorage[userAddress] -= lockAmount;
    }

    // 对身份或状态锁定 PST
    // eg：
    //      加入社区，PST 将在社区解散或退出社区时解锁，因此不能设置固定的锁定时间
    //      作者身份，长期锁定 PST
    function tokenStatusLock(address userAddress, bytes dna, uint amount) public permissionContractOnly() {

        bytes32 lockReason = keccak256(userAddress, dna);

        require(statusLockStorage[lockReason] == 0);

        require(balanceOf(userAddress) >= amount);

        statusTokenLockInfo[userAddress].push(lockReason);

        memberStorage[userAddress] += amount;

        statusLockStorage[lockReason] = amount;

        Lock(userAddress, 0, dna, amount, 0);

    }

    // 解锁因身份状态锁定的 PST
    function tokenStatusUnlock(address userAddress, bytes dna) public permissionContractOnly() {

        bytes32 lockReason = keccak256(userAddress, dna);

        require(statusLockStorage[lockReason] != 0);

        var lockAmount = statusLockStorage[lockReason];

        memberStorage[userAddress] -= lockAmount;

        delete statusLockStorage[lockReason];

    }

    mapping(address => bytes32[]) contentTokenLockInfo;
    mapping(address => bytes32[]) statusTokenLockInfo;

    /* ====================== Token related methods ============================ */

    function balanceOf(address _owner) constant public returns (uint256 balance) {
        var amount = autoReleaseLockToken(_owner);
        return balances[_owner] - memberStorage[_owner] + amount;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {

        var amount = autoReleaseLockToken(msg.sender);

        require(balances[msg.sender] - memberStorage[msg.sender] >= _value && balances[_to] + _value > balances[_to]);

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balances[_from] - memberStorage[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);

        balances[_to] += _value;
        balances[_from] -= _value;

        allowed[_from][msg.sender] -= _value;

        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function burns(address _from, uint256 _value) public returns (bool success) {

        require(balances[_from] - memberStorage[_from] >= _value);

        balances[_from] -= _value;

        totalSupply -= _value;

        Transfer(_from, address(0), _value);

        return true;
    }
}
