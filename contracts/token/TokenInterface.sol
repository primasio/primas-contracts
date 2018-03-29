pragma solidity ^0.4.8;

import "./StandardToken.sol";
import "./Ownable.sol";


contract TokenInterface  {

    event Lock(address userAddress,uint resourceType,bytes resourceDNA,uint amount,uint expire);

    event Inflate (uint256 incentivesPoolValue);

    modifier ownerOnly() {_;}

    modifier permissionContractOnly() {_;}

    modifier permissionNodeOnly() {_;}

    function updatePermissionContract(address _contract) public ownerOnly();

    function updatePermissionNode(address _operator) public ownerOnly();

    function deletePermissionContract(address _contract) public ownerOnly();

    function deletePermissionNode(address _operator) public ownerOnly();

    function inflate() public permissionNodeOnly() returns (uint);

    function getIncentivesPool() view public returns (uint) ;

    function incentivesIn(address[] _users, uint[] _values) public permissionContractOnly() returns (bool success);

    function incentivesOut(address[] _users, uint[] _values) public permissionContractOnly() returns (bool success);

    function tokenTimeLock(address userAddress, bytes dna, uint value, uint releaseTime) public permissionContractOnly();

    function autoReleaseLockToken(address _userAddress) internal returns(uint);

    function tokenTimeUnlock(address userAddress, bytes dna) public permissionContractOnly();

    function tokenStatusLock(address userAddress, bytes dna, uint amount) public permissionContractOnly();

    function tokenStatusUnlock(address userAddress, bytes dna) public permissionContractOnly();

    function burns(address _from, uint256 _value) public ;
}
