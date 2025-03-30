const hre = require("hardhat");

async function main(){

    const [deployer] = await ethers.getSigners();

    const contractFactory = await ethers.getContractFactory("SimpleToken");
    const contract = await contractFactory.deploy();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("SimpleToken is deployed to", contract.address);




    

}

main()
   .then(() => process.exit(0))
   .catch((error) => {
        console.log(error);
        process.exit(1);
    })