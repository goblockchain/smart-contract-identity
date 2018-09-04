pragma solidity 0.4.24;

import "./TermsAndCondition.sol";
import "../util/StringUtils.sol";
//rinkeby 0xBBe5932a778698F2A8ea826B7A53F1435dBead08
contract PersonIdentity is TermsAndCondition {
    using StringUtils for string;
    enum Status {PENDING, APPROVE, REJECTED}
    Status status;
    mapping (bytes32=>Person) public mapPerson;
    mapping (address=>bytes32) public mapPersonAddress;
    Person[] public person;
    event PersonValidate(bool isValid, address validator);
    event RequestPerson(string idUport);

    struct Person {
        address sender;
        string hashUport;
        Status status;
        string hashTerms;
    }

    constructor() public {
        Person memory p = Person ({
            sender: msg.sender,
            hashUport: "",
            status: Status.APPROVE,
            hashTerms: "0x0"
        });

        person.push(p);
    }

    /**
    * @dev Request approve to participate of DAO
    * @param _uPort idPort
    * @param _hashTerms hash of terms    
    * @param _accepted true or false
    */   
    function requestApprove(string _uPort, string _hashTerms, bool _accepted) external {
        require(_accepted, "Necessary _accepted");
        require(_uPort.stringToBytes32() != 0x0, "Necessary _uPort");
        require(_hashTerms.stringToBytes32() != 0x0, "Necessary _hashTerms");
        require(mapPersonAddress[msg.sender] == 0x0, "Necessary  there isn't  user with the same address");
        bytes32 hashUportByte32 = _uPort.stringToBytes32();
        require(mapPerson[hashUportByte32].sender == 0x0, "Necessary there isn't  user with the same address uport");
        require(!hasRole(msg.sender, ROLE_COLLABORATOR), "Necessary there isn't Collaborator");

        Person memory p = Person ({
            sender: msg.sender,
            hashUport: _uPort,
            status: Status.PENDING,
            hashTerms: _hashTerms
        });
        person.push(p);
        mapPerson[hashUportByte32] = p;
        mapPersonAddress[msg.sender] = hashUportByte32;
        emit RequestPerson(_uPort);
    }

    /**
    * @dev Validate the request to participate of DAO
    * @param _uPort idPort
    * @param _approveOrDisapprove true or false
    */    
    function validate(string _uPort, bool _approveOrDisapprove) external onlyCollaborator(msg.sender) {
        require(_uPort.stringToBytes32() != 0x0);
        bytes32 hashUportByte32 = _uPort.stringToBytes32();
        require(mapPerson[hashUportByte32].sender != 0x0);
        require(mapPerson[hashUportByte32].sender != msg.sender);
        require(mapPerson[hashUportByte32].status == Status.PENDING);

        if (_approveOrDisapprove) {
            mapPerson[hashUportByte32].status = Status.APPROVE;
            addCollaborator(mapPerson[hashUportByte32].sender);
        } else {
            mapPerson[hashUportByte32].status = Status.REJECTED;
        }
        emit PersonValidate(_approveOrDisapprove, msg.sender);
    }

    /**
    * @dev Return the information about uport address
    * @param _uPort idPort
    * @return address
    * @return Status    
    */   
    function getPersonByIdUport(string _uPort) view public returns(address, Status) {
        require(_uPort.stringToBytes32() != 0x0);
        require(mapPerson[_uPort.stringToBytes32()].sender != 0x0);
        bytes32 nameAsBytes = _uPort.stringToBytes32();
        Person memory p = mapPerson[nameAsBytes];

        return (p.sender, p.status);
    }

    /**
    * @dev Return if the address is a collaborator
    * @return bool  
    */   
    function isCollaborator(address _addressColab) public view returns(bool) {
        return mapPersonAddress[_addressColab] != 0x0;
    }  

    /**
    * @dev Return the total of person
    * @return uint256  
    */
    function getTotalListPerson() public view returns(uint256) {
        return person.length;
    }  
}