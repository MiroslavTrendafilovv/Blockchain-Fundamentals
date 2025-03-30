require("@nomicfoundation/hardhat-toolbox");
require("./tasks/index.js");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "localhost",
  networks: {
    hardhat: {
      chainId: 1337 // Default chain ID for Hardhat local network
    },
    localhost: {
      url: "http://127.0.0.1:8545"
    }
  },
  solidity: "0.8.28",
};
