//TermsAndCondition


//positivo-solicitar participação como colaborador requestApprove
//positivo-validar colaborador pendente - validate
//erro= validar colaborador sem ser um colaborador - validate


require("./testSetup");

var PersonIdentity = artifacts.require("PersonIdentity");

contract('PersonIdentity', function (accounts) {
    var advisor = accounts[0];
    var incorrectColab = accounts[1];
    var ROLE_ADMIN = "admin";
    var ROLE_COLLABORATOR = "collaborator";
    var numberOfColabs = 0;
    before("Carregar o contrato", async function () {
        personIdentity = await PersonIdentity.deployed()
    });

    it("Colaborador deve ser válido", async function () {
        (await personIdentity.hasRole(advisor, ROLE_ADMIN)).should.be.equal(true);
        numberOfColabs++;
    });

    it("Colaborador deve ser inválido", async function () {
        (await personIdentity.hasRole(incorrectColab, ROLE_ADMIN)).should.be.equal(false);
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
        var trueCollaborador = accounts[0];
        await personIdentity.validate(_hashUport, true, {from: trueCollaborador});
        numberOfColabs++;
    });     
    
    it("Deve novo colaborador estar aprovado", async function () {
        let _hashUport = "uport";
        let colab = (await personIdentity.getPersonByIdUport(_hashUport));
        let status = colab[1];
        (status).should.be.bignumber.equal(1);        
    });

    it("O campo uPort deve estar preenchido", async function () {
        let novoColab = accounts[4];
        let _hashTerms = "cde";
        let _accepted = true;
        await personIdentity.requestApprove("", _hashTerms, _accepted, {from: novoColab}).shouldBeReverted();
    });  

    it("O campo hashTerms deve estar preenchido", async function () {
        let novoColab = accounts[5];
        let _hashUport = "uport";
        let _accepted = true;
        await personIdentity.requestApprove(_hashUport, "", _accepted, {from: novoColab}).shouldBeReverted();
    }); 

    it("Necessário preencher o uPort a ser pesquisado", async function () {
        await personIdentity.getPersonByIdUport("").shouldBeReverted();         
    });    

    it("Necessário preencher o uPort do colaborador", async function () {
        var trueCollaborador = accounts[1];
        await personIdentity.validate("", true, {from: trueCollaborador}).shouldBeReverted();        
    });    

    it("Colaborador já possuí uPort cadastrado", async function () {
        let novoColab = accounts[2];
        let _hashUport = "newUport";
        let _hashTerms = "cde";
        let _accepted = true;
        await personIdentity.requestApprove(_hashUport, _hashTerms, _accepted, {from: novoColab}).shouldBeReverted();
    });  
    
    it("Lista de person deve ser igual a quantidade de colaboradores adicionados", async function () {      
        let personCount = (await personIdentity.getListPerson()).toNumber();
        (personCount).should.be.equal(numberOfColabs);
    })

})