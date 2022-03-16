pragma solidity >=0.4.24;

library Models {
    enum State {
        New,
        ForSaleByFarmer,
        PurchasedByDistributor,
        ForSale
    }

    struct Product{
        string sku;
        address currentOwner;
        address createdBy;
        uint price;
        string productName;
        State status;
        bool exist;
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
