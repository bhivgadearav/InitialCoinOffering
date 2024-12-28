# Initial Coin Offering (ICO) Smart Contract

A gas-optimized, secure smart contract implementation for managing Initial Coin Offerings on the Ethereum blockchain. This contract enables fair token distribution based on proportional bidding mechanisms.

## Features

The ICO contract provides a comprehensive solution for token sales with the following features:

- Proportional token distribution based on bid amounts
- Gas-optimized storage and execution
- Two-day fixed duration ICO periods
- Minimum bid requirements
- Secure token and ETH claiming mechanisms
- Comprehensive testing suite
- Owner-controlled start time and token allocation

## Technical Architecture

The contract uses several gas optimization techniques while maintaining security:

- Struct packing for efficient storage
- Strategic use of immutable variables
- Optimized event emissions
- Storage slot management
- Memory caching for repeated operations

## Prerequisites

To work with this project, you'll need:

- [Foundry](https://github.com/foundry-rs/foundry) - Installation instructions can be found in their documentation
- [Solidity](https://docs.soliditylang.org/) ^0.8.0
- [Git](https://git-scm.com/)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/ico-contract.git
cd ico-contract
```

2. Install dependencies:
```bash
forge install
```

3. Build the project:
```bash
forge build
```

4. Run tests:
```bash
forge test
```

## Usage

### Contract Deployment

1. Deploy the contract with treasury and token addresses:
```solidity
constructor(address _treasury, address _tokenAddress)
```

2. Allocate tokens for the ICO:
```solidity
function allocateTokensForSale(uint256 _amount) external onlyOwner
```

3. Start the ICO:
```solidity
function startICO() external onlyOwner
```

### Participating in the ICO

1. Place a bid:
```solidity
function placeBid() external payable
```

2. Claim tokens after ICO ends:
```solidity
function claimTokens() external
```

## Testing

The project includes a comprehensive test suite covering all major functionality:

```bash
# Run all tests
forge test

# Run tests with gas reporting
forge test --gas-report

# Run specific test
forge test --match-test testPlaceBid
```

## Security Considerations

- The contract implements checks for reentrancy and overflow protection
- Bidding and claiming mechanisms are protected against manipulation
- Treasury withdrawal is restricted to owner access
- Token transfers are validated and secured

## Gas Optimization

The contract implements several gas optimization strategies:

1. Storage Packing
   - Bid struct uses uint96 for amounts to pack with address
   - Strategic use of immutable variables

2. Computation Optimization
   - Efficient memory usage
   - Optimized loop operations
   - Storage cleanup for gas refunds

## Contributing

Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## Support

For support and questions, please open an issue in the GitHub repository.