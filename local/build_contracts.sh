#!/bin/bash
source ~/dev/patreos/patreos-tests/local/constants.sh

echo "Compiling Patreos Contracts"
pushd ~/dev/patreos/patreos-contracts/cdt/
for contract in "${PATREOS_CONTRACTS[@]}"
do
  echo "Compiling $contract"
  ./generate.sh $contract
done
popd
