pragma solidity 0.4.24;

import "../util/StringUtils.sol";
import "./TermsAndCondition.sol";

contract PersonIdentity is TermsAndCondition {
    using StringUtils for string;
    enum Status {PENDING, APPROVE, REJECTED}
    Status status;
    mapping (address=>Person) public mapPerson;
    Person[] public person;
    event PersonValidate(bool isValid, address validator);

    struct Person {
        address sender;
        string name;
        bytes32 profileLinkedin;
        bytes32 hashUport;
        Status status;
        string hashTerms;
    }

    function requestApprove(string _name, string _hashTerms, bool accepted, string         _profileLinkedin) external {
        require(mapPerson[msg.sender].sender == 0x0);
        require(accepted && bytes(_name).length > 0);
        require(isValidHash(_hashTerms));

        Person memory p = Person ({
            sender: msg.sender,
            name: _name,
            profileLinkedin: _profileLinkedin.stringToBytes32(),
            hashUport: "",
            status: Status.PENDING,
            hashTerms: _hashTerms
        });
        person.push(p);
        mapPerson[msg.sender] = p;
    }
    
    function validate(address _addressToApprove, bool approveOrDisapprove) external onlyCollaborator(msg.sender) {
        require(mapPerson[msg.sender].sender == _addressToApprove);
        if (approveOrDisapprove) {
            mapPerson[_addressToApprove].status = Status.APPROVE;
            addCollaborator(_addressToApprove);
        } else {
            mapPerson[_addressToApprove].status = Status.REJECTED;
        }
        emit PersonValidate(approveOrDisapprove, msg.sender);
    }
}