pragma solidity ^0.8.0;

import "../lib/@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "../lib/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "../lib/@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import "../lib/@openzeppelin/contracts/governance/IGovernor.sol";
import {ERC165Checker} from "../lib/@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";

contract Documents is ERC721Upgradeable, IERC721Receiver, UUPSUpgradeable {
    using ERC165Checker for address;

    error NonGovernor(address account);

    string public constant _name = "Documents";

    string public constant _symbol = "DOCS";

    bytes4 public constant GOVERNOR_INTERFACE_ID = type(IGovernor).interfaceId;

    string internal baseURI;

    uint256 private nextDocumentId;

    uint256 private nextTokenId;

    address public admin;

    mapping(uint256 => Document) public documents;

    mapping(uint256 => uint256) public tokenToDocument;

    mapping(uint256 => mapping(uint256 => Version)) public documentVersions;

    struct Document {
        address governor;
        uint256 latestVersionId;
    }

    struct Version {
        uint256 tokenId;
        uint256 contentHash;
    }

    // EVENTS
    event DocumentCreated(address governor, uint256 documentId);

    event VersionMinted(
        uint256 documentId,
        uint256 tokenId,
        uint256 contentHash
    );

    modifier onlyGovernor(uint256 documentId) {
        require(
            msg.sender == documents[documentId].governor,
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
    function createDocument(address governor) external virtual {
        if (!governor.supportsInterface(GOVERNOR_INTERFACE_ID))
            revert NonGovernor(governor);

        documents[nextDocumentId] = Document({
            governor: governor,
            latestVersionId: 0
        });

        emit DocumentCreated(governor, nextDocumentId);

        ++nextDocumentId;
    }

    function mintVersion(
        uint256 documentId,
        uint256 tokenId,
        uint256 contentHash
    ) external virtual onlyGovernor(documentId) {
        uint256 versionId = documents[documentId].latestVersionId + 1;

        address recipient = documents[documentId].governor;

        documentVersions[documentId][versionId] = Version({
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
            documents[documentId].governor != newGovernor,
            "New governor must be different from current governor"
        );

        if (!newGovernor.supportsInterface(GOVERNOR_INTERFACE_ID))
            revert NonGovernor(newGovernor);

        Document storage document = documents[documentId];
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
    ) external returns (bytes4) {
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
