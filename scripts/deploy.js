const hre = require("hardhat");

async function main() {
   
  const contract = await hre.ethers.deployContract("IbukunToken", ["Welcome to Ibukun Tokens Minting Contract"]);

  await contract.waitForDeployment();

  console.log(`IbukunToken contract deployed to ${contract.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});