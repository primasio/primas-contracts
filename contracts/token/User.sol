pragma solidity ^0.4.0;

import "./TokenInterface.sol";
import "./ECRecovery.sol";

contract User {

    TokenInterface PST;

    address initialOwner;
    address nodeOperator;

    mapping(address => UserInfo) private UserInfoStorage;

    struct UserInfo {
        string name;
        string icon;
    }

    modifier ownerOnly() {
        require(msg.sender == initialOwner);
        _;
    }

    event UserTokenBurnLog(
        address userAddress,
        uint256 amount
        );

    function User(address tokenAddress) {
        initialOwner = msg.sender;
        PST = TokenInterface(tokenAddress);
    }

    function burn(string timestamp, bytes signature, address user) public {

        address pk = ECRecovery.recover(keccak256("burn", timestamp), signature);

        require(pk == user);

        uint256 amount = 2 * 10 ** 18;

        PST.burns(user, amount);

        UserTokenBurnLog(user, amount);
    }

    function updateUserName(string name, bytes signature, address user ) public {

        address pk = ECRecovery.recover(keccak256(name), signature);

        require(pk == user);

        var userData = UserInfoStorage[user];

        userData.name = name;
    }

    function updateUserIcon(string icon, bytes signature, address user ) public {

        address pk = ECRecovery.recover(keccak256(icon), signature);

        require(pk == user);

        var userData = UserInfoStorage[user];

        userData.icon = icon;
    }
}
