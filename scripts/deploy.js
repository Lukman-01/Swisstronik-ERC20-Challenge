const hre = require("hardhat");

async function main() {
   
  const contract = await hre.ethers.deployContract("IbukunToken");

  await contract.waitForDeployment();

  console.log(`IbukunToken contract deployed to ${contract.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


// IbukunToken contract deployed to 0xb4691275Ef6D57Ab5952c07806ac6b9B46992697