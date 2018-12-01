var config = {
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

module.exports.config = config;
