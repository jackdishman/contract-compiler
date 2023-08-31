# How to deploy smart contracts

Step 1: run `npx hardhat compile`
Step 2: Copy `example.env` and create a `.env` file with your private keys (found in 1Password)
Step 3: deploy the contract to one of the following chains using the corresponding commands:

- OP Goerli: `npx hardhat run --network optimism-goerli scripts/deploy.ts`
- Polygon Mumbai: `npx hardhat run --network polygon-mumbai scripts/deploy.ts`
- Polygon Mainnet: `npx hardhat run --network polygon scripts/deploy.ts`

## Verification

Run `npx hardhat verify --constructor-args verify/params.js --network NETWORK_NAME CONTRACT_ADDRESS`

- Network names can be found in hardhat config
