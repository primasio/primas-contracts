pragma solidity ^0.4.0;

import "./MetadataInterface.sol";
import "./TokenInterface.sol";

contract Content {

    MetadataInterface metadata;
    TokenInterface token;

    function Content(address _tokenAddress, address _metadataAddress){
        token = TokenInterface(_tokenAddress);
        metadata = MetadataInterface(_metadataAddress);
    }

    function publish(
        bytes title,
        bytes contentHash,
        bytes license,
        bytes extras,
        bytes blockHash,
        bytes signature,
        bytes DNA,
        address userAddress
    ) public {

        address pk = recover(keccak256(title, contentHash, license), signature);

        require(pk == userAddress);

        uint256 expireTime = now + 3600;

        token.tokenTimeLock(userAddress, DNA, 20 * 10 ** 18, expireTime);

        metadata.publish(title, contentHash, license, extras, blockHash, signature, DNA);
    }

    function like(
        bytes articleDNA,
        bytes groupDNA,
        bytes signature,
        address userAddress
    ) public {

        address pk = recover(keccak256(articleDNA, groupDNA),signature);

        require(pk == userAddress);

        metadata.like(articleDNA,groupDNA,signature);
    }

    function comment(
        bytes articleDNA,
        bytes groupDNA,
        bytes contentHash,
        bytes signature,
        address userAddress
    ) public {
        address pk = recover(keccak256(articleDNA, groupDNA, contentHash), signature);

        require(pk == userAddress);

        metadata.comment(articleDNA,groupDNA,contentHash,signature);
    }

    function share(
        bytes articleDNA,
        bytes groupsDNA,
        bytes signature,
        address userAddress
    ) public {
        address pk = recover(keccak256(articleDNA,groupsDNA),signature);

        require(pk == userAddress);

        metadata.share(articleDNA,groupsDNA,signature);
    }

    function recover(
        bytes32 hash,
        bytes signature
    ) internal pure returns(address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        //Check the signature length
        if (signature.length != 65) {
          return (address(0));
        }

        // Divide the signature in r, s and v variables
        assembly {
          r := mload(add(signature, 32))
          s := mload(add(signature, 64))
          v := byte(0, mload(add(signature, 96)))
        }
        if (v < 27) {
            v += 27;
        }
        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
          return (address(0));
        } else {
          return ecrecover(hash, v, r, s);
        }
  }
}
