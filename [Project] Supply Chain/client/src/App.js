import "./App.css";
import getWeb3 from "./getWeb3";
import ItemManager from "./contracts/ItemManager.json";
// import ItemContract from "./contracts/Item.json";
import React, { useState, useEffect } from "react";

function App() {
  const [state, setState] = useState({
    web3: null,
    contract: null,
  });
  const [connectedAccount, setConnectedAccount] = useState("");
  const [itemName, setItemName] = useState("example_1");
  const [cost, setCost] = useState(0);

  useEffect(() => {
    const init = async () => {
      try {
        const web3 = await getWeb3();
        const networkId = await web3.eth.net.getId();

        const deployedNetwork = ItemManager.networks[networkId];
        console.log("Contract Address: ", deployedNetwork.address);
        const contractInstance = new web3.eth.Contract(
          ItemManager.abi,
          deployedNetwork && deployedNetwork.address
        );
        setState({ web3, contract: contractInstance });
        listenToPaymentEvents();
      } catch (error) {
        console.log(error);
      }
    };
    init();
  }, []);

  const setAccountListener = (provider) => {
    provider.on("accountsChanged", (accounts) => {
      setConnectedAccount(accounts[0]);
    });
  };

  useEffect(() => {
    const getAccount = async () => {
      const { web3 } = state;
      const accounts = await web3.eth.getAccounts();
      setAccountListener(web3.givenProvider);
      setConnectedAccount(accounts[0]);
    };
    state.web3 && getAccount();
  }, [state, state.web3]);

  const creatingItem = async () => {
    const { contract } = state;
    console.log(itemName, cost, contract);
    let result = await contract.methods
      .createItem(itemName, cost)
      .send({ from: connectedAccount });
    console.log(result);
    alert(
      "Send " +
        cost +
        " Wei to " +
        result.events.SupplyChainStep.returnValues._itemAddress
    );
  };

  const listenToPaymentEvents = () => {
    const { contract } = state;
    contract.events.SupplyChainStep().on("data", async function (evt) {
      console.log(evt);
      let itemObj = await contract.methods
        .items(evt.returnValues._itemIndex)
        .call();
      alert("Item " + itemObj._identifier + " was paid, deliver it now!");
    });
  };

  return (
    <div className="App">
      <h1>Event Trigger / Supply chain Example</h1>
      <h2>Items</h2>
      <h2>Add Items</h2>
      Cost in Wei:{" "}
      <input
        type="number"
        name="cost"
        value={cost}
        onChange={(e) => setCost(e.target.value)}
      />
      Item Identifier:{" "}
      <input
        type="text"
        name="itemName"
        value={itemName}
        onChange={(e) => setItemName(e.target.value)}
      />
      <button type="button" onClick={creatingItem}>
        Create new Item
      </button>
    </div>
  );
}

export default App;
