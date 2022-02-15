pragma solidity ^0.8.11;

import "node_modules/@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract Document is ERC721Upgradeable, IGovernee {
    uint256 public docHash;
    string private baseURI;

    function initialize() public initializer {
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

    function setBaseURI(string memory _baseURI) private virtual onlyOwner {
        baseURI = _baseURI;
    }

    function setNewDocHash(string memory _docHash) private virtual onlyOwner {
        docHash = _docHash;
    }

    function getCurrentDocURI() public virtual returns (string memory) {
        return super.tokenURI(1);
    }
}
