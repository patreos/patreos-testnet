#!/bin/bash
source ~/dev/patreos/patreos-testnet/local/constants.sh

echo "Additional Setup for Simulation"

# Setup

echo "Transfering $EOS_TOKEN to account: ${PATREOS_USERS[0]}"
JSON=$(jq -n --arg to "${PATREOS_USERS[0]}" --arg quantity "200.0000 $EOS_TOKEN" '{ from: "eosio", to: $to, quantity: $quantity, memo: "Gift from eosio" }')
cleos push action eosio.token transfer "${JSON}" -p eosio

echo "Transfering $EOS_TOKEN to account: ${PATREOS_USERS[3]}"
JSON=$(jq -n --arg to "${PATREOS_USERS[3]}" --arg quantity "200.0000 $EOS_TOKEN" '{ from: "eosio", to: $to, quantity: $quantity, memo: "Gift from eosio" }')
cleos push action eosio.token transfer "${JSON}" -p eosio

echo "Transfering $EOS_TOKEN to account: ${PATREOS_USERS[4]}"
JSON=$(jq -n --arg to "${PATREOS_USERS[4]}" --arg quantity "100.0000 $EOS_TOKEN" '{ from: "eosio", to: $to, quantity: $quantity, memo: "Gift from eosio" }')
cleos push action eosio.token transfer "${JSON}" -p eosio
