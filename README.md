# NFT Royalty Marketplace Standard 🎨

A professional-grade implementation of an NFT marketplace that respects and enforces the **EIP-2981 NFT Royalty Standard**. This repository provides the smart contracts necessary to list, buy, and handle royalty payouts in a decentralized environment.

## Features
- **EIP-2981 Integration**: Automatically calculates and distributes royalties to creators upon sale.
- **Fixed-Price Listings**: Simple and secure atomic swaps between ETH and NFTs.
- **Marketplace Fee**: Built-in functionality for platform service fees.
- **Pull-Payment Pattern**: Uses OpenZeppelin's Escrow/PullPayment for secure fund distribution.

## Tech Stack
- Solidity ^0.8.20
- OpenZeppelin Contracts (ERC721, ERC2981, ReentrancyGuard)
- Hardhat Development Environment

## Quick Start
1. Deploy `RoyaltyNFT.sol` (The NFT Collection).
2. Deploy `NFTRoyaltyMarket.sol` (The Marketplace).
3. Use `setApprovalForAll` on the NFT contract to allow the marketplace to handle transfers.
