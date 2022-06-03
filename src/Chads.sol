// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


import "solmate/tokens/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/utils/Counters.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import {Error} from "../src/library/ErrorLibrary.sol";
contract Chads is ERC721, Ownable {
    
    using Counters for Counters.Counter;

    /// ===========================================
    /// ============ Immutable storage ============

    uint256 private immutable AVAILABLE_SUPPLY;

    /// ===========================================
    /// ============ Mutable storage ==============  

    string public baseURI;   
    bool private revelate;  

    Counters.Counter private tokenIdCounter;   

    uint256 public limitNftByAddress;
    bool public startSale;
    
    /// ======================================================
    /// ============ Constructor =============================
    constructor() ERC721("Chad", "CHADS") {
        AVAILABLE_SUPPLY = 3000;  
        limitNftByAddress = 100;     
        startSale = true;     
        revelate = true;
        baseURI = "ipfs://QmePmaT4Bkeecdv2GrMbp8VWQc5YUcFzptDhgxp6r6WX6M/";
        tokenIdCounter.increment();   
    }

    /// ========================================================
    /// ============= Event ====================================
    event MintChadHeads(address indexed user, uint256 tokenId); 

    event SetStartSale(address indexed owner, uint256 date);
   
    /// =========================================================
    /// ============ Functions ==================================
   
    //******************************************************* */
    //********** functions reed only  *********************** */  
    function getCurrentTokenId() external view returns (uint256) {
        return tokenIdCounter.current();
    }        
    function getAvailableSupply() external view returns (uint256) {
        return AVAILABLE_SUPPLY;
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return ownerOf[tokenId] != address(0);
    }

  

    //****************************************************** */
    // ************* functions set parameter *************** */ 
    function setStartSale(bool _value) external onlyOwner {
        startSale = _value;
        emit SetStartSale(msg.sender, block.timestamp);
    }

    //****************************************************** */
    //******************funcition URI ********************** */
    function setBaseURI(string memory _setBaseUri) external onlyOwner {
        baseURI = _setBaseUri;
    }
    function setRevelate(bool _value) external onlyOwner{
        revelate = _value;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {   
        if (!_exists(tokenId)){
            revert Error.TokenDoesNotExist(msg.sender, tokenId);
        }
        if(!revelate){
            return baseURI;
        }
        return string(abi.encodePacked(baseURI, Strings.toString(tokenId), ".json"));
    }
      
  
    //************************************************* */
    //************** mint function********************* */   
    function mintChadHeads(uint256 _amountNft) external {

        if(!startSale){
            revert Error.MintNotStarted(msg.sender);
        }        

        if(_amountNft > (limitNftByAddress - balanceOf[msg.sender] )){
            revert Error.NftLimitPerDirection(
                msg.sender,
                balanceOf[msg.sender],
                limitNftByAddress);
        }              

        for(uint i; i < _amountNft ; i++){

            if(tokenIdCounter.current() > AVAILABLE_SUPPLY){
                revert Error.NftSoldOut(msg.sender);
            }   

            _safeMint(msg.sender, tokenIdCounter.current());   

            tokenIdCounter.increment();

            emit MintChadHeads(msg.sender, tokenIdCounter.current() - 1);
        }          
   
    }
    
}
