task("deploy", "Deploys the contract", async (taskArgs, hre) => {

    if(!taskArgs.unlockTime){

        throw new Error("unlockTime is required") 
    }

    const contractFactory = await hre.ethers.getContractFactory("Lock");
    const contract = await contractFactory.deploy(taskArgs.unlockTime);

    console.log("Contract deployed to", contract.target);
})
.addParam("unlockTime", "");