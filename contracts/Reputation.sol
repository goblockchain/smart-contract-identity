pragma solidity ^0.4.23;

import "./zeppelin/ownership/Ownable.sol";
contract Reputation is Ownable {

    /**
    * Profile by collaborators
    */
    enum TypeProfile{COLAB, AMBASSADOR, ESPECIALIST, ADVISOR}
    TypeProfile public retu;

    mapping (uint8 => Profile) mapProfile;

    /**
    * Range of reputation, ex:
    * 1 until 100 is a collaborator
    * 101 until 300 is a ambassador    
    */
    struct RangeReputation {
        uint64 start;
        uint64 end;
    }
    /**
    * Profile of collaborators
    */
    struct Profile {
        TypeProfile typeProfile;
        RangeReputation range;
        bool status;
    }

    /**
    * @dev addReputation. Add a reputation with the range, ex: Ambassador = 100, 200
    * @param _type is the type of profile
    * @param _start the number of start range 
    * @param _end the number of end range 
    */    
    function addReputation(TypeProfile _type, uint64 _start, uint64 _end) 
        public onlyOwner {
        require(! mapProfile[uint8(_type)].status, "Profile exists");
        RangeReputation memory range = RangeReputation(_start, _end);
        mapProfile[uint8(_type)] = Profile(_type, range, true);
    }

    /**
    * @dev removeReputation. Remove a reputation, change the status to false
    */    
    function removeReputation(TypeProfile _type) public onlyOwner {
        require(mapProfile[uint8(_type)].status, "Profile already cancelled");
        delete mapProfile[uint8(_type)];
    }
}

