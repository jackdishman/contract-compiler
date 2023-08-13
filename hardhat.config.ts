import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config({ path: __dirname + "/.env" });
import "@nomicfoundation/hardhat-toolbox";

const { PK } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    // for mainnet
    optimism: {
      url: "https://mainnet.optimism.io",
      accounts: [],
    },
    // for testnet
    base_goerli: {
      url: "https://goerli.base.org",
      accounts: [PK ? PK : ``],
    },
    "optimism-goerli": {
      url: "https://goerli.optimism.io",
      accounts: [PK ? PK : ``],
    },
    "polygon-mumbai": {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [PK ? PK : ``],
    },
    // for the local dev environment
    "optimism-local": {
      url: "http://localhost:8545",
      accounts: [],
    },
  },
  etherscan: {
    apiKey: {
      mainnet: "YOUR_ETHERSCAN_API_KEY",
      optimisticEthereum: "YOUR_OPTIMISTIC_ETHERSCAN_API_KEY",
      arbitrumOne: "YOUR_ARBISCAN_API_KEY",
      polygonMumbai: "FHXESKTNDHF18AYX8BXXIWVWB4CP5WCW2N",
    },
  },
};

export default config;
