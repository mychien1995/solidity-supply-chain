// migrating the appropriate contracts
var supplyChain = artifacts.require("./SupplyChain.sol");

module.exports = function(deployer) {
  deployer.deploy(supplyChain);
};
