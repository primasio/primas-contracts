var Migrations = artifacts.require("./lib/Migrations.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
