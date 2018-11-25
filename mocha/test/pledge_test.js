Eos = require('eosjs')
var fs = require("fs");
var assert = require('assert');
var accounts = fs.readFileSync("accounts.json");
var TransactionBuilder = require('../utils/transaction_builder');

process.on('unhandledRejection', (reason, promise) => {
  //console.log('Unhandled Rejection at:', reason.stack || reason)
  // Recommended: send the information to sentry.io
  // or whatever crash reporting service you use
})

let config = {
  env: 'development',
  requiredFields: {
    accounts:[
      {
        protocol: 'http',
        blockchain: 'eos',
        chainId: 'cf057bbfb72640471fd910bcb67639c22df9f92470936cddc1ade0e2f2e7dc4f',
        host: '127.0.0.1',
        expireInSeconds: 3600,
        verbose: false,
        port: 8888
      }
    ]
  },
  eos: {
    httpEndpoint: 'http://127.0.0.1:8888',
    chainId: 'cf057bbfb72640471fd910bcb67639c22df9f92470936cddc1ade0e2f2e7dc4f',
    keyProvider: '5JXT8YAsNvtipDH6oFon75EdFLHZ1x8VmwgBz2kz3be7Jr3kW4S',
    verbose: false
  },
  code: {
    patreostoken: 'patreostoken',
    patreosblurb: 'patreosblurb',
    patreosmoney: 'patreosmoney',
    patreosnexus: 'patreosnexus',
    patreosvault: 'patreosvault'
  },
  patreosSymbol: 'PATR'
};

//console.log(JSON.parse(accounts));

eos = Eos(config.eos);

/*
const patreosBalance = eos.getCurrencyBalance('patreostoken', 'xokayplanetx', 'PATR');
patreosBalance.then((response) => {
  console.log(response);
}).catch(error => {
  console.log('An error occurred: ' + JSON.stringify(error)); //eslint-disable-line
});

const vaultBalance = eos.getCurrencyBalance('patreosvault', 'xokayplanetx');
vaultBalance.then((response) => {
  console.log(response);
}).catch(error => {
  console.log('An error occurred: ' + JSON.stringify(error)); //eslint-disable-line
});
*/

const transaction_builder = new TransactionBuilder(config);
var results = {
  test1: '',
  test2: '',
  test3: '',
  test4: ''
};


describe('Patreos Tests', function() {

  before(() => {

    var transactions = [
      transaction_builder.pledge('xokayplanetx', 'patreosnexus', '1.0000', 10),
      transaction_builder.pledge('xokayplanetx', 'patreosnexus', '51.0000', 10),
      transaction_builder.pledge('xokayplanetx', 'patreosnexus', '55.0000', 10),
      transaction_builder.unpledge('xokayplanetx', 'patreosnexus')
    ];

    async function createPledgeBelowMinPledgeAmount(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        console.log(response)
        results.test1 = 'Transaction was successful'
      }).catch(err => {
        error = JSON.parse(err).error;
        results.test1 = error.details[0].message;
      });
    }

    async function createSuccessfulPledge(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        results.test2 = response.processed.receipt.status;
      }).catch(err => {
        console.log(err)
        results.test2 = 'Transaction was not successful';
      });
    }

    async function createDuplicatePledge(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        console.log(response)
        results.test3 = 'Transaction was successful';
      }).catch(err => {
        error = JSON.parse(err).error;
        results.test3 = error.details[0].message;
      });
    }

    async function removePledge(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        results.test4 = response.processed.receipt.status;
        resolve()
      }).catch(err => {
        console.log(err)
        results.test4 = 'Transaction was not successful';
        resolve()
      });
    }

    return new Promise( (resolve, reject) => {
      createPledgeBelowMinPledgeAmount(resolve, transactions[0])
      createSuccessfulPledge(resolve, transactions[1])
      createDuplicatePledge(resolve, transactions[2])
      removePledge(resolve, transactions[3])
    });

  });

  it('Should error when pledge of min value is not met', function() {
    assert.equal('assertion failure with message: Must pledge at least min quanity', results.test1);
  });

  it('Should execute successfully', function() {
    assert.equal('executed', results.test2);
  });

  it('Should error on duplicate pledge', function() {
    assert.equal('assertion failure with message: Pledge already exists.', results.test3);
  });

  it('Removed pledge successfully', function() {
    assert.equal('executed', results.test4);
  });

});
