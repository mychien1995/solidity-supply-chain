pragma solidity >=0.4.24;
pragma experimental ABIEncoderV2;

import "./Models.sol";

contract SupplyChain {
    event FarmerAdded(string indexed name);

    mapping(address => Models.Farmer) public farmers;
    mapping(address => Models.Distributor) public distributors;
    mapping(string => Models.Product) public products;
    address[] public farmersKey;
    address[] public distributorsKey;

    //address public constant ownerAddress = 0x435E41FA208CC37123f274b07F7E26b75262de4B;
    address public constant ownerAddress =
        0xaeF822a8199D240cE61e69ff45069B56a219B042;

    function getRole(address account) public view returns (string memory) {
        if (account == ownerAddress) return "Admin";
        if (farmers[account].exist) return "Farmer";
        if (distributors[account].exist) return "Distributor";
        return "Anonymous";
    }

    function addFarmer(address account, string memory name) public {
        if (msg.sender == ownerAddress) {
            if (!farmers[account].exist) {
                farmers[account] = Models.Farmer(account, name, true);
                farmersKey.push(account);
            }
        }
    }

    function getFarmers() public view returns (Models.Farmer[] memory) {
        Models.Farmer[] memory ret = new Models.Farmer[](farmersKey.length);
        for (uint256 i = 0; i < farmersKey.length; i++) {
            ret[i] = farmers[farmersKey[i]];
        }
        return ret;
    }

    function getFarmer(address account)
        public
        view
        returns (string memory name)
    {
        if (msg.sender == ownerAddress) {
            if (farmers[account].exist) {
                return farmers[account].name;
            }
        }
        return "Farmer not found";
    }

    function addDistributor(address account, string memory name) public {
        if (msg.sender == ownerAddress) {
            if (!distributors[account].exist) {
                distributors[account] = Models.Distributor(account, name, true);
                distributorsKey.push(account);
            }
        }
    }

    function getDistributors() public view returns (Models.Distributor[] memory) {
        Models.Distributor[] memory ret = new Models.Distributor[](distributorsKey.length);
        for (uint256 i = 0; i < distributorsKey.length; i++) {
            ret[i] = distributors[distributorsKey[i]];
        }
        return ret;
    }

    function getDistributor(address account)
        public
        view
        returns (string memory name)
    {
        if (msg.sender == ownerAddress) {
            if (distributors[account].exist) {
                return distributors[account].name;
            }
        }
        return "Farmer not found";
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
