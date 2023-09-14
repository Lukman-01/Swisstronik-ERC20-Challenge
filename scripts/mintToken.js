const hre = require("hardhat");
const BigNumber = require('bignumber.js');
const { encryptDataField, decryptNodeResponse } = require("@swisstronik/swisstronik.js");

const sendShieldTransaction = async (signer, destination, data, value) => {
    const rpclink = hre.network.config.url;
    const [encryptedData] = await encryptDataField(rpclink, data);
    return await signer.sendTransaction({
        from: signer.address,
        to: destination,
        data: encryptedData,
        value: value
    });
}

async function main() {
    const contractAddress = "0x47d750Bdb4eE0920e6C9A3C5Bb92Ff06c92e3D0f";
    const tokenPrice = 0.000001;
    const [signer] = await hre.ethers.getSigners();
    const contractFactory = await hre.ethers.getContractFactory("IbukunToken");
    const contract = contractFactory.attach(contractAddress);
    const functionName = "mintTokens";
    const amountParam = 100;
    const amount = new BigNumber(amountParam);
    const value = amount.multipliedBy(tokenPrice);
    const valueInWei = hre.ethers.parseEther(value.toString());
    const mintTX = await sendShieldTransaction(signer, contractAddress, contract.interface.encodeFunctionData(functionName, [amountParam.toString()]), valueInWei);
    await mintTX.wait();
    console.log("Transaction Receipt: ", mintTX);
}

main().then(() => process.exit(0))
    .catch(error => {
    console.log(error);
    process.exit(1);
});