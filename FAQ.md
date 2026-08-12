# Kora Protocol — Frequently Asked Questions

---

## General

**What is Kora Protocol?**

Kora is a decentralized invoice financing protocol built on Stellar Soroban. It lets SMEs tokenize unpaid invoices as on-chain NFTs and sell them at a discount to investors, receiving immediate working capital instead of waiting 30–90 days for settlement.

**Why Stellar / Soroban?**

Stellar offers sub-second finality, predictable low fees (~0.00001 XLM per operation), and a native USDC issuance from Circle. Soroban adds smart-contract programmability while preserving those properties. For African trade finance — where participants are often mobile-first and bandwidth-constrained — Stellar's transaction model is a better fit than Ethereum's gas market.

**Is Kora audited?**

A formal third-party audit is planned for the v0.3.0 release (see [ROADMAP.md](ROADMAP.md)). The codebase has an internal threat model (see [THREAT_MODEL.md](THREAT_MODEL.md)) and a structured security policy (see [SECURITY.md](SECURITY.md)). Do not use this protocol with material funds until an independent audit is complete.

---

## For SMEs

**How do I mint an invoice?**

Call `InvoiceNFT::mint_invoice` with the invoice amount, debtor address, due date, and an IPFS CID pointing to the full invoice document. Sensitive PII should be stored off-chain; only hashed identifiers go on-chain.

**What discount rate will I receive?**

The discount is set by the SME when listing on the marketplace. The risk registry provides a suggested rate based on the debtor's historical payment score, but the final price is negotiable.

**What happens if the invoice is not fully funded?**

If the funding deadline passes without 100 % funding, the invoice listing can be cancelled and any partial contributions are returned to investors. The invoice NFT reverts to `Active` status and can be re-listed.

**What happens if I cannot repay on time?**

A configurable grace period (planned for v0.2.0) will give SMEs additional time. After the grace period the financing pool marks the invoice as `Defaulted`, which affects the debtor's risk score in the registry and may trigger recovery procedures defined in the pool contract.

---

## For Investors

**How do I fund an invoice?**

Call `Marketplace::fund_invoice` with the invoice ID and the USDC amount you wish to contribute. Partial funding is supported — you do not need to fund the entire invoice.

**Where are my funds held?**

Funds are custodied by the `financing_pool` contract, not by the marketplace. The pool tracks each investor's position by invoice ID.

**When do I receive my return?**

When the SME calls `FinancingPool::repay`, the pool distributes principal plus yield to all investors proportionally to their contribution. The spread between the discounted price paid and the face value repaid is the investor's return.

**What is the protocol fee?**

The marketplace collects a small fee on each investor contribution. The current fee rate is set by the admin and visible as a contract storage entry. Fees accumulate in the `treasury` contract and are withdrawn by the protocol admin.

---

## Technical

**Which Rust / Soroban versions are required?**

See the top-level `Cargo.toml` for exact dependency versions. As of v0.1.0 the project targets `soroban-sdk 21.x` and requires Rust 1.75 or later.

**How do I run a local testnet?**

Follow the [Testnet Deployment Guide](docs/TESTNET_GUIDE.md). The `scripts/deploy.sh` script automates contract deployment to the Stellar testnet.

**Can I integrate Kora into my own application?**

Yes. The `sdk/` directory contains a TypeScript SDK (work in progress). Until the SDK stabilizes, you can call contracts directly via the Stellar JS SDK or `stellar-cli`. See [docs/INTEGRATION.md](docs/INTEGRATION.md) for examples.

**Where is the contract ABI / interface?**

Each contract exposes its entry points through Soroban's native `contractspec` metadata embedded in the Wasm. Run `stellar contract info --wasm <path>.wasm` to inspect the spec, or read the inline `contracttype` and `contractimpl` blocks in each contract's `lib.rs`.

---

## Contributing

**How do I contribute?**

See [CONTRIBUTING.md](CONTRIBUTING.md). In short: fork the repo, create a feature branch, make your changes with tests, and open a pull request. All contributors must sign off on the Developer Certificate of Origin (DCO).

**Where do I report a security vulnerability?**

Follow the responsible disclosure process described in [SECURITY.md](SECURITY.md). Do not open a public GitHub issue for security bugs.

---

*Have a question that is not answered here? Open a [GitHub Discussion](https://github.com/Devdave-0x/stellar-invoice-finance/discussions).*
