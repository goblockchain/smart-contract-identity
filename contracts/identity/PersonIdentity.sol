pragma solidity 0.4.24;

import "../util/StringUtils.sol";
import "./TermsAndCondition.sol";

contract PersonIdentity is TermsAndCondition {
    using StringUtils for string;
    enum Status {PENDING, APPROVE, REJECTED}
    Status status;
    mapping (bytes32=>Person) public mapPerson;
    mapping (address=>bytes32) public mapPersonAddress;
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
        require(hashUport.stringToBytes32().length > 0);
        bytes32 hashUportByte32 = hashUport.stringToBytes32();
        require(mapPerson[hashUportByte32].sender == 0x0);
        require(accepted && bytes(_name).length > 0);
        require(isValidHash(_hashTerms));

        Person memory p = Person ({
            sender: msg.sender,
            name: _name,
            hashUport: hashUport,
            status: Status.PENDING,
            hashTerms: _hashTerms
        });
        person.push(p);
        mapPerson[hashUportByte32] = p;
        mapPersonAddress[msg.sender] = hashUportByte32;
    }
    
    function validate(string hashUport, bool approveOrDisapprove) external onlyCollaborator(msg.sender) {
        require(hashUport.stringToBytes32().length > 0);
        bytes32 hashUportByte32 = hashUport.stringToBytes32();
        require(mapPerson[hashUportByte32].sender != msg.sender);
        if (approveOrDisapprove) {
            mapPerson[hashUportByte32].status = Status.APPROVE;
            addCollaborator(mapPerson[hashUportByte32].sender);
        } else {
            mapPerson[hashUportByte32].status = Status.REJECTED;
        }
        emit PersonValidate(approveOrDisapprove, msg.sender);
    }
}