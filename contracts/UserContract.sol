// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface User {

    // @dev read the specified topic, and return the queried data
    function readDataFromOracle(string calldata topic, uint256 index) external returns(string memory);

    // @dev pay for the querying fee in the specified round
    function payOracleFee(uint256 round) payable external;
}
