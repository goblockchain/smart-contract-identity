var PersonIdentity = artifacts.require("./identity/PersonIdentity.sol");

module.exports = function(deployer) {
  deployer.deploy(PersonIdentity);
};
