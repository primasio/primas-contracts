pragma solidity ^0.4.15;

import "./TokenInterface.sol";
import "./ECRecovery.sol";

contract Group {

    TokenInterface PST;

    function Group(address tokenAddress) {
        PST = TokenInterface(tokenAddress);
    }

    event CreateLog (
        bytes title,
        bytes description,
        bytes signature
    );

    event AddMemberLog (
        bytes groupDNA,
        bytes signature
    );

    event RemoveMemberLog (
        bytes groupDNA,
        bytes signature
    );

    event RemoveMemberByOwnerLog(
        bytes groupDNA,
        address groupMemberAddress,
        bytes signature
    );

    function create(bytes DNA, bytes title, bytes description, bytes signature, address userAddress) public {

        require(ECRecovery.recover(keccak256(title, description), signature) == userAddress);

        uint amount = 10 * 10 ** 18;

        GroupLock(userAddress, DNA, amount);

        CreateLog(title, description, signature);
    }

    function addMember(bytes DNA, bytes signature, address memberAddress) public {

        require(ECRecovery.recover(keccak256(DNA), signature) == memberAddress);

        uint amount = 2 * 10 ** 18;

        GroupLock(memberAddress, DNA, amount);

        AddMemberLog(DNA, signature);
    }

    function removeMember(bytes DNA, bytes signature, address memberAddress) public {

        require(ECRecovery.recover(keccak256(DNA), signature) == memberAddress);

        GroupUnlock(memberAddress, DNA);

        RemoveMemberLog(DNA, signature);
    }

    function removeMemberByOwner(bytes DNA, address memberAddress, bytes signature, address ownerAddress) public {
        require(ECRecovery.recover(keccak256(DNA, memberAddress), signature) == ownerAddress);

        GroupUnlock(memberAddress, DNA);

        RemoveMemberByOwnerLog(DNA, memberAddress, signature);
    }

    function GroupLock(address user, bytes DNA, uint amount) internal {

        PST.tokenStatusLock(user, DNA, amount);
    }

    function GroupUnlock(address user, bytes DNA) internal {

        PST.tokenStatusUnlock(user, DNA);
    }

}
