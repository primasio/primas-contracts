pragma solidity ^0.4.8;

contract PrimasTokenInterface {

    /*** Events ****************/
    event UserDeposit (address indexed _from,string  poolStakingTimeID,uint256 value,uint256 created);
    event UserAddedToPool (address indexed _userAddress,address indexed _partnerAddress,address indexed _pool,uint256 created );
    event UserSetBackupWithdrawalAddress (address indexed _userAddress,address indexed _userBackupAddress,address indexed _pool,uint256 created );
    event UserChangedToWithdrawalAddress (address indexed _userAddress,address indexed _userNewAddress,address indexed _pool,uint256 created );
    event UserDepositTokensWithdrawal (address indexed _userAddress,uint256 amount,uint256 tokenAmount,uint256 created);
    event Transferred (address indexed _from,address indexed _to, bytes32 indexed _typeOf, uint256 value,uint256 created);
    event FlagUint (uint256 flag);
    event FlagAddress (address flag);

    /*** Modifier ****************/
    modifier ownerOnly() {_;}
    modifier authorOnly(address _address) {_;}
    modifier incentivesOperatorsOnly () {_;}

    /*** Functions ****************/
    function inflate() ownerOnly() public returns (bool success);
    function getIncentivesPool() view public returns (uint);
    function updateIncentivesOperator(address _operator, uint _value) ownerOnly() public returns (bool success);
    function incentivesIn(uint _value) incentivesOperatorsOnly () public returns (bool success);
    function incentivesOut(uint _value) incentivesOperatorsOnly () public returns (bool success);
    function tokenTimeLock(address _beneficiary, bytes32 _dna, uint _value, uint _releaseTime) ownerOnly() public;
    function checkAuthorRequire(address _authorAddress) view public returns(bool);
    function penaltyAuthor(address _fineUser, uint _fineAmount) public;
    function updateAuthorMember(address _operator, uint _value) ownerOnly() public;
    function releaseArticleLockToken(address _beneficiary, bytes32 _dna) ownerOnly() public;


    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    function allowance(address owner, address spender) public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
}
