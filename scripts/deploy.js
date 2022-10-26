const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("Bingo");
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

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};
runMain();