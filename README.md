# smart-contract-identity
Projeto responsável pelo registro dos colaboradores.

## Projeto
Nesse projeto o usuário informa que deseja participar da *DAO*, se aprovado ele entra para a organização e se torna um colaborador.

Para participar é necessário realizar o cadastro com o *uPort* e aceitar os termos e condições da organização, após isso seu pedido fica como pendente.
Um perfil específico da organização pode aprovar ou recusar, é necessário no mínimo o aceite de *30% dos colaboradores já cadastrados*.

## Entidades

> PersonIdentity.sol contém as funções para adicionar uma solicitação de participação e para aprovar ou recusar as solicitações.

> Collaborator.sol contém todos os colaboradores e seu o perfil de acordo com sua a reputação.

> TermsAndCondition.sol contém o hash atual do termo e condição da organização.

## Instalação
```
- Faça um fork
- git clone seu_repo
- cd smart-contract-identity
- npm install
- npm install truffle
```
Para testar você pode utilizar o geth em desenvolvimento ou Ganache.

```
- truffle compile
- truffle migrate
- truffle test
```

## Enviar alterações

- Execute os testes e garante que as implementações estão sendo cobertas pelos testes
- Envie o pull request para o repositório original
