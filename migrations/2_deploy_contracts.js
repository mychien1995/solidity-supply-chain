// migrating the appropriate contracts
var supplyChain = artifacts.require("./SupplyChain.sol");
var models = artifacts.require("./Models.sol");

module.exports = function(deployer) {
  deployer.deploy(models);
  deployer.deploy(supplyChain);
};
