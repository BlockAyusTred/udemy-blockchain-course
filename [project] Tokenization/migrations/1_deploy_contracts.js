
const MyToken = artifacts.require("MyToken");
const MyTokenSale = artifacts.require("MyTokenSale");
const KycContract = artifacts.require("./KycContract.sol");
require("dotenv").config({path: "../.env"});


module.exports = async function(deployer) {
    let addr = await web3.eth.getAccounts();
    await deployer.deploy(MyToken,process.env.INITIAL_TOKEN);
    await deployer.deploy(KycContract);
    await deployer.deploy(MyTokenSale, 1, addr[0], MyToken.address, KycContract.address);
    let instance = await MyToken.deployed();
    await instance.transfer(MyTokenSale.address, process.env.INITIAL_TOKEN);
}