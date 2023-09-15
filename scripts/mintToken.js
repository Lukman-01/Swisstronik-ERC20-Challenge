// Import necessary modules and libraries.
const hre = require("hardhat"); // Hardhat Runtime Environment
const BigNumber = require('bignumber.js'); // Library for handling big numbers
const { encryptDataField, decryptNodeResponse } = require("@swisstronik/swisstronik.js"); // Encryption and decryption functions

// Function to send a shielded transaction
const sendShieldTransaction = async (signer, destination, data, value) => {
    // Get the RPC link from the Hardhat network configuration
    const rpclink = hre.network.config.url;
    // Encrypt the data using the provided RPC link
    const [encryptedData] = await encryptDataField(rpclink, data);
    // Send a transaction from the signer's address to the destination with encrypted data and value
    return await signer.sendTransaction({
        from: signer.address,
        to: destination,
        data: encryptedData,
        value: value
    });
}

// Main function
async function main() {
    // Define contract address and token price
    const contractAddress = "0x6B9e263B97c230C12e11a49C65F31D6F42B471cc";
    const tokenPrice = 0.000001;

    // Get the signer (account) from Hardhat
    const [signer] = await hre.ethers.getSigners();

    // Get the contract factory for the "IbukunToken" contract
    const contractFactory = await hre.ethers.getContractFactory("IbukunToken");

    // Attach the contract at the specified address
    const contract = contractFactory.attach(contractAddress);

    // Define the function name and the amount of tokens to mint
    const functionName = "mintTokens";
    const amountParam = 100;

    // Create a BigNumber instance to handle the amount and calculate the value in Ether
    const amount = new BigNumber(amountParam);
    const value = amount.multipliedBy(tokenPrice);
    const valueInWei = hre.ethers.parseEther(value.toString());

    // Send a shielded transaction to mint tokens
    const mintTX = await sendShieldTransaction(signer, contractAddress, contract.interface.encodeFunctionData(functionName, [amountParam.toString()]), valueInWei);

    // Wait for the transaction to be mined
    await mintTX.wait();

    // Log the transaction receipt
    console.log("Transaction Receipt: ", mintTX);
}

// Call the main function and handle errors
main()
    .then(() => process.exit(0)) // Exit with code 0 on success
    .catch(error => {
        console.log(error);
        process.exit(1); // Exit with code 1 on error
    });
