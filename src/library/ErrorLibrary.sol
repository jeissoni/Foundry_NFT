// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;
library  Error {
    
    error NftLimitPerDirection(address user, uint256 available, uint256 required); 
   
    error TokenDoesNotExist(address user, uint256 tokenId);

    error MintNotStarted(address user);

    error NftSoldOut(address user);

}