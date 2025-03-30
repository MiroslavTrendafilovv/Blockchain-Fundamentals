require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("./tasks/index.js");

/** @type import('hardhat/config').HardhatUserConfig */



module.exports = {
solidity: "0.8.28",
networks: {
sepolia: {
url: process.env.WEB3_PROVIDER_URL,
accounts: [process.env.PRIVATE_KEY]
}
}
};

