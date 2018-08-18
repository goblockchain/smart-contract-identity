//TermsAndCondition


//positivo-solicitar participação como colaborador requestApprove
//positivo-validar colaborador pendente - validate
//erro= validar colaborador sem ser um colaborador - validate


require("./testSetup");

var PersonIdentity = artifacts.require("PersonIdentity");

contract('PersonIdentity', function (accounts) {
    var advisor = accounts[0];
    var incorrectColab = accounts[1];    
    before("Carregar o contrato", async function () {
        personIdentity = await PersonIdentity.deployed()
    });

    it("Colaborador deve ser válido", async function () {
        (await personIdentity.isCollaborator(advisor)).should.be.equal(true);
    });

    it("Colaborador deve ser inválido", async function () {
        (await personIdentity.isCollaborator(incorrectColab)).should.be.equal(false);
    });  

    it("Termo de adesão deve ser válido", async function () {
        (await personIdentity.getValidHash()).should.be.equal("abc");
    });

    it("Alteração do termo deve ser inválida", async function () {
        await personIdentity.setTermsAndCondition("cde", {from: incorrectColab}).shouldBeReverted();
    });   

    it("Termo de adesão deve ser alterado", async function () {
        await personIdentity.setTermsAndCondition("cde", {from: advisor});
        (await personIdentity.getValidHash()).should.be.equal("cde");
    });    

    it("Deve permitir a inserção de membros ao conselho", async function () {
        var advisors = [accounts[1]];
        await personIdentity.addAdvisors(advisors, {from: advisor});
        (await personIdentity.isCollaborator(accounts[1])).should.be.equal(true);
    });

    it("Deve permitir a solicitação de aprovação para colaborador", async function () {
        let novoColab = accounts[2];
        let _hashUport = "uport";
        let _hashTerms = "cde";
        let _accepted = true;
        await personIdentity.requestApprove(_hashUport, _hashTerms, _accepted, {from: novoColab});
    });    

    it("Novo colaborador deve existir como pendente", async function () {
        let _hashUport = "uport";
        let novoColab = accounts[2];
        let colab = (await personIdentity.getPersonByIdUport(_hashUport));
        let addresss = colab[0];
        let status = colab[1];
        (addresss).should.be.equal(novoColab);   
        (status).should.be.bignumber.equal(0);        
    });       

    it("Não deve permitir a aprovação por membros que não são colaboradores", async function () {
        let _hashUport = "uport";
        var falseCollaborador = accounts[3];
        await personIdentity.validate(_hashUport, true, {from: falseCollaborador}).shouldBeReverted();
    });

    it("Não deve permitir a aprovação de uport inválido", async function () {
        let _hashUport = "uportInvalido";
        var falseCollaborador = accounts[1];
        await personIdentity.validate(_hashUport, true, {from: falseCollaborador}).shouldBeReverted();
    }); 

    it("Deve realizar a aprovação do novo colaborador", async function () {
        let _hashUport = "uport";
        var trueCollaborador = accounts[1];
        await personIdentity.validate(_hashUport, true, {from: trueCollaborador});
    });     
    
    it("Deve novo colaborador estar aprovado", async function () {
        let _hashUport = "uport";
        let colab = (await personIdentity.getPersonByIdUport(_hashUport));
        let status = colab[1];
        (status).should.be.bignumber.equal(1);        
    });        
})


// contract('TermsAndCondition', function (accounts) {
//     var terms;
//     var advisor = accounts[0];
//     var incorrectColab = accounts[1];    

//     before("Carregar o contrato", async function () {
//         personIdentity = await PersonIdentity.deployed()
//     });

//     it("Carregar o contrato", async function () {
//         console.info(await personIdentity.getValidHash())
//     });         
// })


// it("Informa o termo e condições", async function () {
//     await personIdentity.setTermsAndCondition("abc", {
//         from: advisor
//     });
//     console.info(await personIdentity.getValidHash());
//     (await personIdentity.getValidHash()).should.be.equal("abc");
// })  