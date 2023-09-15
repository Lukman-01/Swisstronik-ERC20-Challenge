// Import the Hardhat Runtime Environment (hre) module.
const hre = require("hardhat");

// Define an asynchronous function named 'main'.
async function main() {
   
  // Deploy the "IbukunToken" smart contract and store the deployed contract instance.
  const contract = await hre.ethers.deployContract("IbukunToken");

  // Wait for the contract deployment to complete.
  await contract.waitForDeployment();

  // Log a message indicating the deployment target address of the contract.
  console.log(`IbukunToken contract deployed to ${contract.target}`);
}

// Call the 'main' function and handle any errors that occur.
main().catch((error) => {
  console.error(error);
  // Set the process exit code to 1 to indicate an error occurred during execution.
  process.exitCode = 1;
});
