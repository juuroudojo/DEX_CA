import * as dotenv from "dotenv";
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-etherscan";
import "@typechain/hardhat";
import "hardhat-gas-reporter"

dotenv.config();


const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      { version: "0.8.9" },
      { version: "=0.7.6" },
      { version: "0.8.11" },
    ],
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      forking: {
        enabled: true,
        url: process.env.MAINNET_URL as string
      }
    },
    gorilla: {
      url: process.env.Goerli_API_KEY || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    matic: {
      url: process.env.MUMBAI || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    sepolia: {
      url: process.env.Sepolia_API_KEY || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    }
  },
  gasReporter: {
    enabled: false,
  },

  etherscan: {
    apiKey: process.env.POLYGON_SCAN
  },

};

export default config;
