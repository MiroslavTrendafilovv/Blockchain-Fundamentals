require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("./tasks/index.js");
require("@nomicfoundation/hardhat-verify");

/** @type import('hardhat/config').HardhatUserConfig */



module.exports = {
solidity: "0.8.28",
settings: {
    optimazer:{
        enabled: true,
        runs: 200
    }
},
networks: {
sepolia: {
url: process.env.WEB3_PROVIDER_URL,
accounts: [process.env.PRIVATE_KEY]
}
},
etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: process.env.ETHERSCAN_API_KEY
}
};

