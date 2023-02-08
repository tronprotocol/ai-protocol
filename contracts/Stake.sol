// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract FreezeV2Example {

    event BalanceFreezedV2(uint, uint);
    event BalanceUnfreezedV2(uint, uint);
    event AllUnFreezeV2Canceled();
    event ExpireUnfreezeWithdrew(uint);
    event ResourceDelegated(uint, uint, address);
    event ResourceUnDelegated(uint, uint, address);

    constructor() payable {}

    fallback() payable external {}

    receive() payable external {}

    function voteWitness(address[] calldata srList, uint[] calldata tpList) external {
        vote(srList, tpList);
    }

    function withdrawReward() external returns(uint) {
        return withdrawreward();
    }

    function queryRewardBalance() external view returns(uint) {
        return rewardBalance();
    }

    function isWitness(address sr) external view returns(bool) {
        return isSrCandidate(sr);
    }

    function queryVoteCount(address from, address to) external view returns(uint) {
        return voteCount(from, to);
    }

    function queryTotalVoteCount(address owner) external view returns(uint) {
        return totalVoteCount(owner);
    }

    function queryReceivedVoteCount(address owner) external view returns(uint) {
        return receivedVoteCount(owner);
    }

    function queryUsedVoteCount(address owner) external view returns(uint) {
        return usedVoteCount(owner);
    }

    function freezeBalanceV2(uint resourceType) payable external {
        freezebalancev2(msg.value, resourceType);
        emit BalanceFreezedV2(msg.value, resourceType);
    }

    function freezeBalanceV2(uint amount, uint resourceType) external {
        freezebalancev2(amount, resourceType);
        emit BalanceFreezedV2(amount, resourceType);
    }

    function unfreezeBalanceV2(uint amount, uint resourceType) external {
        unfreezebalancev2(amount, resourceType);
        emit BalanceUnfreezedV2(amount, resourceType);
    }

    function cancelAllUnfreezeV2() external {
        cancelallunfreezev2();
        emit AllUnFreezeV2Canceled();
    }

    function withdrawExpireUnfreeze() external returns(uint amount) {
        amount = withdrawexpireunfreeze();
        emit ExpireUnfreezeWithdrew(amount);
    }

    function delegateResource(uint amount, uint resourceType, address payable receiver) external {
        receiver.delegateResource(amount, resourceType);
        emit ResourceDelegated(amount, resourceType, receiver);
    }

    function unDelegateResource(uint amount, uint resourceType, address payable receiver) external {
        receiver.unDelegateResource(amount, resourceType);
        emit ResourceUnDelegated(amount, resourceType, receiver);
    }

    function getChainParameters() view public returns(uint, uint, uint, uint, uint) {
        return (chain.totalNetLimit, chain.totalNetWeight,
                chain.totalEnergyCurrentLimit, chain.totalEnergyWeight,
                chain.unfreezeDelayDays);
    }

    function getAvailableUnfreezeV2Size(address target) view public returns(uint) {
        return target.availableUnfreezeV2Size();
    }

    function getUnfreezableBalanceV2(address target, uint resourceType) view public returns(uint) {
        return target.unfreezableBalanceV2(resourceType);
   }

    function getExpireUnfreezeBalanceV2(address target, uint timestamp) view public returns(uint) {
        return target.expireUnfreezeBalanceV2(timestamp);
    }

    function getDelegatableResource(address target, uint resourceType) view public returns(uint, uint) {
        return (target.delegatableResource(resourceType), block.number);
    }

    function getResourceV2(address target, address from, uint resourceType) view public returns(uint) {
        return target.resourceV2(from, resourceType);
    }

    function checkUnDelegateResource(address target, uint amount, uint resourceType) view public returns(uint, uint, uint, uint) {
        (uint clean, uint dirty, uint restoreTime) = target.checkUnDelegateResource(amount, resourceType);
        return (clean, dirty, restoreTime, block.number);
    }

    function getResourceUsage(address target, uint resourceType) view public returns(uint, uint, uint) {
        (uint dirty, uint restoreTime) = target.resourceUsage(resourceType);
        return (dirty, restoreTime, block.number);
    }

    function getTotalResource(address target, uint resourceType) view public returns(uint) {
        return target.totalResource(resourceType);
    }

    function getTotalDelegatedResource(address from, uint resourceType) view public returns(uint) {
        return from.totalDelegatedResource(resourceType);
    }

    function getTotalAcquiredResource(address target, uint resourceType) view public returns(uint) {
        return target.totalAcquiredResource(resourceType);
    }

    function killme(address payable target) external {
        selfdestruct(target);
    }
}

contract Factory {

    function getPredictedAddress(bytes32 salt) view public returns(address) {
        // This complicated expression just tells you how the address
        // can be pre-computed. It is just there for illustration.
        // You actually only need ``new D{salt: salt}(arg)``.
        address predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0x41),
            address(this),
            salt,
            keccak256(abi.encodePacked(
                type(FreezeV2Example).creationCode
            ))
        )))));
        return predictedAddress;
    }

    function createDSalted(bytes32 salt) public returns(address) {
        FreezeV2Example e = new FreezeV2Example{salt: salt}();
        return address(e);
    }
}
