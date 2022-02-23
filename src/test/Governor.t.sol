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

contract GovernorTest is DSTest {
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    // Contract Instances
    GovernanceERC20Token govToken;
    Documents document;
    DocGovernor docGovernor;
    DocProxy docProxy;
}
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../Documents.sol";
import "../DocGovernor.sol";
import "../GovernanceERC20Token.sol";
import "../DocProxy.sol";

contract DocumentTest is DSTest {
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    // Contract Instances
    GovernanceERC20Token govToken;
    Documents documents;
    DocGovernor docGovernor;

    // Contract addresses
    address govTokenAddress;
    address docGovernorAddress;
    address documentsAddress;

    string testBaseURI = "testuri.com";

    function setUp() public {
        govToken = new GovernanceERC20Token();
        govTokenAddress = address(govToken);

        docGovernor = new DocGovernor(govToken);
        docGovernorAddress = address(docGovernor);

        documents = new Documents();
        documents.initialize(testBaseURI);
    }
}
