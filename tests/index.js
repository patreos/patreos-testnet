Eos = require('eosjs')
var fs = require("fs");
var accounts = fs.readFileSync("accounts.json");

console.log(JSON.parse(accounts));

// Connect to a testnet or mainnet
let config = {
  httpEndpoint: 'http://127.0.0.1:8888',
  chainId: 'cf057bbfb72640471fd910bcb67639c22df9f92470936cddc1ade0e2f2e7dc4f',
  keyProvider: '5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3'
};

eos = Eos(config);

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
