#!/usr/bin/env bash
# examples/fund-invoice.sh
#
# Example: fund an invoice listing as an investor.
#
# Prerequisites:
#   - Invoice already minted and listed (see examples/mint-and-list.sh)
#   - Investor account funded with USDC on testnet
#
# Required environment variables:
#   MARKETPLACE_ID    — deployed marketplace contract ID
#   INVESTOR_SECRET   — investor's Stellar secret key
#   INVOICE_ID        — ID of the invoice to fund
#   FUND_AMOUNT       — USDC amount to contribute (7 decimal places)
#
# Usage:
#   export MARKETPLACE_ID=C...
#   export INVESTOR_SECRET=S...
#   export INVOICE_ID=1
#   export FUND_AMOUNT=5000000000   # 500 USDC
#   ./examples/fund-invoice.sh

set -euo pipefail

: "${MARKETPLACE_ID:?Set MARKETPLACE_ID}"
: "${INVESTOR_SECRET:?Set INVESTOR_SECRET}"
: "${INVOICE_ID:?Set INVOICE_ID}"
: "${FUND_AMOUNT:?Set FUND_AMOUNT}"

NETWORK="${NETWORK:-testnet}"

echo "==> Funding invoice $INVOICE_ID with $FUND_AMOUNT units on $NETWORK"

stellar contract invoke \
  --network "$NETWORK" \
  --source "$INVESTOR_SECRET" \
  --id "$MARKETPLACE_ID" \
  -- fund_invoice \
  --invoice_id "$INVOICE_ID" \
  --amount "$FUND_AMOUNT"

echo "    Done. Your position is recorded in the financing pool."
echo "    You will receive principal + yield when the SME repays."
