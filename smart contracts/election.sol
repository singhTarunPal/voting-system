pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;


contract ElectionCreation {
    address[] public deployedBallots;
    function startelec (string[][] memory candidates,string[][] memory party, string[] memory district , uint hour) public {
        
        for(uint i =0;i<district.length;i++)
            {
            Ballots newBallot=new Ballots (candidates[i],party[i], district[i], msg.sender, hour);
            deployedBallots.push(address(newBallot));
            }
        }
    function getsDeployedBallots() public view returns( address[] memory)
    {return deployedBallots;}
}

contract Ballots 
{ 
	struct candidate
	{
		string name;
		string party;
		uint voteCount;
		uint creationDate;
		uint expirationDate;
	}

	candidate[] public candidates;
	address public manager;
	string public votingDistrict;
	mapping (address => bool) public voters;
	modifier restricted() 
	{
	require(msg.sender== manager);
	_;
	}
constructor (string[] memory candidateNames,string[] memory candidateParty, string memory district, address creator, uint amountofHours) public
{
manager = creator;
votingDistrict = district;
for(uint i=0; i< candidateNames.length;i++)
    {
    candidates.push(candidate(
    {   
        name: candidateNames[i],
        party: candidateParty[i],
        voteCount: 0,
        creationDate: now,
        expirationDate: now + amountofHours
    }));
    }
}
function vote(uint index) public
    {
    require(! voters[msg.sender]);
    candidates[index].voteCount +=1;
    voters[msg.sender] = true;
    }

function getCandidateName(uint index) public restricted view returns (string memory)
{
    require(now>candidates[index].expirationDate);
    return candidates[index].name;
}
function getCandidateParty(uint index) public restricted view returns (string memory)
{
    require(now>candidates[index].expirationDate);
    return candidates[index].party;
}

function getVoteCount(uint index)
public restricted view
returns(uint)
{
    return candidates[index].voteCount;
}

}
