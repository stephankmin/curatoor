pragma solidity ^0.8.0;

import {Collection} from "./Collection.sol";
import {CollectionGovernor} from "./CollectionGovernor.sol";
import {GovernanceERC20Token} from "./GovernanceERC20Token.sol";
import {IVotes} from "../lib/@openzeppelin/contracts/governance/utils/IVotes.sol";
import {BeaconProxy} from "../lib/@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {UpgradeableBeacon} from "../lib/@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

contract CollectionFactory {
    Collection[] public collections;

    event CollectionCreated(string name, address collectionAddress, uint256 collectionId);

    uint256 private nextCollectionId;

    address public collectionUpgradeableBeacon;

    address public governorUpgradeableBeacon;

    address public governanceTokenUpgradeableBeacon;

    constructor(address _collectionImplementation, address _governorImplementation, address _governanceTokenImplementation) {
        collectionUpgradeableBeacon = address(new UpgradeableBeacon(_collectionImplementation));
        governorUpgradeableBeacon = address(new UpgradeableBeacon(_governorImplementation));
        governanceTokenUpgradeableBeacon = address(new UpgradeableBeacon(_governanceTokenImplementation));
    }
    
    function createCollection(string memory name, string memory symbol) external {
        // hash of collection name and symbol to create deterministic clone addresses
        bytes32 collectionSalt = keccak256(abi.encodePacked(msg.sender, name, symbol));

        BeaconProxy collectionBeaconProxy = new BeaconProxy(collectionUpgradeableBeacon, "");

        BeaconProxy governorBeaconProxy = new BeaconProxy(governorUpgradeableBeacon, "");

        BeaconProxy governanceTokenBeaconProxy = new BeaconProxy(governanceTokenUpgradeableBeacon, "");

        collections[nextCollectionId] = Collection({
            name: name,
            symbol: symbol,
            collectionAddress: address(collectionBeaconProxy),
            governorAddress: address(governorBeaconProxy),
            governanceTokenAddress: address(governanceTokenBeaconProxy)
        });

        emit CollectionCreated(name, collectionAddress, nextCollectionId);

        ++nextCollectionId;
    }
}