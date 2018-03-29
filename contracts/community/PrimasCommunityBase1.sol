//pragma solidity ^0.4.0;
//
//import "../token/StandardToken.sol";
//import "../contract/Ownable.sol";
//import "../interface/PrimasStorageInterface.sol";
//
//contract PrimasCommunityBase is StandardToken {
//    address initialOwner;
//
//    function PrimasCommunityBase() public {
//        initialOwner = msg.sender;
//    }
//
//    // 创建社区需锁定一部分 PST（社区address）
//    mapping(address => uint) private createCommunityStorage;
//    //  加入社区需锁定一部分 PST（社区address）
//    mapping(address => uint) private joinCommunityStorage;
//    //  用户锁定 PST(用户address)
//    mapping(address => uint) private userStorage;
//
//    /*** Events ****************/
//
//    event CommunityAddedToPool (    //创建社区记录
//        address indexed _createrAddress,
//        address indexed _communityAddress,
//        address indexed _pool,
//        uint256 created
//    );
//
//    event UpdateCommunityLog (
//        address indexed _operator,
//        address indexed _communityAddress,
//        uint256 amount,
//        uint256 created
//    );
//
//    /*** Methods *************/
//
//    //记录社区存在
//    mapping(bytes32 => bool) private communityRecord;
//    //用户创建社区的标记,value为花费的PST值
//    mapping(address => mapping (bytes32 => uint)) private userCreateCommunity;
//
//    //创建社区，需判断创建者是否有创建资格,冻结一定的PST
//    function createCommunity(address _operator, address _community, uint _value) ownerOnly() public {
//        require(_value >= 0);
//
//        createCommunityStorage[_community] = _value;
//
//        userStorage[_operator] += _value;
//
//        UpdateCommunityLog(_operator, _community, _value, now);
//    }
//
//    //解散社区，归还创建者以及所有加入者的PST，释放社区address
//    function releaseCommunity(address _operator,address _community) ownerOnly() public {
//        var lockAmount = createCommunityStorage[_community];
//        createCommunityStorage -= lockAmount;
//        userStorage -= lockAmount;//释放创建者PST
//        //还需要释放所有参与者PST
//
//    }
//
//    //用户加入社区的标记,value为花费的PST值
//    mapping(address => mapping (bytes32 => uint)) private userInCommunity;
//
//    //加入社区，需判断加入者是否有加入资格,冻结一定的PST(没有转移)
//    function joinCommunity(address _operator, address _community, uint _value) ownerOnly() public {
//        require(_value>0);
//
//        joinCommunityStorage[_community] = _value;
//
//        userStorage[_operator] += _value;
//
//        UpdateCommunityLog(_operator, _community, _value, now);
//
//    }
//
//    //退出社区，归还加入者PST(ownerOnly存疑)
//    function leaveCommunity(address _operator,address _community) ownerOnly() public {
//
//        var lockAmount = joinCommunityStorage[_community];
//
//        joinCommunityStorage -= lockAmount;
//
//        userStorage -= lockAmount;
//    }
//
//
//}
