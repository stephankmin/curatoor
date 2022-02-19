// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../Document.sol";
import "../DocGovernor.sol";
import "../GovernanceERC20Token.sol";
import "../DocProxy.sol";

contract DocumentTest is DSTest {
    GovernanceERC20Token govToken;
    Document document;
    DocGovernor docGovernor;
    DocProxy docProxy;

    // Arguments
    string public name = "livedoc";
    string public symbol = "DOC";
    address public governor = address(docGovernor);

    function setUp() public {
        govToken = new GovernanceERC20Token();
        document = new Document();
        document.initialize(name, symbol, governor);
        docGovernor = new DocGovernor(govToken, address(document));
        docProxy = new DocProxy(address(document), "");
    }

    function testInitializeConfig() public {
        assertEq(
            keccak256(abi.encodePacked(document.name())),
            keccak256(abi.encodePacked(name))
        );
        assertEq(
            keccak256(abi.encodePacked(document.symbol())),
            keccak256(abi.encodePacked(symbol))
        );
        assertEq(document.governor(), governor);
    }

    function testInitializeMint() public {
        assertTrue(document.minted());
    }
}
