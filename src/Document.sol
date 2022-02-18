pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Document is ERC721Upgradeable, IERC721Receiver {
    string private name_;

    string private symbol_;

    string private baseURI;

    address public governor;

    uint256 public docHash;

    // Events

    event NewDocHash(uint256 docHash);

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
        address governor_
    ) public initializer {
        name_ = _name;
        symbol_ = _symbol;
        governor = governor_;
        __ERC721_init(_name, _symbol);
        _safeMint(address(this), 1);
    }

    function _minted() public virtual returns (bool) {
        return super._exists(1);
    }

    function _safeMint(address to, uint256 tokenId) internal virtual override {
        require(!_minted() && tokenId == 1, "Document: tokenId must be 1");
        super._safeMint(to, tokenId);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _baseURI_) public virtual onlyGovernor {
        baseURI = _baseURI_;

        emit NewBaseURI(_baseURI_);
    }

    function setNewDocHash(uint256 _docHash) internal virtual onlyGovernor {
        docHash = _docHash;

        emit NewDocHash(_docHash);
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
}
