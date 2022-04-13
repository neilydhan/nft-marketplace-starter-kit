// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC165.sol';
import './ERC165.sol';
import './interfaces/IERC721.sol';
import './Libraries/Counters.sol';


contract ERC721 is ERC165, IERC721 {

    using SafeMath for uint256;
    using Counters for Counters.Counter;

    // event Transfer(
    //     address indexed from, 
    //     address indexed to, 
    //     uint indexed tokenId);

    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId);

    // mapping in solidity creates a hash table of key pair values

    // Mapping from token id to the owner
    mapping(uint => address) private _tokenOwner;

    // Mapping from owner to number of owned tokens
    mapping(address => Counters.Counter) private _OwnedTokensCount;

    // Mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    

    constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^
                keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    }

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) public override view returns (uint256){
        require(_owner != address(0), 'ERC721: owner query for non-existent token');
        return _OwnedTokensCount[_owner].current();
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public override view returns (address){
        address _owner = _tokenOwner[_tokenId];
        require(_owner != address(0), 'ERC721: owner query for non-existent token');
        return _owner;
    }

    function _exists(uint tokenId) internal view returns(bool){
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint tokenId) internal virtual{
        //requires thea address isn't zero
        require(to != address(0), 'ERC721: minting to the zero address');
        //require the token doesn't exist
        require(!_exists(tokenId), 'ERC721: token already minted');

        _tokenOwner[tokenId] = to;
        _OwnedTokensCount[to].increment();

        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Transfer ownership of an NFT
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal{
        // 1. add the token id to the address receiving the token
        // 2. update the balance of the address from token
        // 3. update the balance of the address _to
        // 4. add the safe functionaliy:
        // a. require that the address receving a token is not a zero address
        // b. require the address transfering the token actually own the token

        require(_to != address(0), 'Error - ERC721 Transfer to the zero address');
        require(ownerOf(_tokenId) == _from, 'Error: Trying to transfer a token the address does not own the token');

        _OwnedTokensCount[_from].decrement();
        _OwnedTokensCount[_to].increment();

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override public {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    // require the person approving is the owner
    // approve an address to a token (tokenId)
    // require we can approve sending tokends of the owner to the owner (current caller)
    // update the map of the approval addresses
    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, 'Error - approval to current owner');
        require(msg.sender == owner, 'Current caller is not the owner of the token');
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool){
        require(_exists(tokenId), 'token does not exist');
        address owner = ownerOf(tokenId);
        return(spender == owner);

    }
}

