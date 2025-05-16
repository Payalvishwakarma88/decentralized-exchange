Decentralized Exchange (DEX)

A decentralized exchange platform for swapping ERC20 tokens with a simple automated market maker mechanism.

## Project Description

This project implements a decentralized exchange (DEX) that allows users to swap between different ERC20 tokens. The exchange uses a constant product formula (x * y = k) to determine exchange rates, similar to popular AMMs like Uniswap. The DEX charges a small fee (0.3%) on every swap, which is retained in the liquidity pool.

## Project Vision

The vision for this DEX is to create a simple, secure, and efficient platform for token swaps without relying on traditional intermediaries. By leveraging smart contracts on the blockchain, we aim to provide:

1. A permissionless trading environment where anyone can participate
2. Transparent pricing through an automated market maker model
3. Opportunities for liquidity providers to earn fees
4. A foundation for building more complex DeFi applications

## Key Features

- **Token Swapping**: Exchange between any supported ERC20 tokens
- **Liquidity Provision**: Add liquidity to the exchange and earn fees
- **Constant Product AMM**: Pricing determined by x * y = k formula
- **Owner Controls**: Add/remove supported tokens
- **Fee Structure**: 0.3% fee on all swaps
- **Price Oracle**: Get the current exchange rate between any two supported tokens

## Future Scope

- **Liquidity Provider Tokens**: Issue LP tokens to track liquidity provider ownership
- **Governance Functionality**: Transition to a DAO-based governance model
- **Flash Loans**: Implement flash loan capabilities
- **Multiple Fee Tiers**: Introduce different fee levels for various token pairs
- **Farming/Staking Rewards**: Create incentives for liquidity providers
- **Price Oracles**: External price feeds for more accurate swaps
- **Multi-chain Support**: Expand to other EVM-compatible blockchains
- **Token Lists**: Allow users to filter and select tokens from curated lists
- **UI Development**: Create a user-friendly interface for the DEX

## Getting Started

### Prerequisites

- Node.js (v14+ recommended)
- npm or yarn

### Installation

1. Clone the repository:
```
git clone https://github.com/yourusername/decentralized-exchange.git
cd decentralized-exchange
```

2. Install the dependencies:
```
npm install
```

3. Create a `.env` file in the root directory with your private key:
```
PRIVATE_KEY=your_private_key_here
```

### Deployment

To deploy the contracts to Core Testnet 2:

```
npm run deploy
```

### Testing

Run the test suite:

```
npm test
```

## Security

This project is provided as-is for educational purposes and has not been audited. Do not use in production without proper security review.

## License

This project is licensed under the MIT License.
