// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "../lib/@openzeppelin/contracts/governance/Governor.sol";
import "../lib/@openzeppelin/contracts/governance/IGovernor.sol";
import "../lib/@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "../lib/@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "../lib/@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";

contract CollectionGovernor is
    Governor,
    GovernorVotes,
    GovernorCountingSimple,
    GovernorVotesQuorumFraction
{
    error NotGovernee();

    error NotOwner(address sender);

    address public governee;

    address public owner;

    constructor(IVotes _token)
        Governor("CollectionGovernor")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
    {
        owner == msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner(msg.sender);
        _;
    }

    function votingDelay() public pure override returns (uint256) {
        return 6575; // 1 day
    }

    function votingPeriod() public pure override returns (uint256) {
        return 46027; // 1 week
    }

    function proposalThreshold() public pure override returns (uint256) {
        return 0;
    }

    function quorum(uint256 blockNumber)
        public
        view
        override(IGovernor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    function getVotes(address account, uint256 blockNumber)
        public
        view
        override(IGovernor, GovernorVotes)
        returns (uint256)
    {
        return super.getVotes(account, blockNumber);
    }

    function state(uint256 proposalId)
        public
        view
        override(Governor)
        returns (ProposalState)
    {
        return super.state(proposalId);
    }

    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) public override(Governor) returns (uint256) {
        if (targets.length != 1 && targets[0] != governee)
            revert NotGovernee();

        return super.propose(targets, values, calldatas, description);
    }

    function _execute(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor) {
        if (targets.length != 1 && targets[0] != governee)
            revert NotGovernee();

        super._execute(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor) returns (uint256) {
        if (targets.length != 1 && targets[0] != governee)
            revert NotGovernee();

        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor() internal view override(Governor) returns (address) {
        return super._executor();
    }
}
