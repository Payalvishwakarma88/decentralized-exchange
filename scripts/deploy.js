const { ethers } = require("hardhat");

async function main() {
  console.log("Deploying DEX contract...");

  // Get the contract factory
  const DEX = await ethers.getContractFactory("DEX");
  
  // Deploy the contract
  const dex = await DEX.deploy();
  
  // Wait for deployment to finish
  await dex.waitForDeployment();
  
  const deployedAddress = await dex.getAddress();
  console.log("DEX deployed to:", deployedAddress);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
