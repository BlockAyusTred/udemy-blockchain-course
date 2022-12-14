import "./App.css";
import getWeb3 from "./getWeb3";
import MyToken from "./contracts/MyToken.json";
import MyTokenSale from "./contracts/MyTokenSale.json";
import KycContract from "./contracts/KycContract.json";
import React, { useState, useEffect } from "react";

// problem in this code 
// - it doesn't update the no. of token itself after connecting metamask
// - after refreshing have to press refres my token button to get that 
// - and some issue with get connected account address

function App() {
  const [state, setState] = useState({
    web3: null,
    tokenContract: null,
    tokenSaleContract: null,
    kycContract: null,
  });
  const [kycAddress, setKycAddress] = useState("0x1234");
  const [tokenSaleAddress, setTokenSaleAddress] = useState("0x00000");
  const [userTokens, setUserTokens] = useState(0);
  const [connectedAccount, setConnectedAccount] = useState("");

  useEffect(() => {
    const init = async () => {
      try {
        const web3 = await getWeb3();
        const networkId = await web3.eth.net.getId();
        const accounts = await web3.eth.getAccounts();
        setConnectedAccount(accounts[0]);

        const tokenInstance = new web3.eth.Contract(
          MyToken.abi,
          MyToken.networks[networkId] && MyToken.networks[networkId].address,
        );
        const tokenSaleInstance = new web3.eth.Contract(
          MyTokenSale.abi,
          MyTokenSale.networks[networkId] && MyTokenSale.networks[networkId].address,
        );
        const kycInstance = new web3.eth.Contract(
          KycContract.abi,
          KycContract.networks[networkId] && KycContract.networks[networkId].address,
        );
        setTokenSaleAddress(MyTokenSale.networks[networkId].address);
        setState({web3: web3, tokenContract:tokenInstance, tokenSaleContract:tokenSaleInstance, kycContract:kycInstance });
        // listenToTokenTransfer();
      } catch (error) {
        console.log(error);
      }
    };
    init();
  }, []);

  // const setAccountListener = (provider) => { 
  //   provider.on("accountsChanged", (accounts) => {
  //     setConnectedAccount(accounts[0]);
  //   });
  // };

  // useEffect(() => {
  //   const getAccount = async () => {
  //     const { web3 } = state;
  //     const accounts = await web3.eth.getAccounts();
  //     setAccountListener(web3.givenProvider);
  //     setConnectedAccount(accounts[0]);
  //     console.log(accounts[0]);
  //     console.log(connectedAccount);
  //   };
  //   state.web3 && getAccount();
  // }, [state, state.web3]);

  const handleKycWhitelisting = async () => {
    const {kycContract} = state;
    await kycContract.methods.setKycCompleted(kycAddress).send({from: connectedAccount});
    alert("Kyc for "+ kycAddress + " is completed");
  };

  // const listenToTokenTransfer = async () => {
  //   const {tokenContract} = state;
  //   tokenContract.events.Transfer({to:connectedAccount}).on("data", updateUserTokens);
  // };

  const updateUserTokens = async () => {
    const {tokenContract} = state;
    let userToken = await tokenContract.methods.balanceOf(connectedAccount).call();
    setUserTokens(userToken); 
  }

  const handleBuyTokens = async () => {
    const {web3, tokenSaleContract} = state;
    await tokenSaleContract.methods.buyTokens(connectedAccount).send({from: connectedAccount,value: web3.utils.toWei("1", "wei")});
  }

  return (
    <div className="App">
      <h1>StarDucks Cappucino Token Sale</h1>
      <p>Get your Tokens today!</p>
      <h2>Kyc Whitelisting</h2>
      Address to allow: <input type="text" name="kycAddress" value={kycAddress} onChange={(e) => setKycAddress(e.target.value)} /> 
      <button type="button" onClick={handleKycWhitelisting} >Add to whitelist</button>
      <p>If you want ot buy tokens, send Wei to this address: {tokenSaleAddress}</p>
      <p>You currently have: {userTokens} CAPPU Tokens</p>
      <button type="button" onClick={updateUserTokens}>Refresh my token</button>
      <button type="button" onClick={handleBuyTokens} >Buy more tokens</button>
    </div>
  );
}

export default App;
