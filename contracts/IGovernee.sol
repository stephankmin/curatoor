pragma solidity ^0.8.0;

import "../utils/introspection/ERC165.sol";

abstract contract IGovernee is ERC165 {
    function getAddress() public view virtual returns (address);
}
