pragma solidity ^0.4.0;

contract MetadataInterface {

    address contentContract;
    address initOwner;

    modifier ContentContractOnly() {
        _;
    }

    modifier OwnerOnly() {
        _;
    }

    event PublishLog(
        bytes title,
        bytes contentHash,
        bytes license,
        bytes extras,
        bytes blockHash,
        bytes signature,
        bytes DNA
    );

    event LikeLog(
        bytes articleDNA,
        bytes groupDNA,
        bytes signature
    );

    event CommentLog(
        bytes articleDNA,
        bytes groupDNA,
        bytes ContentHash,
        bytes signature
    );

    event ShareLog(
        bytes articleDNA,
        bytes groupsDNA,
        bytes signature
    );

    function updateContentContract(address contentAddress) public OwnerOnly();

    function publish(
        bytes title,
        bytes contentHash,
        bytes license,
        bytes extras,
        bytes blockHash,
        bytes signature,
        bytes DNA
    ) public ContentContractOnly();

    function like(
        bytes articleDNA,
        bytes groupDNA,
        bytes signature
    ) public ContentContractOnly();

    function comment(
        bytes articleDNA,
        bytes groupDNA,
        bytes contentHash,
        bytes signature
    ) public ContentContractOnly();

    function share(
        bytes articleDNA,
        bytes groupsDNA,
        bytes signature
    ) public ContentContractOnly();
}
