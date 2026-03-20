// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RoyaltyNFT is ERC721URIStorage, ERC2981, Ownable {
    uint256 private _tokenIds;

    constructor() ERC721("ArtisticTokens", "ART") Ownable(msg.sender) {}

    function mint(address recipient, string memory tokenURI, uint96 feeNumerator) public onlyOwner returns (uint256) {
        _tokenIds++;
        uint256 newItemId = _tokenIds;

        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        
        // Sets royalty for this specific token (e.g., 500 = 5%)
        _setTokenRoyalty(newItemId, recipient, feeNumerator);

        return newItemId;
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721URIStorage, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
