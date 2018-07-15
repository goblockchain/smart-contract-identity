pragma solidity 0.4.24;

import "../Collaborator.sol/";
import "../util/StringUtils.sol";

contract TermsAndCondition is Collaborator {
    using StringUtils for string;
    string[] public hashTerms;
    string public validHash;
    event TermsAndConditionChanged(address sender, uint256 time, string validHash );

    function setTermsAndCondition(string _hash) public onlyAdminOrAdvisor {
        hashTerms.push(_hash);
        validHash = _hash;
        emit TermsAndConditionChanged(msg.sender, now, validHash);
    }

    function isValidHash(string _hash) public returns(bool) {
        return validHash.equal(_hash);
    }    
}
