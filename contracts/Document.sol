pragma solidity ^0.8.11;

import "node_modules/@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract Document is ERC721Upgradeable {
    uint256 public totalSupply = 1;

    function initialize() public {}
}
