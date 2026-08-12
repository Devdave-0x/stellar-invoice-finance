# Kora Protocol — Roadmap

This document outlines planned features and milestones for the Kora Protocol. Items are organized by release horizon and subject to change based on community feedback and market conditions.

---

## Current Release — v0.1.0 (shipped)

- Invoice NFT minting and on-chain metadata
- Marketplace listing, funding, and cancellation
- Financing pool with partial funding support
- Treasury fee accumulation and withdrawal
- Risk registry with SME profiles and debtor scoring
- Access control with role-based pause mechanism
- Full integration test suite
- Testnet deployment scripts

---

## Near-term — v0.2.0 (Q3 2026)

### Protocol Improvements
- [ ] **Multisig admin with timelock** — require N-of-M signatures for critical parameter changes; enforce a 48 h delay before execution
- [ ] **Contract upgrade mechanism** — safe, governance-gated Wasm upgrades without fund migration
- [ ] **Grace-period repayment** — configurable buffer after due date before a default is recorded

### SDK & Tooling
- [ ] **TypeScript SDK** — typed wrappers for every contract entry point, with automatic retry and fee estimation
- [ ] **CLI tool** (`kora-cli`) — mint, list, fund, and repay invoices from the terminal
- [ ] **Subgraph / indexer** — event-driven off-chain index for portfolio dashboards

### Documentation
- [ ] Step-by-step integration guide for SME fintech apps
- [ ] Formal threat model review publication
- [ ] Video walkthrough of the full invoice lifecycle

---

## Medium-term — v0.3.0 (Q4 2026)

### New Features
- [ ] **Secondary market for pool positions** — allow investors to trade their financing positions before repayment
- [ ] **Batch invoice minting** — mint multiple invoices in a single transaction to reduce friction for high-volume SMEs
- [ ] **On-chain FX oracle integration** — support invoices denominated in non-USDC stablecoins with automatic conversion
- [ ] **Keeper network for TTL management** — decentralized bots that extend ledger TTL entries and trigger overdue checks

### Risk & Compliance
- [ ] **Credit scoring v2** — incorporate historical repayment data from the risk registry into automated discount-rate suggestions
- [ ] **Sanctions screening hook** — pluggable compliance layer that can reject whitelisted addresses flagged by off-chain providers
- [ ] **Audit by a third-party security firm** — public report targeting v0.3.0 codebase

---

## Long-term — v1.0.0 (2027)

- [ ] **Supply chain finance module** — extend the protocol to purchase order (PO) financing and dynamic discounting
- [ ] **DAO governance** — token-weighted voting on protocol parameters (fees, risk thresholds, upgrades)
- [ ] **Cross-border trade rails** — multi-leg invoice financing spanning multiple jurisdictions with correspondent bank settlement hooks
- [ ] **Mobile-first SME app** — React Native interface targeting low-bandwidth environments across sub-Saharan Africa
- [ ] **Mainnet launch** — production deployment after audit, legal review, and regulatory mapping for target markets

---

## How to Influence the Roadmap

Open a [GitHub Discussion](https://github.com/Devdave-0x/stellar-invoice-finance/discussions) or comment on an existing issue. Roadmap priorities shift based on:

1. Community demand and upvotes on GitHub issues
2. Partner SME and investor feedback
3. Stellar ecosystem grant availability
4. Security audit findings

---

*Last updated: 2026-08-12*
