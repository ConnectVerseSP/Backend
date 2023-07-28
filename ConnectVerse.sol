// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";



contract connectverse is ERC721, ERC721URIStorage, Ownable{

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    
    uint256 public numberOfCourses;
    mapping(uint256=>uint256) public numberOfModules;
    mapping(uint256=>string) public getCourseById;
    mapping(address=>mapping(uint256=>mapping(uint256=>bool))) public modulesCompleted;
    mapping(uint256=>string) public certificate;
    mapping(address=>bool) public isRegistered;

    constructor() ERC721("ConnectVerse", "CV")
    {
     
        numberOfCourses=0;

    }
    function safeMint(address to, string memory uri) public {

        require(isRegistered[msg.sender]==true,"User not Registered");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function register() public
    {
        isRegistered[msg.sender]=true;
    }
    function addCourse(string calldata name,uint256 modules) public onlyOwner
    {
        
        numberOfCourses=numberOfCourses+1;
        getCourseById[numberOfCourses-1]=name;
        numberOfModules[numberOfCourses-1]=modules;

    }

    function addModules(uint256 id,uint256 modules) public onlyOwner
    {
        require(id<numberOfCourses,"course not found");
         numberOfModules[id]=numberOfModules[id]+modules;

    }

    function createCertificate(uint256 id, string calldata uri) public onlyOwner
    {
       require(id<numberOfCourses,"course not found");
       certificate[id]=uri;
    }

    function completeModule(uint256 id, uint256 module) public {

        require(id<numberOfCourses,"course not found");
        modulesCompleted[msg.sender][id][module]=true;
    }

    function claimCertificate(uint256 courseId,address recipient) public
    {
        require(courseId<numberOfCourses,"course not found");
       for (uint256 i = 0; i < numberOfModules[courseId]; i++) {
        require(modulesCompleted[msg.sender][courseId][i], "Course not completed");
        }
        safeMint(recipient, certificate[courseId]);
    
        
    }

    



}
