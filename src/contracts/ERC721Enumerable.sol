// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';


contract ERC721Enumerable is IERC721Enumerable, ERC721 {

    uint256[] private _allTokens;

    // mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    // mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;

    // mapping from token ID to index of the owner tokens list
    mapping(uint256 =>uint256) private _ownedTokensIndex;

    constructor() {
        _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^
                keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));
    }

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() public override view returns (uint256){
        return _allTokens.length;
    }

    /// @notice Enumerate valid NFTs
    /// @dev Throws if `_index` >= `totalSupply()`.
    /// @param index A counter less than `totalSupply()`
    /// @return The token identifier for the `_index`th NFT,
    ///  (sort order not specified)
    function tokenByIndex(uint256 index) external override view returns (uint256){
        require(index < totalSupply(), 'global index is out of bounds!');
        return _allTokens[index];

    }

    /// @notice Enumerate NFTs assigned to an owner
    /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
    ///  `owner` is the zero address, representing invalid NFTs.
    /// @param owner An address where we are interested in NFTs owned by them
    /// @param index A counter less than `balanceOf(_owner)`
    /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
    ///   (sort order not specified)
    function tokenOfOwnerByIndex(address owner, uint256 index) external override view returns (uint256){
        require(index < balanceOf(owner), 'owner index is out of bounds!');
        return _ownedTokens[owner][index];

    }

    function _mint(address to, uint256 tokenId) internal override(ERC721){
        super._mint(to, tokenId);
        // 2 things! 1. add tokends to the owner
        // 2. all tokens to our totalsupply - to allTokens
        _addTokensToAllToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }
    //add tokens to the _alltokens array and set the position of the index
    function _addTokensToAllToAllTokenEnumeration(uint256 tokenId) private{
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private{
        // add address and token id to the _ownedTokens
        // ownedTokensIndex tokenId set to address of ownedTokens position
        // execute the function with minting
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);

    }
}