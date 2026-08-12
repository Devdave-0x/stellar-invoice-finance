# Kora Protocol — Storage Schema Reference

This document lists the Soroban storage keys used by each contract, their storage type (instance / persistent), and the value type stored. Use this as a quick reference when reading contract state with `stellar contract read`.

---

## invoice_nft

| Key | Storage Type | Value Type | Description |
|-----|-------------|------------|-------------|
| `Admin` | Instance | `Address` | Contract admin |
| `AccessControl` | Instance | `Address` | Access control contract address |
| `Marketplace` | Instance | `Address` | Authorized marketplace address |
| `FinancingPool` | Instance | `Address` | Authorized financing pool address |
| `RiskRegistry` | Instance | `Address` | Authorized risk registry address |
| `NextId` | Instance | `u64` | Next invoice ID to assign |
| `MigrationVersion` | Instance | `u32` | Current schema version (starts at 1) |
| `UpgradeProposal` | Instance | `(BytesN<32>, u64)` | Pending upgrade: (wasm_hash, proposed_at) |
| `Invoice(u64)` | Persistent | `Invoice` | Full invoice struct by ID |
| `InvoiceFrozen(u64)` | Persistent | `bool` | Whether invoice is individually frozen |
| `OutstandingExposure(Address)` | Persistent | `i128` | Aggregate USDC exposure per investor |
| `CurrencyAllowlist(Symbol)` | Persistent | `bool` | Whether a currency symbol is allowed |

---

## marketplace

| Key | Storage Type | Value Type | Description |
|-----|-------------|------------|-------------|
| `Admin` | Instance | `Address` | Contract admin |
| `Config` | Instance | `MarketplaceConfig` | Packed config (admin, contract addresses, fee_bps) |
| `FeeBps` | Instance | `u32` | Protocol fee in basis points |
| `AccessControl` | Instance | `Address` | Access control contract address |
| `InvoiceNft` | Instance | `Address` | Invoice NFT contract address |
| `FinancingPool` | Instance | `Address` | Financing pool contract address |
| `Treasury` | Instance | `Address` | Treasury contract address |
| `UpgradeProposal` | Instance | `(BytesN<32>, u64)` | Pending upgrade |
| `Listing(u64)` | Persistent | `Listing` | Active listing by invoice ID |
| `WhitelistedToken(Address)` | Persistent | `bool` | Whether a token is whitelisted for payment |
| `TierFeeBps(u32)` | Persistent | `u32` | Per-risk-tier fee override |
| `Contribution(u64, Address)` | Persistent | `i128` | Per-investor net contribution for refunds |
| `RefundClaimed(u64, Address)` | Persistent | `bool` | Whether investor claimed refund |

---

## financing_pool

| Key | Storage Type | Value Type | Description |
|-----|-------------|------------|-------------|
| `Admin` | Instance | `Address` | Contract admin |
| `AccessControl` | Instance | `Address` | Access control contract address |
| `InvoiceNft` | Instance | `Address` | Invoice NFT contract address |
| `UpgradeProposal` | Instance | `(BytesN<32>, u64)` | Pending upgrade |
| `Position(u64, Address)` | Persistent | `i128` | Investor position (contribution) per invoice |
| `TotalFunded(u64)` | Persistent | `i128` | Total funded amount per invoice |
| `FaceValue(u64)` | Persistent | `i128` | Face value stored at funding time |

---

## treasury

| Key | Storage Type | Value Type | Description |
|-----|-------------|------------|-------------|
| `Admin` | Instance | `Address` | Contract admin |
| `Token` | Instance | `Address` | Accepted fee token (USDC) |
| `UpgradeProposal` | Instance | `(BytesN<32>, u64)` | Pending upgrade |

> Treasury balance is tracked by the token contract directly; no extra storage key is needed.

---

## risk_registry

| Key | Storage Type | Value Type | Description |
|-----|-------------|------------|-------------|
| `Admin` | Instance | `Address` | Contract admin |
| `AccessControl` | Instance | `Address` | Access control contract address |
| `UpgradeProposal` | Instance | `(BytesN<32>, u64)` | Pending upgrade |
| `Verifier(Address)` | Persistent | `bool` | Whether address is an authorized verifier |
| `SMEProfile(Address)` | Persistent | `SMEProfile` | SME profile (invoice count, default count, etc.) |
| `DebtorScore(Bytes)` | Persistent | `DebtorScore` | Risk score and tier for a debtor hash |

---

## access_control

| Key | Storage Type | Value Type | Description |
|-----|-------------|------------|-------------|
| `Admin` | Instance | `Address` | Contract admin |
| `PauseAdmin` | Instance | `Address` | Address permitted to pause/unpause |
| `Paused` | Instance | `bool` | Whether protocol is currently paused |
| `UpgradeProposal` | Instance | `(BytesN<32>, u64)` | Pending upgrade |

---

## Reading Storage with Stellar CLI

```bash
# Read a single key
stellar contract read \
  --network testnet \
  --id <CONTRACT_ID> \
  --key <KEY>

# Read a tuple key (e.g. a listing)
stellar contract read \
  --network testnet \
  --id <MARKETPLACE_ID> \
  --key "Listing(1)"
```

---

*This document reflects schema version 1 (MigrationVersion = 1). Update this file when new storage keys are added.*
