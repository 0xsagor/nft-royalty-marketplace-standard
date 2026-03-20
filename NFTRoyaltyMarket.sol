// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract NFTRoyaltyMarket is ReentrancyGuard {
    struct Listing {
        address seller;
        address nftAddress;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) public listings;
    uint256 public listingCount;

    event ItemListed(uint256 indexed listingId, address indexed seller, uint256 price);
    event ItemSold(uint256 indexed listingId, address indexed buyer, uint256 price);

    function listToken(address _nftAddress, uint256 _tokenId, uint256 _price) external {
        IERC721 nft = IERC721(_nftAddress);
        require(nft.ownerOf(_tokenId) == msg.sender, "Not the owner");
        require(nft.isApprovedForAll(msg.sender, address(this)), "Market not approved");

        listingCount++;
        listings[listingCount] = Listing(msg.sender, _nftAddress, _tokenId, _price, true);

        emit ItemListed(listingCount, msg.sender, _price);
    }

    function buyToken(uint256 _listingId) external payable nonReentrant {
        Listing storage listing = listings[_listingId];
        require(listing.active, "Not active");
        require(msg.value >= listing.price, "Insufficient payment");

        listing.active = false;

        // Handle Royalties via EIP-2981
        (address royaltyReceiver, uint256 royaltyAmount) = IERC2981(listing.nftAddress).royaltyInfo(listing.tokenId, listing.price);

        uint256 sellerProceeds = listing.price - royaltyAmount;

        // Transfer funds
        if (royaltyAmount > 0) {
            payable(royaltyReceiver).transfer(royaltyAmount);
        }
        payable(listing.seller).transfer(sellerProceeds);

        // Transfer NFT
        IERC721(listing.nftAddress).safeTransferFrom(listing.seller, msg.sender, listing.tokenId);

        emit ItemSold(_listingId, msg.sender, listing.price);
    }
}
