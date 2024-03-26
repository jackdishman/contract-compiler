import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config({ path: __dirname + "/.env" });
require("@openzeppelin/hardhat-upgrades");

const { PK, ETHERSCAN_API_KEY, BASE_API_KEY, POLYGON_API_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.23",
  paths: {
    sources: "./contracts/boats",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  networks: {
    // for mainnet
    optimism: {
      url: "https://mainnet.optimism.io",
      accounts: [PK ?? ``],
    },
    "base-mainnet": {
      url: "https://mainnet.base.org",
      accounts: [PK ?? ``],
    },
    // for testnet
    "base-sepolia": {
      url: "https://sepolia.base.org",
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
          browserURL: "https://sepolia.basescan.org",
        },
      },
    ],
  },
};

export default config;
