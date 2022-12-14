import Web3 from "web3";

const getWeb3 = () =>
  new Promise((resolve, reject) => {
    // wait for load completion to avoid the race for injecting web3
    window.addEventListener("load", async () => {
      // modern dapp browser...
      if (window.ethereum) {
        const web3 = new Web3(window.ethereum);
        try {
          // request accounts if needed
          await window.ethereum.request({ method: "eth_requestAccounts" });
          // account loaded
          resolve(web3);
        } catch (error) {
          reject(error);
        }
      }
      // legacy dapp browser
      else if (window.web3) {
        // use Mist/ Metamask's provider
        const web3 = window.web3;
        console.log("Injected web3 detected");
        resolve(web3);
      }
      // Fallback to localhost; use dev console port by default
      else {
        const provider = new Web3.providers.HttpProvider(
          "http://127.0.0.1:8545"
        );
        const web3 = new Web3(provider);
        console.log("no web3 instance detected, using local web3");
        resolve(web3);
      }
    });
  });

export default getWeb3;
