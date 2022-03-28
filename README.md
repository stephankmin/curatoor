# Curatoor

Curatoor is a protocol for creating NFTs that require community consensus in order to be minted.

Each NFT Collection consists of an ERC721 contract, a Governor contract, and an ERC20 token representing weighted voting. ERC20 token holders can vote on the metadata for their corresponding NFT Collection and when these NFTs will be minted. A Governor can only call functions for its Collection. NFTs are minted to the Governor address.

`CollectionFactory.sol` points to three `UpgradeableBeacon` contracts, which store the addresses of the logic implementations of the three contract types (ERC721, Governor, and ERC20 token). Whenever `createCollection` is called in `CollectionFactory.sol`, all three of these contracts are deployed as `BeaconProxies` implementing the logic pointed to by the `UpgradeableBeacons`.
