// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/InitialCoinOffering.sol";
import "../test/TestToken.sol"; 

/**
 * @title ICODeploymentScript
 * @dev Script for deploying and configuring the ICO contract and its associated test token
 * The script handles both test and production deployments with appropriate configurations
 */
contract ICODeploymentScript is Script {
    // Configuration constants
    uint256 constant INITIAL_TOKEN_SUPPLY = 1_000_000 ether; // 1 million tokens with 18 decimals
    uint256 constant ICO_ALLOCATION = 500_000 ether;         // 50% of tokens for ICO
    
    // Contract instances
    InitialCoinOffering public ico;
    TestToken public token;
    
    /**
     * @dev Main deployment function that runs the script
     * This function handles the complete deployment process including:
     * 1. Token deployment
     * 2. ICO contract deployment
     * 3. Token allocation and approval
     * Usage: forge script script/InitialCoinOffering.s.sol:ICODeploymentScript --rpc-url <your_rpc_url> --broadcast
     */
    function run() external {
        // Retrieve private key from environment
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy contracts based on environment
        if (block.chainid == 1) { // Mainnet deployment
            deployProduction();
        } else { // Test deployment
            deployTest();
        }
        
        // Setup initial configuration
        setupICO();
        
        vm.stopBroadcast();
        
        // Log deployment information
        logDeployment();
    }
    
    /**
     * @dev Handles production deployment with real token address
     * For mainnet deployments, use existing token contract
     */
    function deployProduction() internal {
        address tokenAddress = vm.envAddress("TOKEN_ADDRESS");
        address treasury = vm.envAddress("TREASURY_ADDRESS");
        
        // Deploy ICO contract with existing token
        ico = new InitialCoinOffering(
            treasury,
            tokenAddress
        );
    }
    
    /**
     * @dev Handles test deployment with test token
     * For test environments, deploys both token and ICO contract
     */
    function deployTest() internal {
        // Deploy test token
        token = new TestToken();
        
        // Use first test address as treasury for testing
        address treasury = address(0x1);
        
        // Deploy ICO contract with test token
        ico = new InitialCoinOffering(
            treasury,
            address(token)
        );
    }
    
    /**
     * @dev Configures the ICO contract after deployment
     * Handles token allocation and necessary approvals
     */
    function setupICO() internal {
        if (block.chainid != 1) { // Only for test environments
            // Approve ICO contract to transfer tokens
            token.approve(address(ico), ICO_ALLOCATION);
            
            // Allocate tokens for the ICO
            ico.allocateTokensForSale(ICO_ALLOCATION);
        }
    }
    
    /**
     * @dev Logs deployment information for verification
     * Outputs important addresses and configuration details
     */
    function logDeployment() internal view {
        console.log("Deployment Complete");
        console.log("------------------");
        console.log("ICO Contract:", address(ico));
        
        if (block.chainid != 1) {
            console.log("Test Token:", address(token));
            console.log("ICO Allocation:", ICO_ALLOCATION);
        }
        
        console.log("Chain ID:", block.chainid);
    }
}