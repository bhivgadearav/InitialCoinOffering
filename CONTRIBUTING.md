# Contributing to ICO Smart Contract

Thank you for your interest in contributing to the ICO Smart Contract project! We welcome contributions from the community and have provided this guide to help you get started.

## Code of Conduct

This project and everyone participating in it are governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to project maintainers.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When creating a bug report, include as many details as possible:

- Use a clear and descriptive title
- Describe the exact steps to reproduce the problem
- Provide specific examples to demonstrate the steps
- Describe the behavior you observed after following the steps
- Explain which behavior you expected to see instead and why
- Include any relevant transaction hashes or contract addresses

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- Use a clear and descriptive title
- Provide a step-by-step description of the suggested enhancement
- Provide specific examples to demonstrate the steps
- Describe the current behavior and explain which behavior you expected to see instead
- Explain why this enhancement would be useful

### Pull Requests

1. Fork the repository
2. Create a new branch for your feature or bug fix
3. Write tests for your changes
4. Ensure all tests pass with `forge test`
5. Commit your changes
6. Push to your fork
7. Open a Pull Request

#### Development Process

1. **Setting up development environment**
   ```bash
   git clone https://github.com/yourusername/ico-contract.git
   cd ico-contract
   forge install
   ```

2. **Making changes**
   - Follow the existing code style
   - Add comments to explain complex logic
   - Update tests as needed
   - Update documentation if required

3. **Testing**
   ```bash
   # Run all tests
   forge test
   
   # Run with gas reporting
   forge test --gas-report
   
   # Run specific test
   forge test --match-test testName
   ```

### Style Guide

#### Solidity

- Follow the [Solidity Style Guide](https://docs.soliditylang.org/en/latest/style-guide.html)
- Use clear and descriptive variable names
- Add comments for complex logic
- Optimize for gas efficiency where possible
- Ensure all functions have proper NatSpec documentation

#### Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

### Documentation

- Update the README.md if you change functionality
- Add comments to explain complex code sections
- Update the gas optimization section if you implement new optimizations
- Document any new functions or parameters

## Additional Notes

### Issue and Pull Request Labels

- `bug`: Something isn't working
- `enhancement`: New feature or request
- `good first issue`: Good for newcomers
- `help wanted`: Extra attention is needed
- `gas optimization`: Related to gas efficiency
- `security`: Security-related changes

## Recognition

Contributors will be recognized in the project's README.md file. Thank you for your contributions to making this project better!