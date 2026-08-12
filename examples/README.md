# Examples

This directory contains runnable shell script examples for common Kora Protocol operations using the Stellar CLI.

---

## Prerequisites

1. **Stellar CLI** installed and on your `PATH` (see [installation guide](https://developers.stellar.org/docs/tools/developer-tools/cli/install-cli))
2. **Contracts deployed** and IDs exported (source your `contracts.env` file)
3. **Accounts funded** with XLM and USDC on testnet (see `scripts/fund-testnet-accounts.sh`)
4. Run `./scripts/check-versions.sh` to confirm your toolchain is up to date

---

## Available Examples

| Script | Description |
|--------|-------------|
| `mint-and-list.sh` | SME mints an invoice NFT and lists it on the marketplace |
| `fund-invoice.sh` | Investor funds an active invoice listing |
| `repay-invoice.sh` | SME repays an invoice, distributing yield to investors |

---

## Quick Start

```bash
# 1. Set up environment
source scripts/contracts.env

# 2. Fund test accounts on testnet
./scripts/fund-testnet-accounts.sh $SME_ADDRESS $INVESTOR_ADDRESS

# 3. SME mints and lists an invoice
export SME_SECRET=S...
export DEBTOR_HASH=<sha256 of debtor ID>
export IPFS_CID=bafybeig...
./examples/mint-and-list.sh

# 4. Investor funds the invoice
export INVESTOR_SECRET=S...
export INVOICE_ID=1
export FUND_AMOUNT=9500000000   # Full asking price in USDC stroops
./examples/fund-invoice.sh

# 5. SME repays
export FACE_VALUE=10000000000
./examples/repay-invoice.sh
```

---

## Notes

- All amounts are in **USDC with 7 decimal places** (stroops). 1 USDC = 10,000,000 units.
- Set `NETWORK=testnet` (default) or `NETWORK=mainnet` to target a specific network.
- Never expose secret keys in shell history. Prefer loading them from a `.env` file that is excluded from version control.
