#!/bin/bash
USER_KEYS_JSON=$(jq -n \
'{
  system: [
    {
      name: "eosio",
      private_key: "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3",
      public_key: "EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV"
    }
  ],
  contracts: [
    {
      name: "patreostoken",
      private_key: "5JoEQenCL5WEaWyxZCRbgGvxuyKnWYUcBKmtD1oc3HnYfBttHPB",
      public_key: "EOS7YZQ7PbeFY8KPA9XAe3K7dkME3JKwWadMcggRPeVHRQ2DZDeoZ"
    },
    {
      name: "patreosnexus",
      private_key: "5JoEQenCL5WEaWyxZCRbgGvxuyKnWYUcBKmtD1oc3HnYfBttHPB",
      public_key: "EOS7YZQ7PbeFY8KPA9XAe3K7dkME3JKwWadMcggRPeVHRQ2DZDeoZ"
    },
    {
      name: "patreosblurb",
      private_key: "5JoEQenCL5WEaWyxZCRbgGvxuyKnWYUcBKmtD1oc3HnYfBttHPB",
      public_key: "EOS7YZQ7PbeFY8KPA9XAe3K7dkME3JKwWadMcggRPeVHRQ2DZDeoZ"
    },
    {
      name: "patreosvault",
      private_key: "5JoEQenCL5WEaWyxZCRbgGvxuyKnWYUcBKmtD1oc3HnYfBttHPB",
      public_key: "EOS7YZQ7PbeFY8KPA9XAe3K7dkME3JKwWadMcggRPeVHRQ2DZDeoZ"
    },
    {
      name: "patreosmoney",
      private_key: "5JoEQenCL5WEaWyxZCRbgGvxuyKnWYUcBKmtD1oc3HnYfBttHPB",
      public_key: "EOS7YZQ7PbeFY8KPA9XAe3K7dkME3JKwWadMcggRPeVHRQ2DZDeoZ"
    }
  ],
  users: [
    {
      name: "xokayplanetx",
      private_key: "5JXT8YAsNvtipDH6oFon75EdFLHZ1x8VmwgBz2kz3be7Jr3kW4S",
      public_key: "EOS5zND1SyAhuCWE1zTsdVdZvewME9vojtYXZ4ygKHsX6mv2TksSb"
    },
    {
      name: "testairdropx",
      private_key: "5J8CZFE5kM8bvaJ9EbotZBvGubkkXtDreLED6g6o5XBJNyY9Ldz",
      public_key: "EOS6yLaA9fEfP6631e8ofPSfEeomnVwGTZLh9ZpgkogErAewjwzj8"
    },
    {
      name: "testplanet1x",
      private_key: "5JBM4Dw7TxGEnCTFcTWLn2U7BPX9pfHuBTitNFnKX4gGhtpLATp",
      public_key: "EOS8gFRod5S9fimS45dQfnsvwzBe2VsJBDTGgrBAG5NWLWKscaL3Z"
    },
    {
      name: "testplanet2x",
      private_key: "5HztyDL73g4Ctb3CmSTmv698nLPWL8QLUkyJ5WC4Qh6xz4UT2AK",
      public_key: "EOS6gpKb2WC7K8N33xHxiQn2dkxdrqpF4E6j8upaBsbrXjPfhxDzd"
    },
    {
      name: "testplanet3x",
      private_key: "5JgxBtd2QwvDV8RkX7ukWrcFfdjK6k9z1bw6fXEYuqhvmAJ4dLm",
      public_key: "EOS6ipS4diKcXjaNYA3NXApRivnaJ5g86L1LmzmrFAzr4n8J2CJny"
    },
    {
      name: "testplanet4x",
      private_key: "5KXTErr7PQLEWtYzDPa6LCXxM8S4pYZVNGKnU3TdsfLdvPEQF4z",
      public_key: "EOS6CvgZn6D5f8fRof8FyogKWdJ5qYxiwFkCQTA5bi9BfGgKThRB4"
    },
    {
      name: "testplanet5x",
      private_key: "5KgggZQ3vrF7T8kaXgQ3ePvvCLG31iUm2wEAn7r258LiZVCiQjq",
      public_key: "EOS4wAP4BFUAMLtt3WkXeVssY8jPQrr2tfAfpNuuDU92F4yDCxLed"
    },
    {
      name: "testplanet12",
      private_key: "5KgggZQ3vrF7T8kaXgQ3ePvvCLG31iUm2wEAn7r258LiZVCiQjq",
      public_key: "EOS4wAP4BFUAMLtt3WkXeVssY8jPQrr2tfAfpNuuDU92F4yDCxLed"
    },
    {
      name: "testplanet13",
      private_key: "5KgggZQ3vrF7T8kaXgQ3ePvvCLG31iUm2wEAn7r258LiZVCiQjq",
      public_key: "EOS4wAP4BFUAMLtt3WkXeVssY8jPQrr2tfAfpNuuDU92F4yDCxLed"
    },
    {
      name: "testplanet14",
      private_key: "5KgggZQ3vrF7T8kaXgQ3ePvvCLG31iUm2wEAn7r258LiZVCiQjq",
      public_key: "EOS4wAP4BFUAMLtt3WkXeVssY8jPQrr2tfAfpNuuDU92F4yDCxLed"
    }
  ]
}'
)

EOSIO_CONTRACTS_DIR=~/dev/eos/eos/build/contracts
PATREOS_CONTRACTS_DIR=~/dev/patreos/patreos-contracts

SYSTEM_TOKEN=SYS
EOS_TOKEN=EOS
PATREOS_TOKEN=PATR

UNSECURE_WALLET_PWD=PW5JUuzAq3pU7u9GGZsTBsT5Tu34Nh9Qmfx4hrxe8Dqk62nhsZyEL

SYSTEM_PUBLIC_KEY=$(echo "$USER_KEYS_JSON" | jq '.system[0].public_key' | tr -d \")
SYSTEM_PRIVATE_KEY=$(echo "$USER_KEYS_JSON" | jq '.system[0].private_key' | tr -d \")

PATREOS_PUBLIC_KEY=$(echo "$USER_KEYS_JSON" | jq '.contracts[0].public_key' | tr -d \")
PATREOS_PRIVATE_KEY=$(echo "$USER_KEYS_JSON" | jq '.contracts[0].private_key' | tr -d \")

PRIVATE_KEYS=(
  $(echo "$USER_KEYS_JSON" | jq '.users[0].private_key' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[1].private_key' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[2].private_key' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[3].private_key' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[4].private_key' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[5].private_key' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[6].private_key' | tr -d \")
)

PUBLIC_KEYS=(
  $(echo "$USER_KEYS_JSON" | jq '.users[0].public_key' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[1].public_key' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[2].public_key' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[3].public_key' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[4].public_key' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[5].public_key' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[6].public_key' | tr -d \")
)

PATREOS_USERS=(
  $(echo "$USER_KEYS_JSON" | jq '.users[0].name' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.contracts[4].name' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[1].name' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[2].name' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[3].name' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[4].name' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.users[5].name' | tr -d \")
)

PATREOS_CONTRACTS=(
  $(echo "$USER_KEYS_JSON" | jq '.contracts[0].name' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.contracts[1].name' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.contracts[2].name' | tr -d \")
  $(echo "$USER_KEYS_JSON" | jq '.contracts[3].name' | tr -d \")
)
