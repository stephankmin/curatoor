# Curatoor

Curatoor is a protocol for creating NFTs that require community consensus in order to be minted. Each NFT Collection in the ERC721 contract has its own unique Governor contract and ERC20 token, both of which are deployed when `createCollection` is called in `Collections.sol`. ERC20 token holders can vote on the metadata for NFTs and when these NFTs will be minted. A Governor can only call functions for its corresponding Collection. NFTs are minted to the Governor address.
