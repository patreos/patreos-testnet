#!/bin/bash
source ~/dev/patreos/patreos-tests/local/constants.sh

./build_contracts.sh

./bootstrap_patreos.sh

./simulation/setup.sh

./simulation/patreos_users.sh
