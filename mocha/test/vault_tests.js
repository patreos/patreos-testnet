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
  patrWithdrawFromVaultWithoutBalance: '',
  eosWithdrawFromVaultWithoutBalance: '',
  patrWithdrawNegativeBalanceFromVault: '',
  eosWithdrawNegativeBalanceFromVault: ''
};

describe('Patreos Vault Tests', function() {

  before(() => {

    var testTransactions = {
      'patrWithdrawFromVaultWithoutBalance': transaction_builder.withdraw('nomoneyuser1', '1.0000', 'PATR'),
      'eosWithdrawFromVaultWithoutBalance': transaction_builder.withdraw('nomoneyuser1', '1.0000', 'EOS'),

      'patrWithdrawNegativeBalanceFromVault': transaction_builder.withdraw('xokayplanetx', '-1.0000', 'PATR'),
      'eosWithdrawNegativeBalanceFromVault': transaction_builder.withdraw('xokayplanetx', '-1.0000', 'EOS'),

      'depositBalanceIntoVault': transaction_builder.transfer('xokayplanetx', 'patreosvault', '1.0000','STAKE <3','patreostoken', 'PATR'),

      'eosWithdrawZeroBalanceFromVault': transaction_builder.withdraw('xokayplanetx', '0.0000', 'EOS')
    };

    async function eosWithdrawNegativeBalanceFromVault(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        console.log(response)
        results.eosWithdrawNegativeBalanceFromVault = 'Transaction was successful'
      }).catch(err => {
        error = JSON.parse(err).error;
        results.eosWithdrawNegativeBalanceFromVault = error.details[0].message;
      });
    }

    async function patrWithdrawNegativeBalanceFromVault(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        console.log(response)
        results.patrWithdrawNegativeBalanceFromVault = 'Transaction was successful'
      }).catch(err => {
        error = JSON.parse(err).error;
        results.patrWithdrawNegativeBalanceFromVault = error.details[0].message;
      });
    }

    async function eosWithdrawFromVaultWithoutBalance(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        console.log(response)
        results.eosWithdrawFromVaultWithoutBalance = 'Transaction was successful'
      }).catch(err => {
        error = JSON.parse(err).error;
        results.eosWithdrawFromVaultWithoutBalance = error.details[0].message;
      });
    }

    async function patrWithdrawFromVaultWithoutBalance(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        console.log(response)
        results.patrWithdrawFromVaultWithoutBalance = 'Transaction was successful'
      }).catch(err => {
        error = JSON.parse(err).error;
        results.patrWithdrawFromVaultWithoutBalance = error.details[0].message;
      });
    }

    async function depositBalanceIntoVault(resolve, tx) {
      let ret = await eos.transaction(tx).then((response) => {
        results.depositBalanceIntoVault = response.processed.receipt.status;
        resolve()
      }).catch(err => {
        console.log(err)
        results.depositBalanceIntoVault = 'Transaction was not successful';
        resolve()
      });
    }

    // We return a promise so that before() waits until resolve
    return new Promise( (resolve, reject) => {
      patrWithdrawFromVaultWithoutBalance(resolve, testTransactions.patrWithdrawFromVaultWithoutBalance)
      eosWithdrawFromVaultWithoutBalance(resolve, testTransactions.eosWithdrawFromVaultWithoutBalance)
      patrWithdrawNegativeBalanceFromVault(resolve, testTransactions.patrWithdrawNegativeBalanceFromVault)
      eosWithdrawNegativeBalanceFromVault(resolve, testTransactions.eosWithdrawNegativeBalanceFromVault)

      depositBalanceIntoVault(resolve, testTransactions.depositBalanceIntoVault)

    });

  });


  // Promise has resolved here

  it('Cannot withdraw PATR from vault without balance', function() {
    assert.ok(results.patrWithdrawFromVaultWithoutBalance.includes(messages.NO_BALANCE_FOR_TOKEN));
  });

  it('Cannot withdraw EOS from vault without balance', function() {
    assert.ok(results.eosWithdrawFromVaultWithoutBalance.includes(messages.NO_BALANCE_FOR_TOKEN));
  });

  it('Cannot withdraw negative PATR from vault', function() {
    if(results.patrWithdrawNegativeBalanceFromVault == '') {
      console.log("Promise not resolved for patrWithdrawNegativeBalanceFromVault");
      return;
    }
    assert.ok(results.patrWithdrawNegativeBalanceFromVault.includes(messages.NEED_POSITIVE_TRANSFER_QUANTITY));
  });

  it('Cannot withdraw negative EOS from vault', function() {
    if(results.eosWithdrawNegativeBalanceFromVault == '') {
      console.log("Promise not resolved for eosWithdrawNegativeBalanceFromVault");
      return;
    }
    assert.ok(results.eosWithdrawNegativeBalanceFromVault.includes(messages.NEED_POSITIVE_TRANSFER_QUANTITY));
  });

  it('Deposit PATR into vault', function() {
    if(results.depositBalanceIntoVault == '') {
      console.log("Promise not resolved for depositBalanceIntoVault");
      return;
    }
    assert.equal('executed', results.depositBalanceIntoVault);
  });


});
