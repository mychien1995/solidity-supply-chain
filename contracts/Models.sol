pragma solidity >=0.4.24;

library Models {
    enum Action{
        CreateProduct,
        TransferProduct
    }

    struct Product{
        string sku;
        address currentOwner;
        address createdBy;
        uint price;
        string productName;
        bool exist;
    }

    struct ItemHistory{
        address transferFrom;
        address transferTo;
        uint blocknumber;
        Action action;
        uint256 timestamp;
    }

    struct Farmer{
        address ownerAddress;
        string name;
        bool exist;
    }

    struct Distributor{
        address ownerAddress;
        string name;
        bool exist;
    }
}
