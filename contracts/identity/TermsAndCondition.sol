pragma solidity 0.4.24;

import "../Collaborator.sol/";
import "../util/StringUtils.sol";

contract TermsAndCondition is Collaborator {
    using StringUtils for string;
    string[] public hashTerms;
    string public validHash;
    event TermsAndConditionChanged(address sender, uint256 time, string validHash );

    /**
    * @dev Set the hash of terms and conditions;
    * @param _hash The new valid hash
    */
    function setTermsAndCondition(string _hash) public onlyAdminOrAdvisor {
        hashTerms.push(_hash);
        validHash = _hash;
        emit TermsAndConditionChanged(msg.sender, now, validHash);
    }

    /**
    * @dev verify if current hash is valid with the parameter;
    * @param _hash The hash sent by collaborator
    * @return bool return true if the valid hash
    */
    function isValidHash(string _hash) public view returns(bool) {
        return validHash.equal(_hash);
    }    
}
