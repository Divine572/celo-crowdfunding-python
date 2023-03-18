// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;



contract Crowdfunding {
    address public owner;
    uint256 public totalContributions;
    uint256 public goal;
    bool public completed;
    mapping(address => uint256) public contributions;


    event Contribute(address indexed contributor, uint256 amount);

    constructor(uint256 _goal) {
        owner = msg.sender;
        goal = _goal;
    }

    function contribute() public payable {
        require(!completed, "Crowdfunding has been completed.");
        require(msg.value > 0, "Contribution amount must be greater than 0.");

        contributions[msg.sender] += msg.value;
        totalContributions += msg.value;

        emit Contribute(msg.sender, msg.value);

        if (totalContributions >= goal) {
            completed = true;
        }
    }

    function withdraw() public {
        require(completed, "Crowdfunding has not been completed.");
        require(msg.sender == owner, "Only the owner can withdraw the funds.");

        payable(msg.sender).transfer(totalContributions);
    }
}
