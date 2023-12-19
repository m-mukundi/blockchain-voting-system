pragma solidity 0.8.23;

contract Election {
    struct Candidate {
        address id;
        uint voteCount;
        string candidateName;
    }

    event Voted(address indexed voter, address indexed candidate);

    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;

    address public elecadmin;
    
    uint public candidateCount;
    uint256 public startTime;
    uint256 public stopTime;

    constructor() {
        elecadmin = msg.sender;
    }

    modifier elecAdminOnly() {
        require(msg.sender == elecadmin, "Election admin only operation");
        _;
    }

    function setStop(uint256 num) external elecAdminOnly {
        require(num > block.timestamp && num > startTime, "Stop at later time");
        stopTime = num;
    }

    function setStart(uint256 num) external elecAdminOnly {
        require(num > block.timestamp, "Start at earlier time");
        startTime = num;
    }

    function vote(uint _candidateId) public {
        require(block.timestamp > startTime, "Election not started");
        require(block.timestamp < stopTime, "Election over");
        require(voters[msg.sender] == false, "Already voted");

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        emit Voted(msg.sender, candidates[_candidateId].id);
    }

    function getResults() public view returns (address, uint, string memory) {
        require(block.timestamp >= stopTime, "Election yet to finish");
        uint256 c = 0;
        uint256 max = 0;
        for (uint i = 1; i <= candidateCount; i++) {
            if (candidates[i].voteCount > max) {
                max = candidates[i].voteCount;
                c = i;
            }
        }
        return (
            candidates[c].id,
            candidates[c].voteCount,
            candidates[c].candidateName
        );
    }
}
