#!/bin/bash

# Needed Vars
source ~/dev/patreos/patreos-testnet/local/constants.sh

echo "Making Patreos Contract Accounts..."
users=$(echo "$USER_KEYS_JSON" | jq '.contracts')
for row in $(echo "${users}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
    account_name=$(_jq '.name')
    account_public_key=$(_jq '.public_key')

    echo "Creating Patreos Contract Account: ${account_name} with Public Key: EOS7YZQ7PbeFY8KPA9XAe3K7dkME3JKwWadMcggRPeVHRQ2DZDeoZ"
    cleos system newaccount  --stake-net "100.0000 $SYSTEM_TOKEN" --stake-cpu "100.0000 $SYSTEM_TOKEN" --buy-ram-kbytes 1000 eosio ${account_name} $account_public_key $account_public_key
done

sleep 2

echo "Transfering $SYSTEM_TOKEN to Patreos Contract Accounts..."
users=$(echo "$USER_KEYS_JSON" | jq '.contracts')
for row in $(echo "${users}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
    account_name=$(_jq '.name')

    echo "Transfering $SYSTEM_TOKEN to account: ${account_name}"
    JSON=$(jq -n --arg to "${account_name}" --arg quantity "1000.0000 $SYSTEM_TOKEN" '{ from: "eosio", to: $to, quantity: $quantity, memo: "<33" }')
    cleos push action eosio.token transfer "${JSON}" -p eosio
done

echo "Transfering $EOS_TOKEN to Patreos Contract Accounts..."
users=$(echo "$USER_KEYS_JSON" | jq '.contracts')
for row in $(echo "${users}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
    account_name=$(_jq '.name')

    echo "Transfering $EOS_TOKEN to account: ${account_name}"
    JSON=$(jq -n --arg to "${account_name}" --arg quantity "1000.0000 $EOS_TOKEN" '{ from: "eosio", to: $to, quantity: $quantity, memo: "<33" }')
    cleos push action eosio.token transfer "${JSON}" -p eosio
done

sleep 2

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


echo "Setting recurringpay permission to eosio.code"
cleos set account permission recurringpay active '{"threshold": 1,"keys": [{"key": "EOS7YZQ7PbeFY8KPA9XAe3K7dkME3JKwWadMcggRPeVHRQ2DZDeoZ","weight": 1}],"accounts": [{"permission":{"actor":"recurringpay","permission":"eosio.code"},"weight":1}]}' owner -p recurringpay

sleep 2

echo "Creating Patreos Token with Issuer: ${PATREOS_USERS[0]}"
JSON=$(jq -n --arg issuer "${PATREOS_USERS[0]}" --arg maximum_supply "2000000000.0000 $PATREOS_TOKEN" '{ issuer: $issuer, maximum_supply: $maximum_supply, can_freeze: 0, can_recall: 0, can_whitelist: 0 }')
cleos push action patreostoken create "${JSON}" -p patreostoken

sleep 2

echo "Issuing first Patreos Tokens to ${PATREOS_USERS[0]}"
ISSUING=(
  "$(jq -n --arg to "${PATREOS_USERS[0]}" --arg quantity "680000000.0000 $PATREOS_TOKEN" --arg memo "34% ELSEWHERE" '{ to: $to, quantity: $quantity, memo: $memo }')"
  "$(jq -n --arg to "${PATREOS_USERS[1]}" --arg quantity "120000000.0000 $PATREOS_TOKEN" --arg memo "6% INFLATION" '{ to: $to, quantity: $quantity, memo: $memo }')"
  "$(jq -n --arg to "${PATREOS_USERS[2]}" --arg quantity "1200000000.0000 $PATREOS_TOKEN" --arg memo "60% AIRDROP" '{ to: $to, quantity: $quantity, memo: $memo }')"
)
for issue in "${ISSUING[@]}"
do
  echo "Issuing Patreos Tokens: ${issue}"
  cleos push action patreostoken issue "${issue}" -p ${PATREOS_USERS[0]}
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

echo "Get stats for $PATREOS_TOKEN"
cleos get currency stats patreostoken "$PATREOS_TOKEN"

users=$(echo "$USER_KEYS_JSON" | jq '.users')
for row in $(echo "${users}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
    account_name=$(_jq '.name')

    echo "${account_name} Balance:"
    cleos get currency balance patreostoken ${account_name}
done

echo "patreosmoney Balance:"
cleos get currency balance patreostoken patreosmoney

echo "Finished..."
