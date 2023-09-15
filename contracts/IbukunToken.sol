// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title IbukunToken
 * @dev This contract represents the Ibukun Token (IBK).
 */
contract IbukunToken is ERC20, Ownable, Pausable {
    using SafeMath for uint256;

    uint256 public constant tokenPrice = 0.000001 ether;
    uint256 public constant maxSupply = 10000 * 10**18; // Total supply is 10000 tokens

    // Whitelist of addresses allowed to mint tokens
    mapping(address => uint256) public whitelist;

    // Events
    event TokensMinted(address indexed user, uint256 amount);
    event Whitelisted(address indexed user, uint256 amount);
    event RemovedFromWhitelist(address indexed user);

    /**
     * @dev Constructor function to initialize the Ibukun Token.
     * It mints the maximum supply and assigns it to the contract owner.
     */
    constructor() ERC20("Ibukun Token", "IBK") {
        _mint(msg.sender, 50 * 10**18);
    }

    /**
     * @dev Mint tokens to the caller based on their whitelist status.
     * @param _amount The amount of tokens to mint.
     */
    function mintTokens(uint256 _amount) external payable whenNotPaused{
        ///require(whitelist[msg.sender] > 0, "You are not whitelisted for token minting");
        uint256 _calculatedAmount = _amount.mul(tokenPrice); // Calculate amount in Wei
        require(msg.value >= _calculatedAmount, "Not enough ether to mint the requested Ibukun Tokens");
        uint256 amountInWei = _amount.mul(10**18);
        require(totalSupply().add(amountInWei) <= maxSupply, "Not enough tokens left to be minted");
        _mint(msg.sender, amountInWei);
        emit TokensMinted(msg.sender, amountInWei);
    }

    /**
     * @dev Add an address to the whitelist with a specified minting amount.
     * @param _address The address to be added to the whitelist.
     * @param _amount The minting amount allowed for the address.
     */
    function addToWhitelist(address _address, uint256 _amount) external onlyOwner {
        whitelist[_address] = _amount;
        emit Whitelisted(_address, _amount);
    }

    /**
     * @dev Remove an address from the whitelist.
     * @param _address The address to be removed from the whitelist.
     */
    function removeFromWhitelist(address _address) external onlyOwner {
        delete whitelist[_address];
        emit RemovedFromWhitelist(_address);
    }

    /**
     * @dev Check if an address is whitelisted for token minting.
     * @param _address The address to check.
     * @return A boolean indicating whether the address is whitelisted.
     */
    function isWhitelisted(address _address) external view returns (bool) {
        return whitelist[_address] > 0;
    }

    /**
     * @dev Withdraw the contract's Ether balance to the owner's address.
     */
    function withdrawEther() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    /**
     * @dev Withdraw any ERC20 tokens held by the contract to the owner's address.
     * @param tokenAddress The address of the ERC20 token to be withdrawn.
     */
    function withdrawTokens(address tokenAddress) external onlyOwner {
        ERC20 token = ERC20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        token.transfer(owner(), balance);
    }

    /**
     * @dev Fallback function to reject incoming Ether.
     */
    receive() external payable {
        revert("This contract does not accept Ether.");
    }
}
