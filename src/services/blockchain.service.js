/* eslint-disable no-undef */
const Web3 = require("web3");
import { Role } from "../constants";

const App = {
  web3Provider: {},
  initialized: false,
  contract: undefined,
  currentRole: Role.UNDEFINED,
  account: "",
};

const BlockchainService = {
  init: async () => {
    await BlockchainService.loadWeb3();
    await BlockchainService.loadAccount();
    await BlockchainService.loadContract();
    await BlockchainService.checkRole();
  },

  loadWeb3: async () => {
    if (App.initialized) return;
    if (typeof web3 !== "undefined") {
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
      App.initialized = true;
    } else {
      window.alert("Please connect to Metamask.");
    }
    if (window.ethereum) {
      window.web3 = new Web3(ethereum);
      try {
        await ethereum.enable();
        web3.eth.sendTransaction({
          /* ... */
        });
        App.initialized = true;
      } catch (error) {
        // User denied account access...
      }
    } else if (window.web3) {
      App.web3Provider = web3.currentProvider;
      window.web3 = new Web3(web3.currentProvider);
      web3.eth.sendTransaction({
        /* ... */
      });
      App.initialized = true;
    } else {
      console.log(
        "Non-Ethereum browser detected. You should consider trying MetaMask!"
      );
    }
  },

  loadAccount: async () => {
    if (App.account != "") return;
    var accounts = await web3.eth.getAccounts();
    web3.eth.defaultAccount = accounts[0];
    App.account = accounts[0];
  },

  loadContract: async () => {
    if (App.contract != undefined) return;
    const contractJson = await $.getJSON("./contracts/SupplyChain.json");
    const contract = TruffleContract(contractJson);
    contract.setProvider(App.web3Provider);
    App.contract = await contract.deployed();
  },

  checkRole: async () => {
    if (App.currentRole != Role.UNDEFINED) return App.currentRole;
    await BlockchainService.loadWeb3();
    await BlockchainService.loadAccount();
    await BlockchainService.loadContract();
    console.log(App.account);
    App.currentRole = await App.contract.getRole(App.account.toString());
    return App.currentRole;
  },

  addFarmer: async (address, name) => {
    if (!App.initialized) return;
    await App.contract.addFarmer(address, name, { from: App.account });
  },

  getFarmer: async (address) => {
    if (!App.initialized) return;
    return await App.contract.getFarmer(address);
  },

  getCurrentAddress: () => {
    if (!App.initialized) return;
    return App.account;
  },

  getFarmers: async () => {
    if (!App.initialized) return;
    return await App.contract.getFarmers();
  },

  addDistributor: async (address, name) => {
    if (!App.initialized) return;
    await App.contract.addDistributor(address, name, { from: App.account });
  },

  getDistributor: async (address) => {
    if (!App.initialized) return;
    return await App.contract.getDistributor(address);
  },

  getDistributors: async () => {
    if (!App.initialized) return;
    return await App.contract.getDistributors();
  },

  addProduct: async (sku, name, price) => {
    if (!App.initialized) return;
    await App.contract.addProduct(sku, price, name, { from: App.account });
  },

  getProducts: async () => {
    if (!App.initialized) return;
    return await App.contract.getOwnerProducts({ from: App.account });
  },

  getProductInfo: async (sku) => {
    if (!App.initialized) return;
    return await App.contract.getProduct(sku);
  },

  transferProduct: async (sku, address) => {
    if (!App.initialized) return;
    return await App.contract.transferProduct(sku, address, { from: App.account });
  },

  getProductHistory: async (sku) => {
    if (!App.initialized) return;
    return await App.contract.getItemHistory(sku);
  },
};

export default BlockchainService;
