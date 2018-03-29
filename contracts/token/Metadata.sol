pragma solidity ^0.4.16;

contract Metadata {

    address contentContract;
    address initOwner;

    function Metadata() {
        initOwner = msg.sender;
    }

    modifier ContentContractOnly() {
        require(msg.sender == contentContract);
        _;
    }

    modifier OwnerOnly() {
        require(msg.sender == initOwner);
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

    function updateContentContract(address contentAddress) public OwnerOnly() {
        contentContract = contentAddress;
    }

    function publish(
        bytes title,
        bytes contentHash,
        bytes license,
        bytes extras,
        bytes blockHash,
        bytes signature,
        bytes DNA
    ) public ContentContractOnly() {
        PublishLog(title, contentHash, license, extras, blockHash, signature, DNA);
    }

    function like(
        bytes articleDNA,
        bytes groupDNA,
        bytes signature
    ) public ContentContractOnly() {
        LikeLog(articleDNA, groupDNA, signature);
    }

    function comment(
        bytes articleDNA,
        bytes groupDNA,
        bytes contentHash,
        bytes signature
    ) public ContentContractOnly() {
        CommentLog(articleDNA, groupDNA, contentHash, signature);
    }

    function share(
        bytes articleDNA,
        bytes groupsDNA,
        bytes signature
    ) public ContentContractOnly() {
        ShareLog(articleDNA, groupsDNA, signature);
    }

}
