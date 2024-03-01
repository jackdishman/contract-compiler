import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config({ path: __dirname + "/.env" });

const { PK, ETHERSCAN_API_KEY, BASE_API_KEY, POLYGON_API_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.23",
  networks: {
    // for mainnet
    optimism: {
      url: "https://mainnet.optimism.io",
      accounts: [PK ?? ``],
    },
    'base-mainnet': {
      url: "https://mainnet.base.org",
      accounts: [PK ?? ``],
    },
    // for testnet
    'base-sepolia': {
      url: 'https://sepolia.base.org',
      accounts: [PK ?? ``],
    },
    "optimism-goerli": {
      url: "https://goerli.optimism.io",
      accounts: [PK ?? ``],
    },
    "polygon-mumbai": {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [PK ?? ``],
    },
    // for the local dev environment
    "optimism-local": {
      url: "http://localhost:8545",
      accounts: [PK ?? ``],
    },
  },
  etherscan: {
    apiKey: {
      mainnet: ETHERSCAN_API_KEY ?? ``,
      optimisticEthereum: "YOUR_OPTIMISTIC_ETHERSCAN_API_KEY",
      polygonMumbai: POLYGON_API_KEY ?? ``,
      "base-sepolia": BASE_API_KEY ?? ``,
    },
    customChains: [
      {
        network: "base-sepolia",
        chainId: 84532,
        urls: {
         apiURL: "https://api-sepolia.basescan.org/api",
         browserURL: "https://sepolia.basescan.org"
        }
      }
    ]
   },
};

export default config;
