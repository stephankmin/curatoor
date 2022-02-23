// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../Documents.sol";
import "../DocGovernor.sol";
import "../GovernanceERC20Token.sol";
import "../DocProxy.sol";

interface CheatCodes {
    function prank(address) external;

    function expectRevert(bytes calldata) external;
}

contract DocumentTest is DSTest {
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    // Contract Instances
    GovernanceERC20Token govToken;
    Documents document;
    DocGovernor docGovernor;
    DocProxy docProxy;

    // Document Arguments
    string public name = "livedoc";
    string public symbol = "DOC";
    address public governor;

    function setUp() public {
        govToken = new GovernanceERC20Token();
        docGovernor = new DocGovernor(govToken);
        governor = address(docGovernor);
        document = new Document();
        document.initialize(name, symbol, governor);
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

    function testSetNewDocHashRevert() public {
        uint256 testHash = uint256(keccak256("This is a test hash"));
        cheats.expectRevert(
            "Only the governor contract can call this function"
        );
        document.setNewDocHash(testHash);
    }

    function testSetNewDocHashSuccess() public {
        uint256 testHash = uint256(keccak256("This is a test hash"));
        cheats.prank(address(governor));
        document.setNewDocHash(testHash);
        assertEq(document.docHash(), testHash);
    }

    function testTokenURI() public {
        uint256 testHash = uint256(keccak256("This is a test hash"));
        cheats.prank(address(governor));
        document.setNewDocHash(testHash);
    }
}
