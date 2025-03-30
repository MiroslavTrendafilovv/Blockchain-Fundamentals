task("deploy", "Deploys the contract", async (taskArgs, hre) => {

    const contractFactory = await hre.ethers.getContractFactory("BuggyRewardPool");
    const contract = await contractFactory.deploy();
    await contract.deployed();

    console.log("Contract deployed to", contract.address);
});