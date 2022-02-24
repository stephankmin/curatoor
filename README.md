# On-Chain Governance for NFT Minting and Metadata

Governance protocol allowing users to vote on mints and token metadata for NFT collections with an ERC20. Users can create content and hash it off-chain (e.g. art, music, long-form text), then both propose and vote on metadata for the next mint of a particular NFT collection. An NFT within a collection can only be minted by that collection's governor contract, and the governor contract can only execute function calls once quorum has been reached through votes represented by an ERC20 token.

Contracts and tests are incomplete.

## Dependencies and Inspiration

- [OpenZeppelin Governance Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/governance)
- [Mirror Editions V1](https://github.com/mirror-xyz/editions-v1)
- [Foundry](https://github.com/gakonst/foundry)
