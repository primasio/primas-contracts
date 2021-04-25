pragma solidity ^0.4.23;

import "./Roles.sol";

contract RBAC {

    address initialOwner;

    using Roles for Roles.Role;

    mapping(string => Roles.Role) private roles;

    event RoleAdded(address addr, string roleName);
    event RoleRemoved(address addr, string roleName);

    modifier onlyOwner() {
        require(msg.sender == initialOwner);
        _;
    }

    function checkRole(address addr, string roleName) view public {
        roles[roleName].check(addr);
    }

    function hasRole(address addr, string roleName) view public returns (bool) {
        return roles[roleName].has(addr);
    }

    function addRole(address addr, string roleName) public onlyOwner {
        roles[roleName].add(addr);
        emit RoleAdded(addr, roleName);
    }

    function removeRole(address addr, string roleName) public onlyOwner {
        roles[roleName].remove(addr);
        emit RoleRemoved(addr, roleName);
    }

    modifier onlyRole(string roleName) {
        checkRole(msg.sender, roleName);
        _;
    }
}
