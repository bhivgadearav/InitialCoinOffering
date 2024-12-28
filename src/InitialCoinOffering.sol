// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import { IERC20 } from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

/**
 * @title InitialCoinOffering
 * @dev Manages an ICO with a dynamic pricing mechanism based on total bids
 * Gas optimizations:
 * 1. Used uint96 for amounts to pack struct
 * 2. Removed redundant storage variables
 * 3. Optimized event parameters
 * 4. Used immutable for constant values
 * 5. Cached storage variables in memory where beneficial
 */
contract InitialCoinOffering is Ownable {
    // Events optimized to include only essential indexed parameters
    event BidPlaced(address indexed bidder, uint96 amount);
    event BidIncreased(address indexed bidder, uint96 newTotal);
    
    // Struct packed into a single storage slot (20 bytes address + 12 bytes uint96 = 32 bytes)
    struct Bid {
        address bidder;   // Bidder's address (20 bytes)
        uint96 amount;    // Bid amount in ETH (12 bytes)
    }
    
    // Immutable variables that won't change after deployment
    address public immutable tokenAddress;
    address public immutable treasury;
    uint96 public immutable minBid;
    
    // State variables
    uint256 public tokensForSale;
    uint256 public startTime;
    uint256 public endTime;
    uint96 public totalETH;
    
    // Bidder tracking
    Bid[] public bids;
    mapping(address => uint256) public bidderToIndex;
    mapping(address => bool) public hasBid;
    
    /**
     * @dev Constructor sets immutable values
     * @param _treasury Address to receive ICO funds
     * @param _tokenAddress Token being sold in ICO
     */
    constructor(
        address _treasury,
        address _tokenAddress
    ) Ownable(msg.sender) {
        require(_treasury != address(0), "Treasury cannot be zero address");
        require(_tokenAddress != address(0), "Token cannot be zero address");
        treasury = _treasury;
        tokenAddress = _tokenAddress;
        minBid = 1 ether;
    }
    
    /**
     * @dev Starts the ICO with a 2-day duration
     * @notice Can only be called by contract owner
     */
    function startICO() external onlyOwner {
        require(startTime == 0, "ICO already started");
        startTime = block.timestamp;
        endTime = startTime + 2 days;
    }
    
    /**
     * @dev Allocates tokens for sale in the ICO
     * @param _amount Number of tokens to allocate
     */
    function allocateTokensForSale(uint256 _amount) external onlyOwner {
        require(_amount > 0, "Amount must be positive");
        require(startTime == 0, "ICO already started");
        
        IERC20 token = IERC20(tokenAddress);
        require(
            token.allowance(msg.sender, address(this)) >= _amount,
            "Insufficient allowance"
        );
        
        token.transferFrom(msg.sender, address(this), _amount);
        tokensForSale += _amount;
    }
    
    /**
     * @dev Places or increases a bid in the ICO
     */
    function placeBid() external payable {
        require(block.timestamp < endTime, "ICO ended");
        require(msg.value >= minBid, "Below minimum bid");
        require(msg.value <= type(uint96).max, "Bid too large");
        
        uint96 amount = uint96(msg.value);
        
        if (hasBid[msg.sender]) {
            uint256 index = bidderToIndex[msg.sender];
            Bid storage bid = bids[index];
            bid.amount += amount;
            totalETH += amount;
            emit BidIncreased(msg.sender, bid.amount);
        } else {
            bidderToIndex[msg.sender] = bids.length;
            hasBid[msg.sender] = true;
            bids.push(Bid(msg.sender, amount));
            totalETH += amount;
            emit BidPlaced(msg.sender, amount);
        }
    }
    
    /**
     * @dev Claims tokens based on bid proportion after ICO ends
     */
    function claimTokens() external {
        require(block.timestamp > endTime, "ICO not ended");
        require(hasBid[msg.sender], "No bid placed");
        
        uint256 index = bidderToIndex[msg.sender];
        Bid storage bid = bids[index];
        
        uint256 tokensWon = (uint256(bid.amount) * tokensForSale) / uint256(totalETH);
        
        // Reset bid to prevent double claims
        delete bids[index];
        delete bidderToIndex[msg.sender];
        delete hasBid[msg.sender];
        
        IERC20(tokenAddress).transfer(msg.sender, tokensWon);
    }
    
    /**
     * @dev Allows owner to claim accumulated ETH after ICO ends
     */
    function claimTreasury() external onlyOwner {
        require(block.timestamp > endTime, "ICO not ended");
        uint256 balance = address(this).balance;
        require(balance > 0, "Nothing to claim");
        
        payable(treasury).transfer(balance);
    }
    
    /**
     * @dev View functions for contract state
     */
    function getBid(address _user) external view returns(uint256) {
        require(hasBid[_user], "No bid placed");
        return bids[bidderToIndex[_user]].amount;
    }
    
    function getBidData() external view returns(uint256 totalBids, uint256 totalAmount) {
        return (bids.length, totalETH);
    }
}
