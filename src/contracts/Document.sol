pragma solidity ^0.8.0;

import "../../lib/@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract Document is ERC721Upgradeable {
    string private name;
    string private symbol;
    address public governor;
    uint256 public docHash;
    string private baseURI;

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
        address _governor
    ) public initializer {
        name = _name;
        symbol = _symbol;
        governor = _governor;
        __ERC721_init(_name, _symbol);
        _safeMint(address(this), 1);
    }

    function _safeMint(address to, uint256 tokenId) internal virtual override {
        revert("Document: cannot mint more tokens");
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
