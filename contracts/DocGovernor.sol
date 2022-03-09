// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "../lib/@openzeppelin/contracts/governance/Governor.sol";
import "../lib/@openzeppelin/contracts/governance/IGovernor.sol";
import "../lib/@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "../lib/@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "../lib/@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";

contract DocGovernor is
    Governor,
    GovernorVotes,
    GovernorCountingSimple,
    GovernorVotesQuorumFraction
{
    address public governee;

    address public owner;

    event NewGovernee(address governee);

    constructor(IVotes _token)
        Governor("DocGovernor")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
    {
        owner == msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function setGovernee(address _governee) private onlyOwner {
        governee = _governee;

        emit NewGovernee(_governee);
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
        require(targets.length == 1, "Targets must contain one address");
        require(targets[0] == governee, "Can only propose changes to governee");

        return super.propose(targets, values, calldatas, description);
    }

    function _execute(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor) {
        require(targets.length == 1, "Targets must contain one address");
        require(targets[0] == governee, "Can only propose changes to governee");

        super._execute(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor) returns (uint256) {
        require(targets.length == 1, "Targets must contain one address");
        require(targets[0] == governee, "Can only propose changes to governee");

        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor() internal view override(Governor) returns (address) {
        return super._executor();
    }
}
