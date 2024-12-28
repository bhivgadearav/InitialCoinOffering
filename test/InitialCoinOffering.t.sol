pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/InitialCoinOffering.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20 {
    constructor() ERC20("Test Token", "TEST") {
        _mint(msg.sender, 1000000 * 10**18);
    }
}

contract InitialCoinOfferingTest is Test {
    InitialCoinOffering public ico;
    TestToken public token;
    address public treasury;
    address public owner;
    address public bidder1;
    address public bidder2;
    
    function setUp() public {
        // Setup accounts
        owner = address(this);
        treasury = address(0x123);
        bidder1 = address(0x456);
        bidder2 = address(0x789);
        
        // Deploy contracts
        token = new TestToken();
        ico = new InitialCoinOffering(treasury, address(token));
        
        // Fund test accounts
        vm.deal(bidder1, 100 ether);
        vm.deal(bidder2, 100 ether);
        
        // Approve tokens for ICO
        token.approve(address(ico), 1000000 * 10**18);
    }
    
    function testInitialState() public {
        assertEq(ico.treasury(), treasury);
        assertEq(ico.tokenAddress(), address(token));
        assertEq(ico.tokensForSale(), 0);
        assertEq(ico.startTime(), 0);
        assertEq(ico.endTime(), 0);
    }
    
    function testAllocateTokens() public {
        uint256 amount = 1000000 * 10**18;
        ico.allocateTokensForSale(amount);
        assertEq(ico.tokensForSale(), amount);
    }
    
    function testStartICO() public {
        ico.startICO();
        assert(ico.startTime() > 0);
        assertEq(ico.endTime(), ico.startTime() + 2 days);
    }
    
    function testPlaceBid() public {
        ico.startICO();
        
        vm.prank(bidder1);
        ico.placeBid{value: 2 ether}();
        
        (uint256 totalBids, uint256 totalAmount) = ico.getBidData();
        assertEq(totalBids, 1);
        assertEq(totalAmount, 2 ether);
    }
    
    function testIncreaseBid() public {
        ico.startICO();
        
        vm.startPrank(bidder1);
        ico.placeBid{value: 2 ether}();
        ico.placeBid{value: 1 ether}();
        vm.stopPrank();
        
        assertEq(ico.getBid(bidder1), 3 ether);
    }
    
    function testClaimTokens() public {
        // Setup ICO
        uint256 tokensForSale = 1000000 * 10**18;
        ico.allocateTokensForSale(tokensForSale);
        ico.startICO();
        
        // Place bids
        vm.prank(bidder1);
        ico.placeBid{value: 2 ether}();
        
        vm.prank(bidder2);
        ico.placeBid{value: 3 ether}();
        
        // Fast forward to end
        vm.warp(block.timestamp + 3 days);
        
        // Claim tokens
        vm.prank(bidder1);
        ico.claimTokens();
        
        // Bidder1 should get 40% of tokens (2 ETH out of 5 ETH total)
        assertEq(token.balanceOf(bidder1), (tokensForSale * 2) / 5);
    }
    
    function testClaimTreasury() public {
        ico.startICO();
        
        // Place bids
        vm.prank(bidder1);
        ico.placeBid{value: 2 ether}();
        
        vm.prank(bidder2);
        ico.placeBid{value: 3 ether}();
        
        // Fast forward to end
        vm.warp(block.timestamp + 3 days);
        
        uint256 initialBalance = treasury.balance;
        ico.claimTreasury();
        assertEq(treasury.balance - initialBalance, 5 ether);
    }
    
    function testFailBidAfterEnd() public {
        ico.startICO();
        vm.warp(block.timestamp + 3 days);
        
        vm.prank(bidder1);
        ico.placeBid{value: 2 ether}();
    }
    
    function testFailBidBelowMinimum() public {
        ico.startICO();
        
        vm.prank(bidder1);
        ico.placeBid{value: 0.5 ether}();
    }
}