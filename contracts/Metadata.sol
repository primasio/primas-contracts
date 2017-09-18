pragma solidity ^0.4.15;

contract Metadata {

  struct DTCP {
    string _type_;
    string language;
    string title;
    string _abstract_;
    string category;
    uint   created;
    string creator;
    string creator_id;
    string content_hash;
    string signature;
    string similarity_socre;
  }

  struct Repository {
    DTCP dtcp;
    address block_hash;
    bool is_real;
  }

  mapping(string => Repository) repositories;

  function publish(
    address block_hash, 
    string dna, 
    string _type_, 
    string language, 
    string title, 
    string _abstract_, 
    string category,
    uint created,
    string creator,
    string creator_id,
    string content_hash,
    string signature,
    string similarity_socre
    ) {
        
    if (repositories[dna].is_real) revert();

    repositories[dna] = Repository({
      is_real: true,
      block_hash: block_hash, 
      dtcp: DTCP(_type_,
        language,
        title,
        _abstract_,
        category,
        created,
        creator,
        creator_id,
        content_hash,
        signature,
        similarity_socre)
      });
  }

  function querySimple(string dna) constant returns(
    string _type_,
    string language,
    string title,
    string _abstract_,
    string category
  ) {

    Repository storage repository = repositories[dna];
    if (! repository.is_real) revert();
    DTCP storage dtcp = repository.dtcp;

    return (dtcp._type_, dtcp.language, dtcp.title, dtcp._abstract_, dtcp.category);
  }

  function queryDetail(string dna) constant returns(
    address block_hash,
    uint   created,
    string creator,
    string creator_id,
    string content_hash,
    string signature,
    string similarity_socre
  ) {

    Repository storage repository = repositories[dna];
    if (! repository.is_real) revert();
    DTCP storage dtcp = repository.dtcp;

    return (
      repository.block_hash, dtcp.created, dtcp.creator, dtcp.creator_id,
      dtcp.content_hash, dtcp.signature, dtcp.similarity_socre
    );
  }

}