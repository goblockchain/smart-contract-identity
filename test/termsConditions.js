//set terms
//verify the last
//check an equal hash
// check a wrong hash

require("./test-setup");

var TermsAndCondition = artifacts.require("TermsAndCondition");

contract('TermsAndCondition', function (accounts) {
    var terms;
    var advisor = accounts[0];
    var incorrectColab = accounts[1];    

    before("Carregar o contrato", async function () {
        terms = await TermsAndCondition.deployed()
    });

    it("Informa o termo e condições", async function () {
        await terms.setTermsAndCondition("teste", {
            from: advisor
        });
        (await terms.validHash()).should.be.equal("teste");
        (await terms.hashTerms().length).should.be.bignumber.equal(1);        
    })   

	it("Deveria prevenir que uma conta inválida possa alterar os termos", async function() {
        await terms.setTermsAndCondition("teste", {from: incorrectColab}).shouldBeReverted();        
	});
})