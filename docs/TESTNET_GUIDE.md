# Testnet Deployment Guide

Step-by-step instructions for deploying Stellar Invoice Finance contracts to Stellar Testnet.

## 1. Fund a Testnet Account

```bash
curl "https://friendbot.stellar.org?addr=<YOUR_PUBLIC_KEY>"
```

Verify the balance:

```bash
curl "https://horizon-testnet.stellar.org/accounts/<YOUR_PUBLIC_KEY>" | jq '.balances'
```

## 2. Install Soroban CLI

```bash
cargo install --locked soroban-cli --features opt
```

Configure for testnet:

```bash
soroban config network add testnet \
  --rpc-url https://soroban-testnet.stellar.org \
  --network-passphrase "Test SDF Network ; September 2015"
```

## 3. Build the Contracts

```bash
make build
```

Output Wasm files are written to `target/wasm32-unknown-unknown/release/`.

## 4. Deploy Each Contract

```bash
# Deploy Invoice NFT
INVOICE_NFT_ID=$(soroban contract deploy \
  --wasm target/wasm32-unknown-unknown/release/invoice_nft.wasm \
  --source <YOUR_SECRET_KEY> \
  --network testnet)
echo "InvoiceNFT: $INVOICE_NFT_ID"

# Deploy Risk Registry
RISK_REGISTRY_ID=$(soroban contract deploy \
  --wasm target/wasm32-unknown-unknown/release/risk_registry.wasm \
  --source <YOUR_SECRET_KEY> \
  --network testnet)
echo "RiskRegistry: $RISK_REGISTRY_ID"

# Deploy Price Oracle
PRICE_ORACLE_ID=$(soroban contract deploy \
  --wasm target/wasm32-unknown-unknown/release/price_oracle.wasm \
  --source <YOUR_SECRET_KEY> \
  --network testnet)
echo "PriceOracle: $PRICE_ORACLE_ID"

# Deploy Financing Pool
FINANCING_POOL_ID=$(soroban contract deploy \
  --wasm target/wasm32-unknown-unknown/release/financing_pool.wasm \
  --source <YOUR_SECRET_KEY> \
  --network testnet)
echo "FinancingPool: $FINANCING_POOL_ID"

# Deploy Marketplace
MARKETPLACE_ID=$(soroban contract deploy \
  --wasm target/wasm32-unknown-unknown/release/marketplace.wasm \
  --source <YOUR_SECRET_KEY> \
  --network testnet)
echo "Marketplace: $MARKETPLACE_ID"
```

## 5. Initialise the Contracts

```bash
# Initialise Risk Registry
soroban contract invoke \
  --id $RISK_REGISTRY_ID \
  --source <YOUR_SECRET_KEY> \
  --network testnet \
  -- initialize --admin <YOUR_PUBLIC_KEY>

# Initialise Price Oracle
soroban contract invoke \
  --id $PRICE_ORACLE_ID \
  --source <YOUR_SECRET_KEY> \
  --network testnet \
  -- initialize --admin <YOUR_PUBLIC_KEY>

# Initialise Financing Pool
soroban contract invoke \
  --id $FINANCING_POOL_ID \
  --source <YOUR_SECRET_KEY> \
  --network testnet \
  -- initialize \
    --admin <YOUR_PUBLIC_KEY> \
    --risk_registry $RISK_REGISTRY_ID \
    --price_oracle $PRICE_ORACLE_ID

# Authorise callers on Invoice NFT
soroban contract invoke \
  --id $INVOICE_NFT_ID \
  --source <YOUR_SECRET_KEY> \
  --network testnet \
  -- set_authorized_callers \
    --marketplace $MARKETPLACE_ID \
    --financing_pool $FINANCING_POOL_ID
```

## 6. Save Contract IDs

Store the deployed contract IDs in your SDK config or `.env` file:

```env
INVOICE_NFT_CONTRACT_ID=<value>
RISK_REGISTRY_CONTRACT_ID=<value>
PRICE_ORACLE_CONTRACT_ID=<value>
FINANCING_POOL_CONTRACT_ID=<value>
MARKETPLACE_CONTRACT_ID=<value>
STELLAR_NETWORK=testnet
SOROBAN_RPC_URL=https://soroban-testnet.stellar.org
```

## Troubleshooting

- **Simulation fails** — ensure the account has at least 10 XLM for fees and storage rent
- **Unauthorized error** — confirm `set_authorized_callers` was run after all contracts were deployed
- **Contract not found** — double-check the contract ID and that you are on the correct network passphrase
