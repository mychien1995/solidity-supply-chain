pragma solidity >=0.4.24;

import "./Models.sol";

contract SupplyChain {
    mapping(address => Models.Farmer) farmers;
    mapping(address => Models.Distributor) distributors;
    mapping(string => Models.Product) products;

    address public constant ownerAddress =
        0xE0f5206BBD039e7b0592d8918820024e2a7437b9;

    function addFarmer(address account, string memory name) public {
        if (msg.sender == ownerAddress) {
            if (!farmers[account].exist) {
                Models.Farmer memory newEntry;
                newEntry.name = name;
                newEntry.exist = true;
                newEntry.ownerAddress = account;
                farmers[account] = newEntry;
            }
        }
    }

    function addDistributors(address account, string memory name) public {
        if (msg.sender == ownerAddress) {
            if (!distributors[account].exist) {
                Models.Distributor memory newEntry;
                newEntry.name = name;
                newEntry.exist = true;
                newEntry.ownerAddress = account;
                distributors[account] = newEntry;
            }
        }
    }

    function createProducts(
        string memory sku,
        uint256 price,
        string memory productName
    ) public {
        Models.Farmer memory farmer;
        farmer = farmers[msg.sender];
        if (farmer.exist) {
            Models.Product memory product;
            product.sku = sku;
            product.price = price;
            product.productName = productName;
            product.createdBy = farmer.ownerAddress;
            product.currentOwner = farmer.ownerAddress;
            product.exist = true;
            products[product.sku] = product;
        }
    }
}
