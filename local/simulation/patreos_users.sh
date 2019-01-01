#!/bin/bash
source ~/dev/patreos/patreos-testnet/local/constants.sh

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


echo "------------------"
echo "Finished"

echo "patreosvault balance for ${PATREOS_USERS[3]}"
cleos get currency balance patreosvault ${PATREOS_USERS[3]}

echo "patreosvault balance for ${PATREOS_USERS[4]}"
cleos get currency balance patreosvault ${PATREOS_USERS[4]}

echo "User profiles for Patreos"
cleos get table patreosnexus patreosnexus profiles
