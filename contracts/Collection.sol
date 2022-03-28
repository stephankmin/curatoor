pragma solidity ^0.8.0;

import "../lib/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../lib/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "../lib/@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import "../lib/@openzeppelin/contracts/governance/IGovernor.sol";
import {ERC165Checker} from "../lib/@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import {Clones} from "../lib/@openzeppelin/contracts/proxy/Clones.sol";
import {CollectionGovernor} from "./CollectionGovernor.sol";
import {GovernanceERC20Token} from "./GovernanceERC20Token.sol";
import {IVotes} from "../lib/@openzeppelin/contracts/governance/utils/IVotes.sol";

contract Collection is ERC721, IERC721Receiver {
    using ERC165Checker for address;

    error NonGovernor(address account);

    error NonexistantCollection();

    address public governor;

    string internal baseURI;

    uint256 private nextCollectionId;

    uint256 private nextTokenId;

    // EVENTS
    event CollectionCreated(string name, address governor, uint256 collectionId);

    event VersionMinted(
        uint256 collectionId,
        uint256 tokenId,
        bytes32 contentHash
    );

    modifier onlyGovernor(uint256 collectionId) {
        require(
            msg.sender == governor,
            "Only the governor can call this function"
        );
        _;
    }

    constructor(string memory _name, string memory _symbol, string memory _baseURI) ERC721(_name, _symbol) {
        baseURI = _baseURI;
        admin = msg.sender;
        governanceTokenImplementation = IVotes(new GovernanceERC20Token());
        governanceTokenImplementationAddress = address(governanceTokenImplementation);
        governorImplementation = address(new CollectionGovernor(governanceTokenImplementation));
    }

    // function mintVersion(
    //     uint256 collectionId,
    //     bytes32 contentHash
    // ) external virtual onlyGovernor(collectionId) {
    //     uint256 versionId = collections[collectionId].latestVersionId + 1;

    //     address recipient = collections[collectionId].governor;

    //     collectionVersions[collectionId][versionId] = Version({
    //         tokenId: nextTokenId,
    //         contentHash: contentHash
    //     });

    //     _safeMint(recipient, nextTokenId);

    //     emit VersionMinted(collectionId, nextTokenId, contentHash);

    //     ++nextTokenId;
    // }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    baseURI,
                    _toString(tokenToCollection[tokenId]),
                    "/",
                    _toString(tokenId)
                )
            );
    }

    // function transferGovernance(uint256 collectionId, address newGovernor)
    //     external
    //     onlyGovernor(collectionId)
    // {
    //     require(
    //         collections[documentId].governor != newGovernor,
    //         "New governor must be different from current governor"
    //     );

    //     Collection storage document = collections[documentId];
    //     document.governor = newGovernor;
    // }

    // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
    function _toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            ++digits;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        return
            bytes4(
                keccak256("onERC721Received(address,address,uint256,bytes)")
            );
    }
}
