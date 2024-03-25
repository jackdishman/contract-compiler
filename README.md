# How to deploy smart contracts using Forge

#### Base sepolia:

```
forge create --rpc-url <your_rpc_url> \
    --constructor-args "ForgeUSD" "FUSD" 18 1000000000000000000000 \
    --private-key <your_private_key> \
    --etherscan-api-key <your_etherscan_api_key> \
    --verify \
    src/MyToken.sol:MyToken

forge create
    --rpc-url https://sepolia.base.org \
    --private-key <your_private_key> \
    --etherscan-api-key <etherscan_api_key>
    --constructor-args 0xd8D6F202Ef51210812FDaD1D521D6ab1Abc85Df7 "Test Boat" "Boston Whaler" "Center Console" 2023 21 \
    --verify
    contracts/boats/Boat.sol:Boat

```

## Verification

Run `npx hardhat verify --constructor-args verify/params.js --network NETWORK_NAME CONTRACT_ADDRESS`

- Network names can be found in hardhat config
