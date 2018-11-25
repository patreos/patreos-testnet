#!/bin/bash
source ~/dev/patreos/patreos-tests/local/constants.sh

echo "$USER_KEYS_JSON"

./build_contracts.sh

./bootstrap_patreos.sh

./simulation/setup.sh

./simulation/patreos_users.sh
