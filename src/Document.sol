pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

contract Document is ERC721Upgradeable, IERC721Receiver, UUPSUpgradeable {
    string public constant name = "Documents";

    string public constant symbol = "DOCS";

    string internal baseURI;

    mapping (uint256 => Document) public documents;

    mapping (uint256 => mappping(uint256 => Version)) public documentIdToVersion;

    struct Document {
        address governor,
        uint256 latestHash,
        uint256 latestVersion
    }

    struct Version {
        uint256 documentId,
        uint256 tokenId,
        uint256 contentHash
    }

    uint256 private nextDocumentId;

    uint256 private nextTokenId;

    // EVENTS
    event DocumentCreated(address governor, uint256 nextDocumentId)

    event VersionMinted(uint256 documentId, uint256 contentHash, uint256 nextTokenId);

    event NewBaseURI(string baseURI);

    modifier onlyGovernor() {
        require(
            msg.sender == governor,
            "Only the governor contract can call this function"
        );
        _;
    }

    function initialize(
        string memory _name,
        string memory _symbol,
        address _governor
    ) public initializer {
        name_ = _name;
        symbol_ = _symbol;
        governor = _governor;
        __ERC721_init(_name, _symbol);
        _safeMint(address(this), 1);
    }

    // MINTING FUNCTIONS
    function createDocument(address governor, )

    function _safeMint(address to, uint256 tokenId) internal virtual override {
        require(!minted() && tokenId == 1, "Document: tokenId must be 1");
        super._safeMint(to, tokenId);
        emit Mint(tokenId);
    }

    // METADATA FUNCTIONS
    function _baseURI() internal view virtual override returns (string memory) {
        return "https://testtest.com";
    }

    function setNewDocHash(uint256 _docHash) public virtual onlyGovernor {
        docHash = _docHash;

        emit NewDocHash(_docHash);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(tokenId == 1, "Document: only one token");
        string memory base = _baseURI();
        return
            bytes(base).length > 0
                ? string(abi.encodePacked(base, docHash))
                : "";
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
        onlyGovernor
    {}
}
