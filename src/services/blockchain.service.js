/* eslint-disable no-undef */
const Web3 = require('web3');
import { Role } from "../constants";

const App = {
    web3Provider: {},
    initialized: false,
    contract: {},
    currentRole: Role.ANONYMOUS,
    account: ''
}

const BlockchainService = {

    init: async() => {
        await BlockchainService.loadWeb3();
        await BlockchainService.loadAccount();
        await BlockchainService.loadContract();
        await BlockchainService.checkRole();
    },

    loadWeb3: async() => {
        if (typeof web3 !== 'undefined') {
            App.web3Provider = web3.currentProvider
            web3 = new Web3(web3.currentProvider)
            App.initialized = true;
        } else {
            window.alert("Please connect to Metamask.")
        }
        if (window.ethereum) {
            window.web3 = new Web3(ethereum)
            try {
                await ethereum.enable()
                web3.eth.sendTransaction({ /* ... */ })
                App.initialized = true;
            } catch (error) {
                // User denied account access...
            }
        } else if (window.web3) {
            App.web3Provider = web3.currentProvider
            window.web3 = new Web3(web3.currentProvider)
            web3.eth.sendTransaction({ /* ... */ })
            App.initialized = true;
        } else {
            console.log('Non-Ethereum browser detected. You should consider trying MetaMask!')
        }
    },

    loadAccount: async() => {
        var accounts = await web3.eth.getAccounts();
        web3.eth.defaultAccount = accounts[0];
        App.account = accounts[0];
    },

    loadContract: async() => {
        const todoList = await $.getJSON('./contracts/SupplyChain.json')
        const contract = TruffleContract(todoList)
        contract.setProvider(App.web3Provider)
        App.contract = await contract.deployed()
    },

    checkRole: async() => {
        if (!App.initialized) return;
        App.currentRole = await App.contract.getRole(App.account);
    }
}

export default BlockchainService;