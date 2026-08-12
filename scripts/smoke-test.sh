#!/usr/bin/env bash
# scripts/smoke-test.sh
#
# Quick smoke test: verify that all deployed contracts respond to a read-only
# query. Does NOT mutate any state. Useful as a post-deployment sanity check.
#
# Required environment variables (set in contracts.env or export manually):
#   INVOICE_NFT_ID
#   MARKETPLACE_ID
#   FINANCING_POOL_ID
#   TREASURY_ID
#   RISK_REGISTRY_ID
#   ACCESS_CONTROL_ID
#
# Usage:
#   source scripts/contracts.env.example
#   ./scripts/smoke-test.sh

set -euo pipefail

NETWORK="${NETWORK:-testnet}"
PASS=0
FAIL=0

check() {
  local name="$1"
  local contract_id="$2"
  local key="$3"

  if stellar contract read \
    --network "$NETWORK" \
    --id "$contract_id" \
    --key "$key" &>/dev/null; then
    echo "[PASS] $name — storage key '$key' readable"
    PASS=$((PASS + 1))
  else
    echo "[FAIL] $name — could not read storage key '$key'"
    FAIL=$((FAIL + 1))
  fi
}

echo "==> Smoke-testing Kora Protocol contracts on $NETWORK"
echo

: "${INVOICE_NFT_ID:?Set INVOICE_NFT_ID}"
: "${MARKETPLACE_ID:?Set MARKETPLACE_ID}"
: "${FINANCING_POOL_ID:?Set FINANCING_POOL_ID}"
: "${TREASURY_ID:?Set TREASURY_ID}"
: "${RISK_REGISTRY_ID:?Set RISK_REGISTRY_ID}"
: "${ACCESS_CONTROL_ID:?Set ACCESS_CONTROL_ID}"

check "invoice_nft" "$INVOICE_NFT_ID" "Admin"
check "marketplace" "$MARKETPLACE_ID" "Admin"
check "financing_pool" "$FINANCING_POOL_ID" "Admin"
check "treasury" "$TREASURY_ID" "Admin"
check "risk_registry" "$RISK_REGISTRY_ID" "Admin"
check "access_control" "$ACCESS_CONTROL_ID" "Admin"

echo
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
