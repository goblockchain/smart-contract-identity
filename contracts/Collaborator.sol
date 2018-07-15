pragma solidity ^0.4.23;

import "./zeppelin/ownership/Ownable.sol";
import "./zeppelin/ownership/rbac/RBAC.sol";

contract Collaborator is Ownable, RBAC {
    
    /**
    * A constant role name for indicating admins.
    */
    string public constant ROLE_ADMIN = "admin";
    string public constant ROLE_ADVISOR = "advisor";
    string public constant ROLE_ESPECIALIST = "especialist";
    string public constant ROLE_AMBASSADOR = "ambassador";
    string public constant ROLE_COLLABORATOR = "collaborator";

    event NewCollaborator(address collaborator);

    /**
    * @dev constructor. Sets msg.sender as admin by default
    */
    constructor() public
    {
        addRole(msg.sender, ROLE_ADMIN);
        addRole(msg.sender, ROLE_ADVISOR);     
    }

    /**
    * @dev modifier to scope access to admins
    * // reverts
    */
    modifier onlyAdmin()
    {
        checkRole(msg.sender, ROLE_ADMIN);
        _;
    }

    modifier onlyAdminOrAdvisor()
    {
        require(
            hasRole(msg.sender, ROLE_ADMIN) ||
            hasRole(msg.sender, ROLE_ADVISOR)
        );
        _;
    }

    modifier onlyAdminEspecialistOrAdvisor()
    {
        require(
            hasRole(msg.sender, ROLE_ADMIN) ||
            hasRole(msg.sender, ROLE_ADVISOR) ||
            hasRole(msg.sender, ROLE_ESPECIALIST)
        );
        _;
    }

    modifier onlyCollaborator(address _addressUser)
    {
        require(isCollaborator(_addressUser));
        _;
    }    

    /**
    * @dev add a collaborator
    **/
    function addCollaborator(address collaborator) internal {
        addRole(collaborator, ROLE_COLLABORATOR);
        emit NewCollaborator(collaborator);
    }  

    /**
    * @dev addAdvisors. add address of advisors
    * @param _advisors array with the address of advisors
    */
    function addAdvisors(address[] _advisors) public onlyAdminOrAdvisor
    {
        for (uint256 i = 0; i < _advisors.length; i++) {
            addRole(_advisors[i], ROLE_ADVISOR);
        }        
    }

    /**
    * @dev remove a role from an address
    * @param addr address
    * @param roleName the name of the role
    */
    function adminRemoveRole(address addr, string roleName) onlyAdminOrAdvisor
        public
    {
        removeRole(addr, roleName);
    }

    // admins can remove advisor's role
    function removeAdvisor(address _addr) onlyAdmin  public {
        // revert if the user isn't an advisor
        //  (perhaps you want to soft-fail here instead?)
        checkRole(_addr, ROLE_ADVISOR);
        // remove the advisor's role
        removeRole(_addr, ROLE_ADVISOR);
    }

    /**
    * @dev Allows the current superuser to transfer his role to a newSuperuser.
    * @param _newSuperuser The address to transfer ownership to.
    */
    function transferAdmin(address _newSuperuser) onlyAdmin public
    {
        require(_newSuperuser != address(0));
        removeRole(msg.sender, ROLE_ADMIN);
        addRole(_newSuperuser, ROLE_ADMIN);
    }

    /**
    * @dev verify if the current address is a collaborator;
    * @param addressUser The address to verify
    * @return isCollaborator return true if the address is a collaborator
    */
    function isCollaborator(address _addressUser) public returns(bool _isCollaborator)
    {
        return (
            hasRole(_addressUser, ROLE_ADMIN) ||
            hasRole(_addressUser, ROLE_ADVISOR) ||
            hasRole(_addressUser, ROLE_ESPECIALIST) ||
            hasRole(_addressUser, ROLE_AMBASSADOR) || 
            hasRole(_addressUser, ROLE_COLLABORATOR)            
        );
    }

}

