const { ethers } = require("hardhat");

describe("DeployTest", function() {
    it("", async function () {
        const nftContractFactory = await ethers.getContractFactory("Bingo");
        const nftContract = await nftContractFactory.deploy(
            "https://bingo.yuk6ra.com/bingo_cards/",
            "https://bingo.yuk6ra.com/assets/bingo/bingo.png",
            "https://bingo.yuk6ra.com/assets/revealed/nomal.png",
            "https://bingo.yuk6ra.com/assets/revealed/winner.png",
            "BINGO NFT TEST", 
            "TEST NOMAL", 
            "TEST WINNER"
        );
        await nftContract.deployed();
        console.log("Contract deployed to:", nftContract.address);
        
        let txn = await nftContract.mintNFT(10);
        await txn.wait();    
    
        console.log("Done");    
    })
})
