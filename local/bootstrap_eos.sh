#!/bin/bash

# Needed Vars
source ~/dev/patreos/patreos-tests/local/constants.sh

echo "Unlocking Unsecure Wallet..."
cleos wallet lock -n unsecure
cleos wallet unlock -n unsecure --password $UNSECURE_WALLET_PWD

users=$(echo "$USER_KEYS_JSON" | jq '.system')
for row in $(echo "${users}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
    key=$(_jq '.private_key')
    echo "Adding key: ${key} to unsecure wallet"
    cleos wallet import -n unsecure --private-key ${key}
done
users=$(echo "$USER_KEYS_JSON" | jq '.contracts')
for row in $(echo "${users}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
    key=$(_jq '.private_key')
    echo "Adding key: ${key} to unsecure wallet"
    cleos wallet import -n unsecure --private-key ${key}
done
users=$(echo "$USER_KEYS_JSON" | jq '.users')
for row in $(echo "${users}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
    key=$(_jq '.private_key')
    echo "Adding key: ${key} to unsecure wallet"
    cleos wallet import -n unsecure --private-key ${key}
done

echo "Setting BIOS Contract..."
cleos set contract eosio $EOSIO_CONTRACTS_DIR/eosio.bios

SYSTEM_PUBLIC_KEY=$(echo "$USER_KEYS_JSON" | jq '.system[0].public_key' | tr -d \")

echo "Creating System Accounts..."
cleos create account eosio eosio.bpay $SYSTEM_PUBLIC_KEY $SYSTEM_PUBLIC_KEY
cleos create account eosio eosio.msig $SYSTEM_PUBLIC_KEY $SYSTEM_PUBLIC_KEY
cleos create account eosio eosio.names $SYSTEM_PUBLIC_KEY $SYSTEM_PUBLIC_KEY
cleos create account eosio eosio.ram $SYSTEM_PUBLIC_KEY $SYSTEM_PUBLIC_KEY
cleos create account eosio eosio.ramfee $SYSTEM_PUBLIC_KEY $SYSTEM_PUBLIC_KEY
cleos create account eosio eosio.saving $SYSTEM_PUBLIC_KEY $SYSTEM_PUBLIC_KEY
cleos create account eosio eosio.stake $SYSTEM_PUBLIC_KEY $SYSTEM_PUBLIC_KEY
cleos create account eosio eosio.token $SYSTEM_PUBLIC_KEY $SYSTEM_PUBLIC_KEY
cleos create account eosio eosio.upay $SYSTEM_PUBLIC_KEY $SYSTEM_PUBLIC_KEY

echo "Setting eosio.token and eosio.msig Contracts..."
sleep 2
cleos set contract eosio.token $EOSIO_CONTRACTS_DIR/eosio.token
cleos set contract eosio.msig $EOSIO_CONTRACTS_DIR/eosio.msig

echo "Creating System Token $SYSTEM_TOKEN..."
JSON=$(jq -n --arg maximum_supply "1000000000.0000 $SYSTEM_TOKEN" '{ issuer: "eosio", maximum_supply: $maximum_supply, can_freeze: 0, can_recall: 0, can_whitelist: 0 }')
cleos push action eosio.token create "${JSON}" -p eosio.token

echo "Creating $EOS_TOKEN Token..."
JSON=$(jq -n --arg maximum_supply "1000000000.0000 $EOS_TOKEN" '{ issuer: "eosio", maximum_supply: $maximum_supply, can_freeze: 0, can_recall: 0, can_whitelist: 0 }')
cleos push action eosio.token create "${JSON}" -p eosio.token

sleep 2

echo "Issuing $SYSTEM_TOKEN to eosio..."
JSON=$(jq -n --arg quantity "1000000000.0000 $SYSTEM_TOKEN" '{ to: "eosio", quantity: $quantity, memo: "issue" }')
cleos push action eosio.token issue "${JSON}" -p eosio

echo "Issuing $EOS_TOKEN to eosio..."
JSON=$(jq -n --arg quantity "1000000000.0000 $EOS_TOKEN" '{ to: "eosio", quantity: $quantity, memo: "issue" }')
cleos push action eosio.token issue "${JSON}" -p eosio

echo "Setting eosio.system Contract..."
cleos set contract eosio $EOSIO_CONTRACTS_DIR/eosio.system

echo "Making user accounts..."

users=$(echo "$USER_KEYS_JSON" | jq '.users')
for row in $(echo "${users}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
    account_name=$(_jq '.name')
    account_public_key=$(_jq '.public_key')
    account_private_key=$(_jq '.private_key')

    echo "Creating Account: ${account_name} with Public Key: ${account_public_key}"
    cleos system newaccount  --stake-net "100.0000 $SYSTEM_TOKEN" --stake-cpu "100.0000 $SYSTEM_TOKEN" --buy-ram-kbytes 1000 eosio ${account_name} ${account_public_key} ${account_public_key}
    JSON=$(jq -n --arg to "${account_name}" --arg quantity "1000.0000 $SYSTEM_TOKEN" '{ from: "eosio", to: $to, quantity: $quantity, memo: "<3" }')
    cleos push action eosio.token transfer "${JSON}" -p eosio
done

echo ""
echo "----------------"
echo "Final Stats..."

echo "EOSIO Balance"
cleos get currency balance eosio.token eosio

echo "Get stats for $SYSTEM_TOKEN"
cleos get currency stats eosio.token "$SYSTEM_TOKEN"

echo "Get stats for $EOS_TOKEN"
cleos get currency stats eosio.token "$EOS_TOKEN"

users=$(echo "$USER_KEYS_JSON" | jq '.users')
for row in $(echo "${users}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
    account_name=$(_jq '.name')

    echo "${account_name} Balance:"
    cleos get currency balance eosio.token ${account_name}
    cleos get currency balance eosio.token ${account_name} EOS
done

echo "Finished..."
