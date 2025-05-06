task("deploy", "Deploys the contract", async (taskArgs, hre) => {

    const myTokenAddress = taskArgs.depositaddress;

    if (!hre.ethers.utils.isAddress(myTokenAddress)) {
        console.log("Invalid deposit token address");
        return;
    }

    const contractFactory = await hre.ethers.getContractFactory("BuggyRewardPool");
    const contract = await contractFactory.deploy(myTokenAddress);
    await contract.deployed();

    console.log("Contract deployed to", contract.address);
})
.addParam("depositaddress", "Adding Depostit Address");