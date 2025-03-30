const ethers = require("ethers");

//hardhat runtime environment

task("accounts", "Prints the list of accounts",
    async (taskArgs, hre) => {
        const accounts = await hre.ethers.getSigners();
        for (const account of accounts) {
            console.log(account.address);
        }
    });

//
// task("balance", "Prints an account's balance").setAction(
//     async (_, hre) => {
//         const [account] = await hre.ethers.getSigners();
//         const balance = await hre.ethers.provider.getBalance(account.address);
//         console.log(hre.ethers.formatEther(balance), "ETH");
//     }
// );

task("balance", "Prints an account's balance")
    .addParam("address", "the address to send to")
    .setAction(
        async (taskParams, hre) => {
            //const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545");
            const provider = hre.ethers.provider;
            const res = await provider.getBalance(taskParams.address);
            console.log("Result in ETH", ethers.formatEther(res));

        }
    )

task("send", "Send ETH to given address")
    .addParam("address", "the address to send to")
    .addParam("amount", "amount to be sent")
    .setAction(
        async (taskParams, hre) => {
            const [signer] = await hre.ethers.getSigners();
            const tx = await signer.sendTransaction({
                to: taskParams.address,
                value: ethers.parseEther(taskParams.amount),
            }
            );

            console.log("Tx send");
            console.log(tx)

            const receipt = await tx.wait();
            console.log("Tx mined");
            console.log(receipt)
        }
    )


task("contract", "Send ETH to given address")
    .setAction(
        async (taskParams, hre) => {
            //const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545");
            const conractFactory = hre.ethers.getContractFactory();
            const contract = await conractFactory.deploy();
            console.log("Contract deployed to", await contract.getAddress());

        }
    )

task("mintToken", "Mint tokenks to a specific address")
    .addParam("to", "the address to send to")
    .addParam("amount", "amount to be sent")
    .setAction(
        async (taskArgs, hre) => {
            const [signer] = await hre.ethers.getSigners();
            const tokenAddress = "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266";
            const tokenABI = [
            "function mint(address to, uint256 amount) public"
            ];

            const tokenContract = new hre.ethers.Contract(tokenAddress, tokenABI, signer);
            const tx = await tokenContract.mint(taskArgs.to, ethers.parseEther(taskArgs.amount));

            await tx.wait();

            console.log(`Minted ${taskArgs.amount} tokens to ${taskArgs.to}`);

        }
    )

task("transfer", "Transfer tokens between addresses")
    .addParam("address", "the address to send to")
    .addParam("amount", "amount to be sent")
    .setAction(
        async (taskParams, hre) => {

            const [signer] = await hre.ethers.getSigners();

            const tx = await signer.sendTransaction(
                {
                    to: taskParams.address,
                    value: ethers.parseEther(taskParams.amount),
                }
            );

            console.log("Tx send");
            console.log(tx)
            const receipt = await tx.wait();
            console.log("Tx mined");
            console.log(receipt)

        }

   )

