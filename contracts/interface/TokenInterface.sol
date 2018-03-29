pragma solidity ^0.4.8;

contract TokenInterface {


    modifier ownerOnly() {_;}
    modifier incentivesOperateContractOnly () {_;}

    function PrimasToken(address _primasStorageAddress) public ;

    function inflate() ownerOnly() public returns (bool success) ;

    function getIncentivesPool() view public returns (uint) ;


    function setIncentivesContract(address _contractAddress) ownerOnly() ;

    function incentivesIn(address[] _users,uint[] _values) incentivesOperateContractOnly() public returns (bool success) ;

    function incentivesOut(address[] _users, uint[] _values) incentivesOperateContractOnly() public returns (bool success);

    function tokenTimeLock(address _userAddress, bytes32 _dna, uint _value, uint _releaseTime) public ;

    function tokenStatusLock(address _userAddress, bytes32 _lockReason, uint _amount) ;

    function getStatusLockAmount(bytes32 _lockReason) constant public returns(uint) ;

    function releaseArticleLockToken(address _userAddress, bytes32 _dna) ownerOnly() public ;

    function tokenStatusUnlock(address _userAddress, bytes32 _lockReason) ;

    function autoReleaseLockToken(address _userAddress) returns(uint) ;

    function balanceOf(address _owner) constant public returns (uint256 balance) ;

    function transfer(address _to, uint256 _value) public returns (bool success) ;

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) ;

    function burns(address _from, uint256 _value) public returns (bool success) ;
}
