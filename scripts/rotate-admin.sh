#!/usr/bin/env bash
# scripts/rotate-admin.sh
#
# Transfer the admin role on all Kora contracts to a new address.
# Run this when handing off governance to a multisig or a new key.
#
# IMPORTANT: The new admin address must be able to sign Stellar transactions.
#            Verify the new address before running this script — there is no
#            undo once the role is transferred.
#
# Required environment variables:
#   CURRENT_ADMIN_SECRET   — current admin's secret key
#   NEW_ADMIN_ADDRESS      — new admin's public address (G...)
#   INVOICE_NFT_ID, MARKETPLACE_ID, FINANCING_POOL_ID,
#   TREASURY_ID, RISK_REGISTRY_ID, ACCESS_CONTROL_ID
#
# Usage:
#   source scripts/contracts.env.example
#   export CURRENT_ADMIN_SECRET=S...
#   export NEW_ADMIN_ADDRESS=G...
#   ./scripts/rotate-admin.sh

set -euo pipefail

NETWORK="${NETWORK:-testnet}"

: "${CURRENT_ADMIN_SECRET:?Set CURRENT_ADMIN_SECRET}"
: "${NEW_ADMIN_ADDRESS:?Set NEW_ADMIN_ADDRESS}"
: "${INVOICE_NFT_ID:?Set INVOICE_NFT_ID}"
: "${MARKETPLACE_ID:?Set MARKETPLACE_ID}"
: "${FINANCING_POOL_ID:?Set FINANCING_POOL_ID}"
: "${TREASURY_ID:?Set TREASURY_ID}"
: "${RISK_REGISTRY_ID:?Set RISK_REGISTRY_ID}"
: "${ACCESS_CONTROL_ID:?Set ACCESS_CONTROL_ID}"

CONTRACTS=(
  "invoice_nft:$INVOICE_NFT_ID"
  "marketplace:$MARKETPLACE_ID"
  "financing_pool:$FINANCING_POOL_ID"
  "treasury:$TREASURY_ID"
  "risk_registry:$RISK_REGISTRY_ID"
  "access_control:$ACCESS_CONTROL_ID"
)

echo "==> Rotating admin to $NEW_ADMIN_ADDRESS on $NETWORK"
echo "    (Ctrl-C now if this is not intended)"
sleep 3

for entry in "${CONTRACTS[@]}"; do
  name="${entry%%:*}"
  contract_id="${entry##*:}"
  echo "--> $name ($contract_id)"
  stellar contract invoke \
    --network "$NETWORK" \
    --source "$CURRENT_ADMIN_SECRET" \
    --id "$contract_id" \
    -- transfer_admin \
    --new_admin "$NEW_ADMIN_ADDRESS"
  echo "    Done"
done

echo
echo "Admin role transferred to $NEW_ADMIN_ADDRESS on all contracts."
echo "Verify with: stellar contract read --network $NETWORK --id <CONTRACT_ID> --key Admin"
