const hre = require("hardhat")

async function main(){

 const votingContract = await hre.ethers.getContractFactory("Voting");
 const deployedVotingContract = await votingContract.deploy();

 console.log(deployedVotingContract.target)
}

main().catch((error)=>{
    console.error(error);
    process.exitCode = 1;
})

// contract address deployed : 0x5d31CeAae10f57edfFAb5949ddf8fb48D09Eb351