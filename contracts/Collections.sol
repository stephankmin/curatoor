pragma solidity ^0.8.0;

import "../lib/@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "../lib/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "../lib/@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import "../lib/@openzeppelin/contracts/governance/IGovernor.sol";
import {ERC165Checker} from "../lib/@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";

contract Collections is ERC721Upgradeable, IERC721Receiver, UUPSUpgradeable {
    using ERC165Checker for address;

    error NonGovernor(address account);

    string public constant _name = "Collections";

    string public constant _symbol = "COLL";

    bytes4 public constant GOVERNOR_INTERFACE_ID = type(IGovernor).interfaceId;

    string internal baseURI;

    uint256 private nextDocumentId;

    uint256 private nextTokenId;

    address public admin;

    mapping(uint256 => Collection) public collections;

    mapping(uint256 => uint256) public tokenToDocument;

    mapping(uint256 => mapping(uint256 => Version)) public collectionVersions;

    struct Collection {
        address governor;
        uint256 latestVersionId;
    }

    struct Version {
        uint256 tokenId;
        uint256 contentHash;
    }

    // EVENTS
    event CollectionCreated(address governor, uint256 documentId);

    event VersionMinted(
        uint256 documentId,
        uint256 tokenId,
        uint256 contentHash
    );

    modifier onlyGovernor(uint256 documentId) {
        require(
            msg.sender == collections[documentId].governor,
            "Only the governor contract can call this function"
        );
        _;
    }

    modifier onlyAdmin() {
        require(
            msg.sender == admin,
            "Only the admin of this contract can call this function"
        );
        _;
    }

    function initialize(string memory _baseURI) public initializer {
        baseURI = _baseURI;
        admin = msg.sender;
    }

    // MINTING FUNCTIONS
    function createCollection(address governor) external virtual {
        if (!governor.supportsInterface(GOVERNOR_INTERFACE_ID))
            revert NonGovernor(governor);

        collections[nextDocumentId] = Collection({
            governor: governor,
            latestVersionId: 0
        });

        emit CollectionCreated(governor, nextDocumentId);

        ++nextDocumentId;
    }

    function mintVersion(
        uint256 documentId,
        uint256 tokenId,
        uint256 contentHash
    ) external virtual onlyGovernor(documentId) {
        uint256 versionId = collections[documentId].latestVersionId + 1;

        address recipient = collections[documentId].governor;

        collectionVersions[documentId][versionId] = Version({
            tokenId: nextTokenId,
            contentHash: contentHash
        });

        _safeMint(recipient, nextTokenId);

        emit VersionMinted(documentId, tokenId, contentHash);

        ++nextTokenId;
    }

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
                    _toString(tokenToDocument[tokenId]),
                    "/",
                    _toString(tokenId)
                )
            );
    }

    function transferGovernance(uint256 documentId, address newGovernor)
        external
        onlyGovernor(documentId)
    {
        require(
            collections[documentId].governor != newGovernor,
            "New governor must be different from current governor"
        );

        if (!newGovernor.supportsInterface(GOVERNOR_INTERFACE_ID))
            revert NonGovernor(newGovernor);

        Collection storage document = collections[documentId];
        document.governor = newGovernor;
    }

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

    // UPGRADE FUNCTIONS
    function _authorizeUpgrade(address newImplementation)
        internal
        virtual
        override
        onlyAdmin
    {}
}
