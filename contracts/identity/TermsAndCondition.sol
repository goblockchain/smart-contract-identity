pragma solidity 0.4.24;

import "../Collaborator.sol";

contract TermsAndCondition is Collaborator {
    string[] public hashTerms;
    string public validHash;
    event TermsAndConditionChanged(address sender, uint256 time, string validHash );

    /**
    * @dev Set the hash of terms and conditions;
    * @param _hash The new valid hash
    */
    function setTermsAndCondition(string _hash) public onlyAdmin {
        hashTerms.push(_hash);
        validHash = _hash;
        emit TermsAndConditionChanged(msg.sender, now, validHash);
    }


    /**
    * @dev Return the last hash
    * @return string
    */
    function getValidHash() public view returns(string) {
        return validHash;
    }
}
