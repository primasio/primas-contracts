pragma solidity ^0.4.23;

import "./libs/RBAC.sol";
import "./libs/SafeMath.sol";
import "./interfaces/TokenInterface.sol";
import "./interfaces/NodeListInterface.sol";
import "./interfaces/UserTokenLockInterface.sol";

contract User is RBAC {

    using SafeMath for uint256;

    TokenInterface tokenContract;
    NodeListInterface nodeListContract;
    UserTokenLockInterface userTokenLockContract;
    mapping(string => bool) usedNonce;

    event UserTokenBurnLog(address userAddress, uint256 amount);
    event UserTokenLockLog(address userAddress, address nodeAddress, uint256 amount);
    event UserTokenUnlockLog(address userAddress, address nodeAddress, uint256 amount, uint256 nodeFee);

    constructor(address _tokenAddr, address _nodeListAddr, address _userTokenLockAddr) public {
        initialOwner = msg.sender;
        tokenContract = TokenInterface(_tokenAddr);
        nodeListContract = NodeListInterface(_nodeListAddr);
        userTokenLockContract = UserTokenLockInterface(_userTokenLockAddr);
    }

    function burn(address userAddress, uint256 amount) public {
        require(nodeListContract.isNode(msg.sender));
        address[] memory users = new address[](1);
        users[0] = userAddress;
        uint256[] memory amounts = new uint[](1);
        amounts[0] = amount;
        tokenContract.incentivesIn(users, amounts);
        userTokenLockContract.unlock(msg.sender, userAddress, amount);
        emit UserTokenBurnLog(userAddress, amount);
    }

    function preTokenLock(address userAddress, uint256 amount, string nonce, bytes signature) public {
        validateSignature(userAddress, amount, nonce, signature);
        require(nodeListContract.isNode(msg.sender));
        tokenContract.tokenLock(userAddress, amount);
        userTokenLockContract.lock(msg.sender, userAddress, amount);
        emit UserTokenLockLog(userAddress, msg.sender, amount);
    }

    function preTokenUnlock(address userAddress, uint256 amount, uint256 nodeFee) public {
        require(nodeListContract.isNode(msg.sender));
        userTokenLockContract.unlock(msg.sender, userAddress, amount);
        tokenContract.tokenUnlock(userAddress, amount, nodeListContract.getNodeColdAddress(msg.sender), nodeFee);
        emit UserTokenUnlockLog(userAddress, msg.sender, amount, nodeFee);
    }

    function transferAndPreLock(address _to, uint256 _amount) public {
        require(nodeListContract.isNode(msg.sender));
        tokenContract.transferAndLock(msg.sender, _to, _amount);
        userTokenLockContract.lock(msg.sender, _to, _amount);
        emit UserTokenLockLog(_to, msg.sender, _amount);
    }

    function validateSignature(address userAddress, uint256 amount, string nonce, bytes signature) internal {
        require(usedNonce[nonce] == false);
        usedNonce[nonce] = true;
        bytes memory signatureString = abi.encodePacked(userAddress, amount, nonce);
        bytes32 signatureHash = keccak256(signatureString);
        address pk = recover(signatureHash, signature);
        require(pk == userAddress);
    }

    function recover(bytes32 hash, bytes sig) public pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        if (sig.length != 65) {
            return (address(0));
        }

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }

        if (v < 27) {
            v += 27;
        }

        if (v != 27 && v != 28) {
            return (address(0));
        } else {
            return ecrecover(hash, v, r, s);
        }
    }
}
