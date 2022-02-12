pragma solidity ^0.8.11;

import "node_modules/@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract Document is ERC721Upgradeable, IGovernee {
    uint256 public totalSupply = 1;

    function initialize() public {
        __ERC721_init("livedoc", "DOC");
    }

    function getAddress() public view returns (address) {
        return address(this);
    }
}
