# 🏗️ FundMe – A Decentralized Crowdfunding Smart Contract

FundMe is a Solidity smart contract project built with the **Foundry** framework. This project allows users to **fund a contract** with ETH and enables the contract owner to **withdraw** the accumulated funds. It also demonstrates advanced Foundry testing, mock deployments, and scripting.

---

## 📦 Features

- Users can fund the contract with a minimum ETH threshold  
- Only the **owner** can withdraw the funds  
- Uses **Chainlink Price Feeds** to get real-time ETH/USD price  
- Fully tested with **Foundry unit and integration tests**  
- Gas-optimized with best Solidity practices  

---

## 🛠️ Tech Stack

- **Solidity** – Smart contract language  
- **Foundry** – Fast, portable, and modular toolkit for Ethereum development  
- **Chainlink** – Decentralized oracle for real-time ETH/USD conversion  
- **GitHub Actions** – CI/CD automation  

---

## 📁 Project Structure
fundme-foundry/
│
├── contracts/ # FundMe smart contracts
│ ├── FundMe.sol
│ └── PriceConverter.sol
│
├── script/ # Deployment and interaction scripts
│ └── DeployFundMe.s.sol
│
├── test/ # Unit and integration tests
│ └── FundMe.t.sol
│
├── lib/ # Dependencies (e.g., Chainlink, Foundry standard library)
│
├── .github/workflows/ # GitHub CI config
│ └── test.yml
│
├── foundry.toml # Foundry config file
└── README.md # Project documentation

## 🚀 Getting Started

### Prerequisites

- Foundry (install via: `curl -L https://foundry.paradigm.xyz | bash`)
- Node.js (for some optional tooling)
- Git
- An Ethereum wallet + RPC URL (e.g., Infura, Alchemy,Anvil)

### Installation

```bash
git clone https://github.com/ayush1097/fundme-foundry-f25.git
cd fundme-foundry
forge install

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Deploy Locally

```shell
forge script script/DeployFundMe.s.sol --fork-url <RPC_URL> --broadcast

```

### Run Test

```shell
forge test -vv

```

### Format Code

```shell
forge fmt
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
