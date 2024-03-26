# Welcome to contracts! I recently switched from hardhat to Forge.

# How to set up

1. `pnpm install`
2. copy `example.env` and make it `.env`
3. Give feedback to JD or submit a PR if you feel inclined!

# Commands

## How to run tests

`forge test -vv`

## How to deploy smart contracts using Forge

#### Base sepolia:

```
forge create contracts/boats/Boat.sol:Boat --rpc-url https://sepolia.base.org \
    --private-key <your_private_key> \
    --etherscan-api-key <etherscan_api_key> \
    --constructor-args <initial_owner> "Test Boat" "Boston Whaler" "Center Console" 2023 21 \
    --verify


```

## Verification

Run `npx hardhat verify --constructor-args verify/params.js --network NETWORK_NAME CONTRACT_ADDRESS`

- Network names can be found in hardhat config
