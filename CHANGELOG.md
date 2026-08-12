# Kora Protocol — Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- `ROADMAP.md` — release milestones for v0.2, v0.3, and v1.0
- `FAQ.md` — frequently asked questions for SMEs, investors, and developers
- `docs/GLOSSARY.md` — protocol terminology definitions
- `docs/RUNBOOK.md` — operational runbook covering pause, fee updates, TTL, and rollback
- `docs/ERROR_CODES.md` — full error code reference table
- `docs/DISCOUNT_RATE_GUIDE.md` — guide to discount rates, yield calculations, and risk tiers
- `.editorconfig` — consistent indentation settings across editors
- `.gitattributes` — normalized line endings and binary file markers
- `.github/ISSUE_TEMPLATE/bug_report.md` — structured bug report template
- `.github/ISSUE_TEMPLATE/feature_request.md` — structured feature request template
- `.github/pull_request_template.md` — PR checklist template
- `scripts/check-versions.sh` — toolchain prerequisite checker
- `scripts/fund-testnet-accounts.sh` — Friendbot helper for testnet funding
- `scripts/smoke-test.sh` — post-deployment read-only sanity check
- `scripts/rotate-admin.sh` — admin role rotation across all contracts
- `examples/mint-and-list.sh` — end-to-end mint and listing example
- `examples/fund-invoice.sh` — investor funding example
- `examples/repay-invoice.sh` — SME repayment example

### Fixed
- **Removed duplicate sme_invoice_counted event** — use sme_invoice_count_incremented instead across all SME profile tracking (see `contracts/shared/src/events.rs` and AUDIT_LOG.md)

### Planned
- Multisig admin with timelock
- Contract upgrade mechanism
- Secondary market for pool positions
- Keeper network for TTL management
- On-chain FX oracle integration

---

## [0.1.0] — 2026-05-18

### Added
- `invoice_nft` contract — mint, status transitions, invoice NFT data model
- `marketplace` contract — list, fund, cancel, fee collection, whitelist
- `financing_pool` contract — fund custody, position tracking, repayment, yield distribution, default handling
- `treasury` contract — fee accumulation, admin withdrawal, emergency drain
- `risk_registry` contract — verifier management, SME profiles, debtor scoring
- `access_control` contract — pause/unpause, role management, admin transfer
- `shared` library — types, errors, events, validation utilities
- Integration test suite covering full invoice lifecycle and edge cases
- Deployment scripts for testnet and mainnet
- Makefile with build, test, lint, and deploy targets
- README, CONTRIBUTING, ARCHITECTURE, CONTRACTS, SECURITY documentation
