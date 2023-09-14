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


// IbukunToken contract deployed to 0xE006Ef36BA678Ed201587E91200de47255c3d664