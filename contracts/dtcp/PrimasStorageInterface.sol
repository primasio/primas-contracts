pragma solidity ^0.4.18;


// Our eternal storage interface
contract PrimasStorageInterface {
    // Modifiers
    modifier onlyLatestPrimasContract() {_;}
    // Getters
    function getAddress(bytes32 _key) external view returns (address);
    function getUint(bytes32 _key) external view returns (uint);
    function getString(bytes32 _key) external view returns (string);
    function getBytes(bytes32 _key) external view returns (bytes);
    function getBool(bytes32 _key) external view returns (bool);
    function getInt(bytes32 _key) external view returns (int);
    // Setters
    function setAddress(bytes32 _key, address _value) onlyLatestPrimasContract external;
    function setUint(bytes32 _key, uint _value) onlyLatestPrimasContract external;
    function setString(bytes32 _key, string _value) onlyLatestPrimasContract external;
    function setBytes(bytes32 _key, bytes _value) onlyLatestPrimasContract external;
    function setBool(bytes32 _key, bool _value) onlyLatestPrimasContract external;
    function setInt(bytes32 _key, int _value) onlyLatestPrimasContract external;
    // Deleters
    function deleteAddress(bytes32 _key) onlyLatestPrimasContract external;
    function deleteUint(bytes32 _key) onlyLatestPrimasContract external;
    function deleteString(bytes32 _key) onlyLatestPrimasContract external;
    function deleteBytes(bytes32 _key) onlyLatestPrimasContract external;
    function deleteBool(bytes32 _key) onlyLatestPrimasContract external;
    function deleteInt(bytes32 _key) onlyLatestPrimasContract external;
}
