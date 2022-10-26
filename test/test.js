const { ethers } = require("hardhat");

describe("DeployTest", function() {
    it("", async function () {
        const nftContractFactory = await ethers.getContractFactory("Bingo");
        const nftContract = await nftContractFactory.deploy(
            "https://bingo.yuk6ra.com/bingo_cards/init/",
            "https://bingo.yuk6ra.com/assets/bingo/bingo.png",
            "https://bingo.yuk6ra.com/assets/revealed/normal.png",
            "https://bingo.yuk6ra.com/assets/revealed/winner.png",
            "BINGO", 
            "NORMAL", 
            "WINNER"
        );
        await nftContract.deployed();
        console.log("Contract deployed to:", nftContract.address);
        
        let txn = await nftContract.mintNFT(100);
        await txn.wait();    
    
        console.log("Done");    
    })
})
