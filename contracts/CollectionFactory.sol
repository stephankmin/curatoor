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

    // Upgradeable Beacon that stores the address for the implementation of a Collection ERC721
    address public collectionUpgradeableBeacon;

    // Upgradeable Beacon that stores the address for the implementation of a Collection Governor
    address public governorUpgradeableBeacon;

    // Upgradeable Beacon that stores the address for the implementation of a Collection Governance Token
    address public governanceTokenUpgradeableBeacon;

    constructor(address _collectionUpgradeableBeacon, address _governorUpgradeableBeacon, address _governanceTokenUpgradeableBeacon) {
        collectionUpgradeableBeacon = _collectionUpgradeableBeacon;
        governorUpgradeableBeacon = _governorUpgradeableBeacon;
        governanceTokenUpgradeableBeacon = _governanceTokenUpgradeableBeacon;
    }
    
    function createCollection(string memory name, string memory symbol) external {
        // encodes function call to initialize collection contract
        bytes memory collectionProxyInitializeData = abi.encodeWithSignature("initialize(string,string)", name, symbol);

        // deploys a Beacon Proxy pointing to the Upgradeable Beacon for a Collection ERC721
        BeaconProxy collectionBeaconProxy = new BeaconProxy(collectionUpgradeableBeacon, collectionProxyInitializeData);

        // deploys a Beacon Proxy pointing to the Upgradeable Beacon for a Collection Governor
        BeaconProxy governorBeaconProxy = new BeaconProxy(governorUpgradeableBeacon, "");

        // deploys a Beacon Proxy pointing to the Upgradeable Beacon for a Collection Governance Token
        BeaconProxy governanceTokenBeaconProxy = new BeaconProxy(governanceTokenUpgradeableBeacon, "");

        collections[nextCollectionId] = Collection({
            name: name,
            symbol: symbol,
            collectionAddress: address(collectionBeaconProxy),
            governorAddress: address(governorBeaconProxy),
            governanceTokenAddress: address(governanceTokenBeaconProxy)
        });

        emit CollectionCreated(name, address(collectionBeaconProxy), nextCollectionId);

        ++nextCollectionId;
    }
}