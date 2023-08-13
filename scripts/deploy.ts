import { ethers } from "hardhat";

async function main() {
  const Contract = await ethers.getContractFactory("SimpleERC6551Account");
  // const SmartReceipt = await ethers.getContractFactory("SmartReceipt")

  // Fetch current gas price
  const gasPrice = await Contract.signer.getGasPrice();
  console.log(`Current gas price: ${ethers.utils.formatEther(gasPrice)}ETH`);

  // Estimate cost of deploying contract
  const data = Contract.getDeployTransaction();
  const estimatedGas = await ethers.provider.estimateGas(data);
  console.log(
    `Estimated cost of deployment: ${ethers.utils.formatEther(
      estimatedGas,
    )}ETH`,
  );

  const deployerBalance = await Contract.signer.getBalance();
  console.log(
    `Deployer balance: ${ethers.utils.formatEther(deployerBalance)}ETH`,
  );

  // l2_execution_fee = transaction_gas_price * l2_gas_used
  const deploymentPrice = gasPrice.mul(estimatedGas);
  console.log(
    `Deployment price: ${ethers.utils.formatEther(deploymentPrice)}ETH`,
  );

  if (deployerBalance.lt(deploymentPrice)) {
    throw new Error(
      `Not enough funds! Deployment costs ${ethers.utils.formatEther(
        deploymentPrice.sub(deployerBalance),
      )}ETH`,
    );
  }
  const contract = await Contract.deploy();
  await contract.deployed();
  console.log(
    `\n\nContract address: ${contract.address} <-- find contract details on Etherscan.io`,
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
