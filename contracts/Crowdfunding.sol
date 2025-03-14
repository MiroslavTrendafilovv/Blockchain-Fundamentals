// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Crowdfunding {

    // Campaign parameters
    uint256 public goalAmount;      // The funding target (in base units)
    uint256 public endTime;         // The expiration time (in seconds)
    uint256 public totalFundsRaised;  // Total funds raised during the campaign
    address public owner;           // The owner of the campaign

    // Track contributions from each backer
    mapping(address => uint256) public contributions;

    // Struct to track a contributor's information (optional)
    struct Contributor {
        uint256 amountContributed; // Amount a contributor has contributed
        bool hasWithdrawn;         // If they have already withdrawn their contribution
    }

    // Mapping to track contributor details
    mapping(address => Contributor) public contributors;

    // Constructor to initialize the campaign's goal and expiration time
    constructor(uint256 _goalAmount, uint256 _durationInDays) {
        goalAmount = _goalAmount;
        owner = msg.sender;
        endTime = block.timestamp + (_durationInDays * 1 days); // Set end time based on duration
        totalFundsRaised = 0;
    }

    // Modifier to check if the campaign has expired
    modifier onlyBeforeEndTime() {
        require(block.timestamp < endTime, "Campaign has expired.");
        _;
    }

    // Modifier to check if the campaign has ended
    modifier onlyAfterEndTime() {
        require(block.timestamp >= endTime, "Campaign is still ongoing.");
        _;
    }

    // Function to contribute to the campaign
    function contribute(uint256 baseUnits) external payable onlyBeforeEndTime {
        require(baseUnits > 0, "Contribution must be greater than zero.");
        require(msg.value == baseUnits, "Sent value must match the contribution.");

        // Update total funds raised
        totalFundsRaised += baseUnits;

        // Track individual contributor's amount
        contributors[msg.sender].amountContributed += baseUnits;

        // Emit an event (optional, for transparency)
        emit ContributionReceived(msg.sender, baseUnits);
    }

    // Event to log contributions
    event ContributionReceived(address indexed contributor, uint256 amount);

    // Function to check if the funding goal has been met
    function checkGoalReached() public view returns (bool) {
        return totalFundsRaised >= goalAmount;
    }

    // Function to withdraw contributions if the goal is not met by endTime
    function withdraw() external onlyAfterEndTime {
        uint256 contributedAmount = contributors[msg.sender].amountContributed;
        require(contributedAmount > 0, "No contributions to withdraw.");
        require(!contributors[msg.sender].hasWithdrawn, "Already withdrawn.");

        // If goal is not met, refund the backer
        require(totalFundsRaised < goalAmount, "Goal met, no refunds.");

        // Set withdrawal flag to true to prevent double withdrawal
        contributors[msg.sender].hasWithdrawn = true;

        // Reset the contributor's contribution amount
        contributors[msg.sender].amountContributed = 0;

        // Refund the contributor
        payable(msg.sender).transfer(contributedAmount);
    }

    
  

 


}
