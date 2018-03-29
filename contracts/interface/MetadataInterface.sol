pragma solidity ^0.4.0;

contract PrimasMetadataInterface {
    /*** Events ****************/
    // Metadata events
    event MetadataPublishLog(bytes title,bytes content_hash,bytes license,bytes extras,bytes block_hash,bytes signature);

    // Primas Metadata events
    event LikeLog(bytes indexed _dna);
    event CommentLog(bytes indexed _dna);
    event ForwardLog(bytes indexed _dna,bytes indexed _community);
    event ReproduceLog(bytes indexed _dna,bytes indexed _link);

    /*** Functions ****************/
    // Metadata functions
    function publish(bytes title,bytes content_hash,bytes license,bytes extras,bytes block_hash,bytes signature) internal;
    function sign_publish(bytes title,bytes content_hash,bytes license,bytes extras,bytes block_hash,bytes signature) public returns (bytes);
    function bytesToBytes32(bytes memory source) internal returns (bytes32 result);
    function bytes32ToString(bytes32 x) constant private returns (string);
    function ecrecoverDecode(bytes32 sig_mag, bytes32 r, bytes32 s, byte v1) internal returns (address addr);
    function Bytes32toBytes(bytes32 x) internal returns (bytes);
    function slice(bytes memory data, uint start, uint len) internal returns (bytes);

    // Primas Metadata functions
    function like(bytes dna,bytes signature) public returns(address);
    function comment(bytes title,bytes content_hash,bytes license,bytes extras,bytes block_hash,bytes signature) public returns (bytes);
    function forward(bytes dna,bytes community,bytes signature) public returns(address);
    function reproduce(bytes dna,bytes link,bytes signature) public returns(address);
    function recover(bytes32 hash,bytes sig) internal pure returns(address);
}
