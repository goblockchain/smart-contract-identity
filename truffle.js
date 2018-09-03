var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "already tobacco penalty update helmet allow unlock session vivid upset quick turtle";

module.exports = {
    networks: {
        rinkeby: {
            provider: function () {
                return new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/v3/d46d0f948caa4977a97cdd2dbfce3228')
            },
            network_id: '4',
            gas: 4500000,
            gasPrice: 10000000000,
        },
        development: {
            gas: 4000000,
            host: '127.0.0.1',
            port: 7545,
            network_id: '*' // Match any network id
        }
    }
}
