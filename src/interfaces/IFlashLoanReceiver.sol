// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

/**
 * @title IFlashLoanReceiver
 * @notice Defines the basic interface of a flashloan-receiver contract.
 * @dev Implement this interface to develop a flashloan-compatible flashLoanReceiver contract
 * @dev Inspired by Aave:
 * https://github.com/aave/aave-v3-core/blob/master/contracts/flashloan/interfaces/IFlashLoanReceiver.sol
 */
interface IFlashLoanReceiver {
    /**
     * @notice Executes an operation after receiving the flash-borrowed assets
     * @dev Ensure that the contract can return the debt + premium, e.g., has
     *      enough funds to repay and has approved the Pool to pull the total amount
     * @param asset The addresses of the flash-borrowed assets
     * @param amount The amounts of the flash-borrowed assets
     * @param fee The flat fee of each flash-borrowed asset
     * @param initiator The address of the flashloan initiator
     * @param params The byte-encoded params passed when initiating the flashloan
     * @return True if the execution of the operation succeeds, false otherwise
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 fee,
        address initiator,
        bytes calldata params
    )
        external
        returns (bool);
}
