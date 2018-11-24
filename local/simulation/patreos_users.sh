#!/bin/bash
source ~/dev/patreos/patreos-tests/local/constants.sh

echo "Unlocking Unsecure Wallet..."
cleos wallet lock -n unsecure
cleos wallet unlock -n unsecure --password $UNSECURE_WALLET_PWD

# PROFILE ACTIONS
echo "Making Patreos Profiles..."
for account in "${PATREOS_USERS[@]}"
do
  echo "Creating Profile with user: ${account}"
  JSON=$(jq -n \
  --arg owner "${account}" \
  --arg _owner "${account}" \
  --arg _name "${account} (John)" \
  --arg _description "I am a new Patreos user!" '{ owner: $owner, _profile: { owner: $_owner, name: $_name, description: $_description } }')
  echo "Setting profile with $JSON"
  cleos push action patreosnexus setprofile "${JSON}" -p ${account}
done

# BLURB ACTIONS
echo "Blurb from ${PATREOS_USERS[3]} to ${PATREOS_USERS[4]}..."
JSON=$(jq -n --arg from "${PATREOS_USERS[3]}" --arg to "${PATREOS_USERS[4]}" '{ from: $from, to: $to, memo: "Blurb!!!!" }')
cleos push action patreosblurb blurb "${JSON}" -p ${PATREOS_USERS[3]}

# TRANSFER ACTIONS

echo "${PATREOS_USERS[0]} depositing $PATREOS_TOKEN into patreosvault..."
JSON=$(jq -n \
--arg from "${PATREOS_USERS[0]}" \
--arg quantity "100.0000 $PATREOS_TOKEN" '{ from: $from, to: "patreosvault", quantity: $quantity, memo: "PATR deposit in patreosvault" }')
cleos push action patreostoken transfer "${JSON}" -p ${PATREOS_USERS[0]}

echo "${PATREOS_USERS[0]} depositing $EOS_TOKEN into patreosvault..."
JSON=$(jq -n \
--arg from "${PATREOS_USERS[0]}" \
--arg quantity "10.0000 $EOS_TOKEN" '{ from: $from, to: "patreosvault", quantity: $quantity, memo: "EOS deposit in patreosvault" }')
cleos push action eosio.token transfer "${JSON}" -p ${PATREOS_USERS[0]}

echo "${PATREOS_USERS[4]} depositing $EOS_TOKEN into patreosvault..."
JSON=$(jq -n \
--arg from "${PATREOS_USERS[4]}" \
--arg quantity "10.0000 $EOS_TOKEN" '{ from: $from, to: "patreosvault", quantity: $quantity, memo: "EOS deposit in patreosvault" }')
cleos push action eosio.token transfer "${JSON}" -p ${PATREOS_USERS[4]}

echo "${PATREOS_USERS[4]} depositing $PATREOS_TOKEN into patreosvault..."
JSON=$(jq -n \
--arg from "${PATREOS_USERS[4]}" \
--arg quantity "100.0000 $PATREOS_TOKEN" '{ from: $from, to: "patreosvault", quantity: $quantity, memo: "PATR deposit in patreosvault" }')
cleos push action patreostoken transfer "${JSON}" -p ${PATREOS_USERS[4]}

echo "${PATREOS_USERS[3]} depositing $PATREOS_TOKEN into patreosvault..."
JSON=$(jq -n \
--arg from "${PATREOS_USERS[3]}" \
--arg quantity "150.0000 $PATREOS_TOKEN" '{ from: $from, to: "patreosvault", quantity: $quantity, memo: "PATR deposit in patreosvault" }')
cleos push action patreostoken transfer "${JSON}" -p ${PATREOS_USERS[3]}

sleep 2

# PLEDGE ACTIONS
echo "${PATREOS_USERS[4]} pledging to ${PATREOS_USERS[3]}"
JSON=$(jq -n \
--arg pledger "${PATREOS_USERS[4]}" \
--arg _creator "${PATREOS_USERS[3]}" \
--arg _quantity "1.0000 $EOS_TOKEN" \
--arg _seconds 10 '{ pledger: $pledger, _pledge: { creator: $_creator, quantity: $_quantity, seconds: $_seconds, last_pledge: 0, execution_count: 0 } }')
echo "${PATREOS_USERS[4]} pledging to ${PATREOS_USERS[3]} with $JSON"
cleos push action patreosnexus pledge "${JSON}" -p ${PATREOS_USERS[4]}

echo "${PATREOS_USERS[4]} pledging to ${PATREOS_USERS[2]}"
JSON=$(jq -n \
--arg pledger "${PATREOS_USERS[4]}" \
--arg _creator "${PATREOS_USERS[2]}" \
--arg _quantity "3.0000 $EOS_TOKEN" \
--arg _seconds 10 '{ pledger: $pledger, _pledge: { creator: $_creator, quantity: $_quantity, seconds: $_seconds, last_pledge: 0, execution_count: 0 } }')
echo "${PATREOS_USERS[4]} pledging to ${PATREOS_USERS[2]} with $JSON"
cleos push action patreosnexus pledge "${JSON}" -p ${PATREOS_USERS[4]}

# UNPLEDGE ACTIONS
JSON=$(jq -n --arg pledger "${PATREOS_USERS[4]}" --arg creator "${PATREOS_USERS[2]}" '{ pledger: $pledger, creator: $creator }')
echo "${PATREOS_USERS[4]} unpledging from ${PATREOS_USERS[2]} with $JSON"
cleos push action patreosnexus unpledge "${JSON}" -p ${PATREOS_USERS[4]}

# WITHDRAW
JSON=$(jq -n --arg owner "${PATREOS_USERS[2]}" --arg quantity "1.0000 $EOS_TOKEN" '{ owner: $owner, quantity: $quantity }')
echo "${PATREOS_USERS[2]} withdrawing 1.0000 $EOS_TOKEN with: $JSON"
echo "THIS SHOULD FAIL! ${PATREOS_USERS[2]} NEVER MADE DEPOSIT"
cleos push action patreosvault withdraw "${JSON}" -p ${PATREOS_USERS[2]}
sleep 2

JSON=$(jq -n --arg owner "${PATREOS_USERS[4]}" --arg quantity "0.9999 $EOS_TOKEN" '{ owner: $owner, quantity: $quantity }')
echo "${PATREOS_USERS[4]} withdrawing 0.9999 $EOS_TOKEN with: $JSON"
cleos push action patreosvault withdraw "${JSON}" -p ${PATREOS_USERS[4]}
sleep 2

JSON=$(jq -n --arg owner "${PATREOS_USERS[3]}" --arg quantity "0.9999 $PATREOS_TOKEN" '{ owner: $owner, quantity: $quantity }')
echo "${PATREOS_USERS[3]} withdrawing 0.9999 $PATREOS_TOKEN with: $JSON"
cleos push action patreosvault withdraw "${JSON}" -p ${PATREOS_USERS[3]}
sleep 2

echo "------------------"
echo "Finished"

echo "patreosvault balance for ${PATREOS_USERS[3]}"
cleos get currency balance patreosvault ${PATREOS_USERS[3]}

echo "patreosvault balance for ${PATREOS_USERS[4]}"
cleos get currency balance patreosvault ${PATREOS_USERS[4]}

echo "User profiles for Patreos"
cleos get table patreosnexus patreosnexus profiles

echo "Pledges from ${PATREOS_USERS[4]}"
cleos get table patreosnexus ${PATREOS_USERS[4]} pledges
