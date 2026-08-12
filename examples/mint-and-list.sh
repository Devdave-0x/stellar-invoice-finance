#!/usr/bin/env bash
# examples/mint-and-list.sh
#
# End-to-end example: mint an invoice NFT and list it on the marketplace.
#
# Prerequisites:
#   - Contracts deployed and contract IDs set in environment variables (see below)
#   - Stellar CLI installed and configured
#   - SME account funded on testnet (use scripts/fund-testnet-accounts.sh)
#
# Required environment variables:
#   INVOICE_NFT_ID      — deployed invoice_nft contract ID
#   MARKETPLACE_ID      — deployed marketplace contract ID
#   SME_SECRET          — SME's Stellar secret key
#   DEBTOR_HASH         — hex-encoded SHA-256 of the debtor's company identifier
#   IPFS_CID            — IPFS CID of the invoice PDF / JSON metadata
#
# Usage:
#   export INVOICE_NFT_ID=C...
#   export MARKETPLACE_ID=C...
#   export SME_SECRET=S...
#   export DEBTOR_HASH=abc123...
#   export IPFS_CID=bafybeig...
#   ./examples/mint-and-list.sh

set -euo pipefail

: "${INVOICE_NFT_ID:?Set INVOICE_NFT_ID}"
: "${MARKETPLACE_ID:?Set MARKETPLACE_ID}"
: "${SME_SECRET:?Set SME_SECRET}"
: "${DEBTOR_HASH:?Set DEBTOR_HASH}"
: "${IPFS_CID:?Set IPFS_CID}"

NETWORK="${NETWORK:-testnet}"

# Invoice parameters — adjust as needed
INVOICE_AMOUNT=10000000000   # 10,000 USDC (7 decimal places)
CURRENCY="USDC"
DUE_DATE=$(date -d "+60 days" +%s 2>/dev/null || date -v+60d +%s)  # 60 days from now
RISK_SCORE=75                # 0–100; higher = lower risk

# Marketplace listing parameters
ASKING_PRICE=9500000000      # 9,500 USDC — 5% discount
FUNDING_DEADLINE=$(date -d "+7 days" +%s 2>/dev/null || date -v+7d +%s)

echo "==> Step 1: Mint invoice NFT"
MINT_OUTPUT=$(stellar contract invoke \
  --network "$NETWORK" \
  --source "$SME_SECRET" \
  --id "$INVOICE_NFT_ID" \
  -- mint_invoice \
  --amount "$INVOICE_AMOUNT" \
  --currency "$CURRENCY" \
  --due_date "$DUE_DATE" \
  --debtor_hash "$DEBTOR_HASH" \
  --ipfs_cid "$IPFS_CID" \
  --risk_score "$RISK_SCORE")

INVOICE_ID=$(echo "$MINT_OUTPUT" | grep -oP '\d+' | head -1)
echo "    Minted invoice ID: $INVOICE_ID"

echo "==> Step 2: List invoice on marketplace"
stellar contract invoke \
  --network "$NETWORK" \
  --source "$SME_SECRET" \
  --id "$MARKETPLACE_ID" \
  -- list_invoice \
  --invoice_id "$INVOICE_ID" \
  --asking_price "$ASKING_PRICE" \
  --funding_deadline "$FUNDING_DEADLINE"

echo "    Listed invoice $INVOICE_ID at asking price $ASKING_PRICE"
echo
echo "Done. Investors can now call fund_invoice on $MARKETPLACE_ID."
