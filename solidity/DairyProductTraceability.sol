// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract DairyProductTraceability {
    // Events
    event NewProduct(
        string productId,
        string farmId,
        string processorId,
        string retailerId,
        string consumerId,
        uint256 timestamp
    );
    event ProductTransfer(
        string productId,
        string fromId,
        string toId,
        uint256 timestamp
    );

    // Mapping from product ID to product information
    mapping(string => Product) public products;

    struct Product {
        string farmId;
        string processorId;
        string retailerId;
        string consumerId;
        uint256 timestamp;
    }

    // Add a new product to the system
    function addProduct(string memory _productId, string memory _farmId)
        public
    {
        products[_productId] = Product(_farmId, "", "", "", block.timestamp);
        emit NewProduct(_productId, _farmId, "", "", "", block.timestamp);
    }

    // Transfer a product from one entity to another
    function transferProduct(
        string memory _productId,
        string memory _fromId,
        string memory _toId
    ) public {
        require(
            stringsEquals(products[_productId].farmId, _fromId) ||
                stringsEquals(products[_productId].processorId, _fromId) ||
                stringsEquals(products[_productId].retailerId, _fromId) ||
                stringsEquals(products[_productId].consumerId, _fromId),
            "Invalid from ID"
        );

        if (stringsEquals(products[_productId].farmId, _fromId)) {
            products[_productId].farmId = _toId;
        } else if (stringsEquals(products[_productId].processorId, _fromId)) {
            products[_productId].processorId = _toId;
        } else if (stringsEquals(products[_productId].retailerId, _fromId)) {
            products[_productId].retailerId = _toId;
        } else if (stringsEquals(products[_productId].consumerId, _fromId)) {
            products[_productId].consumerId = _toId;
        }

        products[_productId].timestamp = block.timestamp;
        emit ProductTransfer(_productId, _fromId, _toId, block.timestamp);
    }

    function stringsEquals(string memory s1, string memory s2)
        private
        pure
        returns (bool)
    {
        bytes memory b1 = bytes(s1);
        bytes memory b2 = bytes(s2);
        uint256 l1 = b1.length;
        if (l1 != b2.length) return false;
        for (uint256 i = 0; i < l1; i++) {
            if (b1[i] != b2[i]) return false;
        }
        return true;
    }
}
