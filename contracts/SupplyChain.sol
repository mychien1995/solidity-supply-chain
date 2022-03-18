pragma solidity >=0.4.24;
pragma experimental ABIEncoderV2;

import "./Models.sol";

contract SupplyChain {
    event FarmerAdded(string indexed name);

    mapping(address => Models.Farmer) public farmers;
    mapping(address => Models.Distributor) public distributors;
    mapping(string => Models.Product) public products;
    mapping(address => string[]) public productOwners;
    mapping(string => Models.ItemHistory[]) public histories;
    address[] public farmersKey;
    address[] public distributorsKey;

    address public constant ownerAddress =
        0x614D7C541d980DA6972b976Cc13cB0F07651B7e8;

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
        if (farmers[account].exist) {
            return farmers[account].name;
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

    function getDistributors()
        public
        view
        returns (Models.Distributor[] memory)
    {
        Models.Distributor[] memory ret = new Models.Distributor[](
            distributorsKey.length
        );
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
        if (distributors[account].exist) {
            return distributors[account].name;
        }
        return "Distributor not found";
    }

    function getOwnerProducts() public view returns (Models.Product[] memory) {
        string[] memory currentFarmerProduct = productOwners[msg.sender];
        Models.Product[] memory ret = new Models.Product[](
            currentFarmerProduct.length
        );
        for (uint256 i = 0; i < currentFarmerProduct.length; i++) {
            ret[i] = products[currentFarmerProduct[i]];
        }
        return ret;
    }

    function getProduct(string memory sku)
        public
        view
        returns (Models.Product memory)
    {
        Models.Product memory product = products[sku];
        return product;
    }

    function addProduct(
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
            productOwners[msg.sender].push(product.sku);
            histories[product.sku].push(
                Models.ItemHistory(
                    msg.sender,
                    msg.sender,
                    block.number,
                    Models.Action.CreateProduct,
                    block.timestamp
                )
            );
        }
    }

    event DebugEvent(string sku, string sku2);
    event EqualEvent(string sku, string sku2);

    function transferProduct(string memory sku, address toAddress) public {
        Models.Product memory product = products[sku];
        if (product.exist && product.currentOwner == msg.sender) {
            product.currentOwner = toAddress;
            string[] memory currentOwnerProducts = productOwners[msg.sender];
            for (uint256 i = 0; i < currentOwnerProducts.length; i++) {
                if (
                    keccak256(abi.encodePacked(currentOwnerProducts[i])) ==
                    keccak256(abi.encodePacked(sku))
                ) {
                    emit EqualEvent(currentOwnerProducts[i], sku);
                    delete currentOwnerProducts[i];
                }
                emit DebugEvent(currentOwnerProducts[i], sku);
            }
            productOwners[msg.sender] = currentOwnerProducts;
            productOwners[toAddress].push(sku);
            histories[product.sku].push(
                Models.ItemHistory(
                    msg.sender,
                    toAddress,
                    block.number,
                    Models.Action.TransferProduct,
                    block.timestamp
                )
            );
        }
    }

    function getItemHistory(string memory sku)
        public
        view
        returns (Models.ItemHistory[] memory)
    {
        return histories[sku];
    }
}
