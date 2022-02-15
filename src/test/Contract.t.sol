// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";

contract ContractTest is DSTest {
    Document document;
    DocGovernor docgov;
    GovernanceERC20Token govtoken;

    function setUp() public {
        document = new Document();
        docgov = new DocGovernor();
        govtoken = new GovernanceERC20Token();
    }

    function testExample() public {
        assertTrue(true);
    }
}
