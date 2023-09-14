// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract IbukunToken is ERC20, Ownable, Pausable {
    using SafeMath for uint256;

    uint256 public constant maxSupply = 2000 * 10**18; // Total supply is 2000 tokens

    mapping(address => uint256) public whitelist;

    event TokensMinted(address indexed user, uint256 amount);
    event Whitelisted(address indexed user, uint256 amount);
    event RemovedFromWhitelist(address indexed user);

    constructor() ERC20("Ibukun Token", "IBK") {
        _mint(msg.sender, maxSupply);
    }

    function mintTokens(uint256 _amount) external payable whenNotPaused {
        require(whitelist[msg.sender] > 0, "You are not whitelisted for token minting");
        uint256 _calculatedAmount = _amount.mul(1 ether); // Calculate amount in Wei
        require(msg.value >= _calculatedAmount, "Not enough ether to mint the requested Ibukun Tokens");
        uint256 amountInWei = _amount.mul(10**18);
        require(totalSupply().add(amountInWei) <= maxSupply, "Not enough tokens left for sale");
        _mint(msg.sender, amountInWei);
        emit TokensMinted(msg.sender, amountInWei);
    }

    function addToWhitelist(address _address, uint256 _amount) external onlyOwner {
        whitelist[_address] = _amount;
        emit Whitelisted(_address, _amount);
    }

    function removeFromWhitelist(address _address) external onlyOwner {
        delete whitelist[_address];
        emit RemovedFromWhitelist(_address);
    }

    function isWhitelisted(address _address) external view returns (bool) {
        return whitelist[_address] > 0;
    }

    function withdrawEther() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function withdrawTokens(address tokenAddress) external onlyOwner {
        ERC20 token = ERC20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        token.transfer(owner(), balance);
    }

    // Fallback function to reject incoming Ether
    receive() external payable {
        revert("This contract does not accept Ether.");
    }
}
