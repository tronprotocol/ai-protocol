// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface Payment {

    // @dev accept the round fee and comfort the binding oracle with native token
    function acceptRoundFeeAndComfortingOracle(uint round) payable external;

    // @dev accept the round fee and comfort the binding oracle with specified erc20 or trc20 token
    function acceptRoundFeeAndComfortingOracle(uint round, uint token, uint amount) external;
}
