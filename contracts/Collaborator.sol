pragma solidity ^0.4.23;

import "./zeppelin/ownership/rbac/RBAC.sol";

contract Collaborator is RBAC {
    
    /**
    * A constant role name for indicating admins.
    */
    string public constant ROLE_ADMIN = "admin";
    string public constant ROLE_COLLABORATOR = "collaborator";

    event NewCollaborator(address collaborator);

    /**
    * @dev constructor. Sets msg.sender as admin by default
    */
    constructor() public {
        addRole(msg.sender, ROLE_ADMIN);
        addRole(msg.sender, ROLE_COLLABORATOR);
    }

    /**
    * @dev modifier to scope access to admins
    * // require
    */
    modifier onlyAdmin() {
        require(hasRole(msg.sender, ROLE_ADMIN), "Necessary only ROLE_ADMIN");
        _;
    }

    modifier onlyCollaborator(address _addressUser) {
        require(hasRole(_addressUser, ROLE_COLLABORATOR), "Necessary only ROLE_COLLABORATOR");
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
    * @dev remove a role from an address
    * @param addr address
    * @param roleName the name of the role
    */
    function adminRemoveRole(address addr, string roleName) onlyAdmin
        public {
        removeRole(addr, roleName);
    }

    /**
    * @dev Allows the current superuser to transfer his role to a newSuperuser.
    * @param _newSuperuser The address to transfer ownership to.
    */
    function transferAdmin(address _newSuperuser) onlyAdmin onlyCollaborator(_newSuperuser) public {
        require(_newSuperuser != address(0));
        removeRole(msg.sender, ROLE_ADMIN);
        addRole(_newSuperuser, ROLE_ADMIN);
    }
}

