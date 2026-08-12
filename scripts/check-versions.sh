#!/usr/bin/env bash
# check-versions.sh — Verify that required toolchain versions are installed
# before attempting a build or deployment.

set -euo pipefail

REQUIRED_RUST="1.75"
REQUIRED_STELLAR_CLI="21"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[OK]${NC}  $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail() { echo -e "${RED}[FAIL]${NC} $*"; }

errors=0

# --- Rust ---
if command -v rustc &>/dev/null; then
  rust_ver=$(rustc --version | awk '{print $2}')
  if printf '%s\n%s\n' "$REQUIRED_RUST" "$rust_ver" | sort -V -C; then
    ok "Rust $rust_ver (>= $REQUIRED_RUST required)"
  else
    fail "Rust $rust_ver is below minimum $REQUIRED_RUST"
    errors=$((errors + 1))
  fi
else
  fail "rustc not found — install Rust from https://rustup.rs"
  errors=$((errors + 1))
fi

# --- Cargo ---
if command -v cargo &>/dev/null; then
  ok "cargo $(cargo --version | awk '{print $2}')"
else
  fail "cargo not found"
  errors=$((errors + 1))
fi

# --- Stellar CLI ---
if command -v stellar &>/dev/null; then
  stellar_ver=$(stellar --version 2>&1 | head -1 | grep -oP '\d+\.\d+\.\d+' || echo "unknown")
  major=$(echo "$stellar_ver" | cut -d. -f1)
  if [ "$major" -ge "$REQUIRED_STELLAR_CLI" ] 2>/dev/null; then
    ok "stellar-cli $stellar_ver (>= $REQUIRED_STELLAR_CLI required)"
  else
    warn "stellar-cli $stellar_ver — expected major version >= $REQUIRED_STELLAR_CLI"
  fi
else
  fail "stellar not found — install stellar-cli: https://developers.stellar.org/docs/tools/developer-tools/cli/install-cli"
  errors=$((errors + 1))
fi

# --- wasm32 target ---
if rustup target list --installed 2>/dev/null | grep -q "wasm32-unknown-unknown"; then
  ok "wasm32-unknown-unknown target installed"
else
  fail "wasm32-unknown-unknown target missing — run: rustup target add wasm32-unknown-unknown"
  errors=$((errors + 1))
fi

# --- soroban optimizer (optional) ---
if command -v wasm-opt &>/dev/null; then
  ok "wasm-opt $(wasm-opt --version 2>&1 | head -1) (optional, improves Wasm size)"
else
  warn "wasm-opt not found (optional) — install binaryen for smaller Wasm output"
fi

echo
if [ "$errors" -eq 0 ]; then
  echo -e "${GREEN}All required tools are present.${NC}"
else
  echo -e "${RED}$errors requirement(s) failed. Fix the issues above before continuing.${NC}"
  exit 1
fi
