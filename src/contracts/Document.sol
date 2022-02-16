pragma solidity ^0.8.0;

import "../../lib/@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract Document is ERC721Upgradeable {
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

    function initialize(address _governor) public initializer {
        governor = _governor;
        __ERC721_init("livedoc", "DOC");
        _safeMint(address(this), 1);
    }

    function _safeMint(address to, uint256 tokenId) internal virtual override {
        revert("Function can only be called in initialize()");
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

    function tokenURI() public view virtual returns (string memory) {
        string memory base = _baseURI();
        return
            bytes(base).length > 0
                ? string(abi.encodePacked(base, docHash))
                : "";
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        revert("Only one token");
    }
}
