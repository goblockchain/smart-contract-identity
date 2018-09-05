var PersonIdentity = artifacts.require("PersonIdentity");

module.exports = async function(deployer, network, accounts) {
	var advisor = accounts[0];
	await deployer.deploy(PersonIdentity, "genesis", {from: advisor});
	let personIdentity = await PersonIdentity.deployed();
	await personIdentity.setTermsAndCondition("abc", {from: advisor});
}