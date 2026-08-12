#!/usr/bin/env bash
# examples/repay-invoice.sh
#
# Example: SME repays an invoice, triggering yield distribution to investors.
#
# Prerequisites:
#   - Invoice minted, listed, and fully funded
#   - SME account holds sufficient USDC to cover the face value
#
# Required environment variables:
#   FINANCING_POOL_ID   — deployed financing_pool contract ID
#   SME_SECRET          — SME's Stellar secret key
#   INVOICE_ID          — ID of the invoice to repay
#   FACE_VALUE          — Full invoice face value in USDC (7 decimal places)
#
# Usage:
#   export FINANCING_POOL_ID=C...
#   export SME_SECRET=S...
#   export INVOICE_ID=1
#   export FACE_VALUE=10000000000   # 10,000 USDC
#   ./examples/repay-invoice.sh

set -euo pipefail

: "${FINANCING_POOL_ID:?Set FINANCING_POOL_ID}"
: "${SME_SECRET:?Set SME_SECRET}"
: "${INVOICE_ID:?Set INVOICE_ID}"
: "${FACE_VALUE:?Set FACE_VALUE}"

NETWORK="${NETWORK:-testnet}"

echo "==> Repaying invoice $INVOICE_ID — face value: $FACE_VALUE USDC units"

stellar contract invoke \
  --network "$NETWORK" \
  --source "$SME_SECRET" \
  --id "$FINANCING_POOL_ID" \
  -- repay \
  --invoice_id "$INVOICE_ID" \
  --amount "$FACE_VALUE"

echo "    Repayment submitted."
echo "    Investors will receive principal + yield on their next claim."
