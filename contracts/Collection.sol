pragma solidity ^0.8.0;

import "../lib/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "../lib/@openzeppelin/contracts/governance/IGovernor.sol";
import {ERC721Upgradeable} from "../lib/@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {ERC165Checker} from "../lib/@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import {CollectionGovernor} from "./CollectionGovernor.sol";
import {GovernanceERC20Token} from "./GovernanceERC20Token.sol";
import {IVotes} from "../lib/@openzeppelin/contracts/governance/utils/IVotes.sol";

contract Collection is ERC721Upgradeable {
    error NonGovernor(address account);

    address public governor;

    string internal baseURI;

    uint256 private nextCollectionId;

    uint256 private nextTokenId;

    event VersionMinted(
        uint256 collectionId,
        uint256 tokenId,
        bytes32 contentHash
    );

    event BaseURIUpdated(string baseURI);

    modifier onlyGovernor(uint256 collectionId) {
        require(
            msg.sender == governor,
            "Only the governor can call this function"
        );
        _;
    }

    function initialize(string memory _name, string memory _symbol) public payable initializer {
        __ERC721_init(_name, _symbol);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    baseURI,
                    "/",
                    _toString(tokenId)
                )
            );
    }

    function updateBaseURI(string calldata _newBaseURI) external onlyGovernor {
        baseURI = _newBaseURI;

        emit BaseURIUpdated(_newBaseURI);
    }

    // function transferGovernance(uint256 collectionId, address newGovernor)
    //     external
    //     onlyGovernor(collectionId)
    // {
    //     require(
    //         collections[documentId].governor != newGovernor,
    //         "New governor must be different from current governor"
    //     );

    //     Collection storage document = collections[documentId];
    //     document.governor = newGovernor;
    // }

    // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
    function _toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            ++digits;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
