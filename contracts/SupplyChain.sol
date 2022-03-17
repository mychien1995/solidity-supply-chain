pragma solidity >=0.4.24;

import "./Models.sol";

contract SupplyChain {
    mapping(address => Models.Farmer) farmers;
    mapping(address => Models.Distributor) distributors;
    mapping(string => Models.Product) products;

    address public constant ownerAddress =
        0x435E41FA208CC37123f274b07F7E26b75262de4B;

    function getRole(address account) public view returns (string memory) {
        if (account == ownerAddress) return "Admin";
        if (farmers[account].exist) return "Farmer";
        if (distributors[account].exist) return "Distributor";
        return "Anonymous";
    }

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

    function getFarmer(address account) public view returns(string memory name){
        if (msg.sender == ownerAddress) {
            if (!farmers[account].exist) {
                return farmers[account].name;
            }
        }
        return "";
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
