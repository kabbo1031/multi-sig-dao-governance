const { ethers } = require("ethers");

async function proposeTransfer(multiSigAddr, receiver, amountWei) {
  const MultiSig = await ethers.getContractAt("MultiSig", multiSigAddr);
  const tx = await MultiSig.submit(receiver, amountWei, "0x");
  await tx.wait();
  console.log("Transaction Proposed!");
}
