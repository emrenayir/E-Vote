// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Voting{
    struct Candidate{
        uint256 id;
        string name;
        uint256 numberOfVotes;
    }

    Candidate[] public candidates;

    address public owner;

    mapping(address => bool) public voters;

    address[]public listOfVoters;

    uint256 public votingStart;
    uint256 public votingEnd;

    bool public electionStarted;

    modifier onlyOwner(){
        require(
            msg.sender == owner,
            "You are not autherized to start an election"
            );
            _;
    }

    modifier electionOnGoing(){
        require(electionStarted, "no election yet");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function startElection(string[] memory _candidates, uint256 _votingDuration)public onlyOwner{
        require(electionStarted == false, "Election is currently ongoing");
        delete candidates;
        resetAllVoterStatus();

        for (uint256 i = 0; i < candidates.length; i++) {
            candidates.push(
                Candidate({id:i,name: _candidates[i],numberOfVotes: 0})
            );
        }
        electionStarted = true;
        votingStart = block.timestamp;
        votingEnd = block.timestamp + (_votingDuration *1 minutes );
    }

    function addCandidate(string memory _name)public onlyOwner electionOnGoing{
        require(checkElectionPeriod(),"Election period has ended");
        candidates.push(
            Candidate({id: candidates.length, name: _name, numberOfVotes: 0})
        );
    }

    function voterStatus( address _voter) public view electionOnGoing returns(bool){
        if (voters[_voter]== true) {
          return true;  
        } 
        return false;
    }

    function voteTo(uint256 _id)public electionOnGoing() {
        require(checkElectionPeriod(),"Election period has ended");
        require(!voterStatus(msg.sender),"You already voted.");
        candidates[_id].numberOfVotes++;
        voters[msg.sender] = true;
        listOfVoters.push(msg.sender);
    }

    function retrieveVotes() public view returns (Candidate[] memory){
        return candidates;
    }
    
    function electionTimer() public view electionOnGoing returns(uint256){
        if(block.timestamp >= votingEnd)
        {
            return 0;
        }
        return (votingEnd - block.timestamp );
    }

    function checkElectionPeriod() public returns (bool){
        if( electionTimer() > 0 ){
            return true;
        }
        electionStarted = false;
        return false;
    }
    function resetAllVoterStatus() public onlyOwner{
        for (uint256 i = 0; i < listOfVoters.length; i++) {
            voters[listOfVoters[i]] = false;
        }
        delete listOfVoters;
    }

}