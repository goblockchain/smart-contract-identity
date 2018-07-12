pragma solidity 0.4.24;

import "../Collaborator.sol/";

contract TermsAndCondition is Collaborator {
    string public hash;
    event TermsAndConditionChanged(address sender, uint256 time);

    function setTermsAndCondition(string _hash) public onlyAdminOrAdvisor {
        hash = _hash;
        emit TermsAndConditionChanged(msg.sender, now);
    }
    function getHash() public view returns(string) {
        return hash;
    }
}
