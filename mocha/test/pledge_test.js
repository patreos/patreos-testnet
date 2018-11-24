Eos = require('eosjs')
var fs = require("fs");
var assert = require('assert');
var accounts = fs.readFileSync("accounts.json");
var TransactionBuilder = require('../utils/transaction_builder');

process.on('unhandledRejection', (reason, promise) => {
  console.log('Unhandled Rejection at:', reason.stack || reason)
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

const table = eos.getTableRows(true, 'patreosnexus', 'patreosnexus', 'profiles', 'xokayplanetx');
table.then((response) => {
  console.log(response);
}).catch(error => {
  console.log('An error occurred: ' + JSON.stringify(error)); //eslint-disable-line
});

const network = config.requiredFields.accounts[0];
*/

const transaction_builder = new TransactionBuilder(config);

describe('Patreos Tests', function() {

  var results = {
    test1: 'assertion failure with message: Must pledge at least min quanity'
  };

  beforeEach(() => {
    const transaction = transaction_builder.pledge('xokayplanetx', 'patreosnexus', '1.0000', 10);
    const promise = eos.transaction(transaction);
    return promise.then((response) => {
        results.test1 = 'Transaction was successful'
    }).catch(err => {
        error = JSON.parse(err).error
        results.test1 = error.details[0].message
    });
  });

  it('Should error when pledge of min value is not met', function() {
    assert.equal('assertion failure with message: Must pledge at least min quanity', results.test1);
  });

});
