// SPDX-License-Identifier: MIT

pragma solidity 0.8.28; // solidity version

contract DigitalLibrary {

    enum EBookStatus { Active, Outdated, Archived }

    struct EBook {
        string title;
        string author;
        uint256 publicationDate;
        uint256 expirationDate;
        EBookStatus status;
        address primaryLibrarian;
        address[] authorizedLibrarians;
        uint256 readCount;
    }

    mapping(string => EBook) public eBooks;

    modifier onlyPrimaryLibrarian(string memory _title) {
        require(msg.sender == eBooks[_title].primaryLibrarian, "Only primary librarian can perform this action.");
        _;
    }

    modifier onlyAuthorizedLibrarian(string memory _title) {
        bool isAuthorized = false;
        for (uint i = 0; i < eBooks[_title].authorizedLibrarians.length; i++) {
            if (eBooks[_title].authorizedLibrarians[i] == msg.sender) {
                isAuthorized = true;
                break;
            }
        }
        require(isAuthorized, "You are not an authorized librarian.");
        _;
    }

    function ExpirationDateManagement(uint256 _NewExpirationDate, string memory _title) external onlyPrimaryLibrarian(_title) {
        require(_NewExpirationDate > eBooks[_title].expirationDate, "Expiry date should be later than current expiration date.");
        eBooks[_title].expirationDate = _NewExpirationDate;
    }

    function CreateEBook(string memory _title, string memory _author, uint256 publicationDat) public {
        require(eBooks[_title].publicationDate == 0, "EBook already exists.");

        uint256 expirationDate = block.timestamp + 180 days;
    
        eBooks[_title] = EBook({
            title: _title,
            author: _author,
            publicationDate: publicationDat,
            expirationDate: expirationDate, 
            status: EBookStatus.Active,
            primaryLibrarian: msg.sender,
            authorizedLibrarians: new address[](0), 
            readCount: 0
        });
    }

    function AddLibrarian(address _authorizedLibrarians, string memory _title) external onlyPrimaryLibrarian(_title){

        eBooks[_title].authorizedLibrarians.push(_authorizedLibrarians);

    }

    function ExtendExpirationDate(string memory _title, uint256 _newExpirationDate ) external onlyAuthorizedLibrarian(_title){

        eBooks[_title].expirationDate = _newExpirationDate;


    }

   function stringToStatus(string memory _status) internal pure returns (EBookStatus) {
        if (keccak256(bytes(_status)) == keccak256(bytes("Active"))) {
            return EBookStatus.Active;
        } else if (keccak256(bytes(_status)) == keccak256(bytes("Outdated"))) {
            return EBookStatus.Outdated;
        } else if (keccak256(bytes(_status)) == keccak256(bytes("Archived"))) {
            return EBookStatus.Archived;
        } else {
            revert("Invalid status");
        }
    }

    
    function ChangeStatus(string calldata _status, string memory _title) external onlyAuthorizedLibrarian(_title) {
        EBookStatus newStatus = stringToStatus(_status); 
        eBooks[_title].status = newStatus; 
    }

    function CheckExpiration(string memory _title) external returns (bool){

        eBooks[_title].readCount += 1;

        bool Outdated = block.timestamp > eBooks[_title].expirationDate;

        if(Outdated){
            eBooks[_title].status = EBookStatus.Outdated;
        }

        return Outdated;


    }
    
    


}
