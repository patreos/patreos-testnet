#!/bin/bash
source ~/dev/patreos/patreos-testnet/local/constants.sh

echo "Unlocking Unsecure Wallet..."
cleos wallet lock -n unsecure
cleos wallet unlock -n unsecure --password $UNSECURE_WALLET_PWD

./build_contracts.sh

echo "Setting Patreos Contracts..."
users=$(echo "$USER_KEYS_JSON" | jq '.contracts')
for row in $(echo "${users}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
    account_name=$(_jq '.name')

    echo "Setting Patreos contract: ${account_name}"
    cleos set contract $account_name ${PATREOS_CONTRACTS_DIR}/${account_name} -p $account_name
done
