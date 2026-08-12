#!/usr/bin/env bash
# fund-testnet-accounts.sh — Use Friendbot to fund one or more Stellar testnet
# accounts with XLM so they can submit transactions.
#
# Usage:
#   ./scripts/fund-testnet-accounts.sh <ADDRESS> [ADDRESS ...]
#
# Example:
#   ./scripts/fund-testnet-accounts.sh G... G...

set -euo pipefail

FRIENDBOT_URL="https://friendbot.stellar.org"

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <STELLAR_ADDRESS> [STELLAR_ADDRESS ...]"
  exit 1
fi

for addr in "$@"; do
  echo "Funding $addr via Friendbot..."
  response=$(curl -s -o /dev/null -w "%{http_code}" \
    "${FRIENDBOT_URL}?addr=${addr}")
  if [ "$response" = "200" ]; then
    echo "  OK — $addr funded"
  elif [ "$response" = "400" ]; then
    echo "  WARN — $addr may already be funded (HTTP 400 from Friendbot)"
  else
    echo "  ERROR — unexpected HTTP $response for $addr"
    exit 1
  fi
done

echo
echo "Done. Check balances with:"
echo "  stellar account show --network testnet --source-account <ADDRESS>"
