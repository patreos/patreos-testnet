Eos = require('eosjs')
var fs = require("fs");
var assert = require('assert');
var accounts = fs.readFileSync("accounts.json");

var messagesModule = require("./messages.js");
var configModule = require("./config.js");

var TransactionBuilder = require('../utils/transaction_builder');

process.on('unhandledRejection', (reason, promise) => {
  //console.log('Unhandled Rejection at:', reason.stack || reason)
  // Recommended: send the information to sentry.io
  // or whatever crash reporting service you use
})

var config = configModule.config;
var messages = messagesModule.messages;

eos = Eos(config.eos);

const transaction_builder = new TransactionBuilder(config);

var results = {
  verifyPledgeIsAboveMinQuantity: '',
  successfulPledge: '',
  verifyPledgeDNE: '',
  removedPledge: '',
  verifyHasNeededVaultBalance: '',
  verifyHasPledgeFunds: ''
};


describe('Patreos Pledge Tests', function() {

  before(() => {

    var testTransactions = {
      'patrPledgeBelowMin': transaction_builder.pledge('xokayplanetx', 'patreosnexus', '1.0000', 10),
      'patrPledgeAboveMin': transaction_builder.pledge('xokayplanetx', 'patreosnexus', '51.0000', 10),
      'patrPledgeAboveMin2': transaction_builder.pledge('xokayplanetx', 'patreosnexus', '55.0000', 10),
      'unpledge': transaction_builder.unpledge('xokayplanetx', 'patreosnexus'),
      'patrPledgeAboveMin3': transaction_builder.pledge('xokayplanetx', 'patreosnexus', '65.0000', 10),
      'patrPledgeAboveMin4': transaction_builder.pledge('xokayplanetx', 'patreosnexus', '200.0000', 10)
    };

    async function createPledgeBelowMinPledgeAmount(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        console.log(response)
        results.verifyPledgeIsAboveMinQuantity = 'Transaction was successful'
      }).catch(err => {
        error = JSON.parse(err).error;
        results.verifyPledgeIsAboveMinQuantity = error.details[0].message;
      });
    }

    async function createSuccessfulPledge(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        results.successfulPledge = response.processed.receipt.status;
      }).catch(err => {
        console.log(err)
        results.successfulPledge = 'Transaction was not successful';
      });
    }

    async function createDuplicatePledge(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        console.log(response)
        results.verifyPledgeDNE = 'Transaction was successful';
      }).catch(err => {
        error = JSON.parse(err).error;
        results.verifyPledgeDNE = error.details[0].message;
      });
    }

    async function removePledge(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        results.removedPledge = response.processed.receipt.status;
      }).catch(err => {
        console.log(err)
        results.removedPledge = 'Transaction was not successful';
      });
    }

    async function shouldHave2xThePledgeInVault(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        console.log(response)
        results.verifyHasNeededVaultBalance = 'Transaction was successful';
      }).catch(err => {
        error = JSON.parse(err).error;
        results.verifyHasNeededVaultBalance = error.details[0].message;
      });
    }

    async function shouldHaveSufficientFundsForPledge(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        console.log(response)
        results.verifyHasPledgeFunds = 'Transaction was successful';
        resolve()
      }).catch(err => {
        error = JSON.parse(err).error;
        results.verifyHasPledgeFunds = error.details[0].message;
        resolve()
      });
    }

    // We return a promise so that before() waits until resolve
    return new Promise( (resolve, reject) => {
      createPledgeBelowMinPledgeAmount(resolve, testTransactions.patrPledgeBelowMin)
      createSuccessfulPledge(resolve, testTransactions.patrPledgeAboveMin)
      createDuplicatePledge(resolve, testTransactions.patrPledgeAboveMin2)
      removePledge(resolve, testTransactions.unpledge)
      shouldHave2xThePledgeInVault(resolve, testTransactions.patrPledgeAboveMin3)
      shouldHaveSufficientFundsForPledge(resolve, testTransactions.patrPledgeAboveMin4)
    });

  });


  // Promise has resolved here

  it('Should error when pledge of min value is not met', function() {
    assert.ok(results.verifyPledgeIsAboveMinQuantity.includes(messages.NEED_MIN_QUANTITY));
  });

  it('Should execute successfully', function() {
    assert.equal('executed', results.successfulPledge);
  });

  it('Should error on duplicate pledge', function() {
    assert.ok(results.verifyPledgeDNE.includes(messages.PLEDGE_EXISTS));
  });

  it('Removed pledge successfully', function() {
    assert.equal('executed', results.removedPledge);
  });

  it('Should have 2x the pledge amount in patreosvault', function() {
    assert.ok(results.verifyHasNeededVaultBalance.includes(messages.NEED_LARGER_VAULT_BALANCE));
  });

  it('Should have sufficient funds for pledge', function() {
    assert.ok(results.verifyHasPledgeFunds.includes(messages.NEED_PLEDGE_FUNDS));
  });

});
