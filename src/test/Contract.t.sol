// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../contracts/Document.sol";
import "../contracts/DocGovernor.sol";
import "../contracts/GovernanceERC20Token.sol";

contract ContractTest is DSTest {
    Document document;
    DocGovernor docgov;
    GovernanceERC20Token govtoken;

    function setUp() public {
        govtoken = new GovernanceERC20Token();
        document = new Document();
        docgov = new DocGovernor(govtoken, address(document));
    }

    function testExample() public {
        assertTrue(true);
    }
}
