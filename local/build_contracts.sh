#!/bin/bash
source ~/dev/patreos/patreos-testnet/local/constants.sh

echo "Compiling Patreos Contracts"
pushd ~/dev/patreos/patreos-contracts/

users=$(echo "$USER_KEYS_JSON" | jq '.contracts')
for row in $(echo "${users}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
    contract=$(_jq '.name')
    echo "Compiling $contract"
    ./generate.sh $contract
done
popd
