// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract GoalTracker {

    uint256 public goalAmount;  // The target amount for the user to reach
    uint256 public baseReward;  // The base reward to be compounded
    uint256 public currentSpending;  // Total spending accumulated by the user
    uint256 public totalReward;  // Total reward that the user can claim
    bool public rewardClaimed;  // Flag to ensure the reward can only be claimed once

    // Custom error to handle multiple claims
    error RewardAlreadyClaimed();

    // Constructor to set the initial goal and base reward
    constructor(uint256 _goalAmount, uint256 _baseReward) {
        goalAmount = _goalAmount;
        baseReward = _baseReward;
        currentSpending = 0;
        totalReward = 0;
        rewardClaimed = false;
    }

    // Function to add spending
    function addSpending(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        currentSpending += amount;
    }

    // Function to calculate and claim the reward
    function claimReward() public {
        // Ensure the goal has been met
        if (currentSpending < goalAmount) {
            revert("Goal has not been met yet.");
        }

        // Ensure the reward hasn't already been claimed
        if (rewardClaimed) {
            revert RewardAlreadyClaimed();
        }

        // Apply the for loop to compound the base reward multiple times
        for (uint256 i = 0; i < currentSpending / goalAmount; i++) {
            totalReward += baseReward;  // Compounding the base reward
        }

        // Mark the reward as claimed
        rewardClaimed = true;
    }

    // Function to get the current spending
    function getCurrentSpending() public view returns (uint256) {
        return currentSpending;
    }

    // Function to get the total reward that the user can claim
    function getTotalReward() public view returns (uint256) {
        return totalReward;
    }
}
