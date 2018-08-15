pragma solidity 0.4.24;

import "../util/StringUtils.sol";
import "./TermsAndCondition.sol";

contract PersonIdentity is TermsAndCondition {
    // using StringUtils for string;
    enum Status {PENDING, APPROVE, REJECTED}
    Status status;
    mapping (string=>Person) public mapPerson;
    mapping (address=>string) public mapPersonAddress;
    Person[] public person;
    event PersonValidate(bool isValid, address validator);

    struct Person {
        address sender;
        string name;
        string hashUport;
        Status status;
        string hashTerms;
    }

    function requestApprove(string _name, string hashUport, string _hashTerms, bool accepted) external {
        require(mapPerson[hashUport].sender == 0x0);
        require(accepted && bytes(_name).length > 0);
        require(isValidHash(_hashTerms));

        Person memory p = Person ({
            sender: msg.sender,
            name: _name,
            hashUport: "",
            status: Status.PENDING,
            hashTerms: _hashTerms
        });
        person.push(p);
        mapPerson[hashUport] = p;
        mapPersonAddress[msg.sender] = hashUport;
    }
    
    function validate(string hashUport, bool approveOrDisapprove) external onlyCollaborator(msg.sender) {
        require(mapPerson[hashUport].sender != msg.sender);
        if (approveOrDisapprove) {
            mapPerson[hashUport].status = Status.APPROVE;
            addCollaborator(mapPerson[hashUport].sender);
        } else {
            mapPerson[hashUport].status = Status.REJECTED;
        }
        emit PersonValidate(approveOrDisapprove, msg.sender);
    }
}