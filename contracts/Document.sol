pragma solidity ^0.8.11;

import "node_modules/@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract Document is ERC721Upgradeable, IGovernee {
    address public governor;
    uint256 public docHash;
    string private baseURI;

    event NewDocHash(string docHash);

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
        require(tokenId == 1); // function should only be called in intialize()

        super._safeMint(to, tokenId);
    }

    function _baseURI() internal view virtual override returns (string) {
        return baseURI;
    }

    function setBaseURI(string memory _baseURI) private virtual onlyGovernor {
        baseURI = _baseURI;

        emit NewBaseURI(_baseURI);
    }

    function setNewDocHash(uint256 _docHash) internal virtual onlyGovernor {
        docHash = _docHash;

        emit NewDocHash(_docHash);
    }

    function tokenURI() public view virtual returns (string memory) {
        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, docHash.toString()))
                : "";
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        revert();
    }
}
