# Welcome to contracts! I recently switched from hardhat to Forge.

# How to set up

1. `pnpm install`
2. copy `example.env` and make it `.env`
3. Give feedback to JD or submit a PR if you feel inclined!

# Commands

## How to run tests

`forge test -vv`

## How to deploy smart contracts using Forge

#### Step 1: Deploy BoatRegistry

First off, we need to deploy a boat registry where new boats, PowerBoats, and Engines will be added to.

```
forge create contracts/boats/BoatRegistry.sol:BoatRegistry --rpc-url https://sepolia.base.org \
    --private-key <PRIVATE_KEY> \
    --etherscan-api-key <ETHERSCAN_API_KEY> \
    --verify

```

#### Step 2: Set up the BoatFactory

Now that we have the address of the BoatRegistry, take that address and use it to construct a BoatFactory

```
forge create contracts/boats/BoatFactory.sol:BoatFactory --rpc-url https://sepolia.base.org \
    --private-key <PRIVATE_KEY> \
    --etherscan-api-key <ETHERSCAN_API_KEY> \
    --constructor-args <REGISTRY_ADDRESS_FROM_STEP_1> \
    --verify

```

#### Generic Commands

```
forge create contracts/boats/Boat.sol:Boat --rpc-url https://sepolia.base.org \
    --private-key <your_private_key> \
    --etherscan-api-key <etherscan_api_key> \
    --constructor-args <initial_owner> "Test Boat" "Boston Whaler" "Center Console" 2023 21 \
    --verify


```
