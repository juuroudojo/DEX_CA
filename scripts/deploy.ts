import { ethers } from "hardhat";

async function main() {
  const address = ['0x7A34b2f0DA5ea35b5117CaC735e99Ba0e2aCEECD']

  const DEX = await ethers.getContractFactory("DEX");
  const dex = await DEX.deploy(1, address);

  await dex.deployed();

  console.log(`Wallet deployed to ${dex.address}`);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});