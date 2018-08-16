var TermsAndCondition = artifacts.require("./TermsAndCondition.sol");

module.exports = function(deployer) {
  deployer.deploy(TermsAndCondition);
};
