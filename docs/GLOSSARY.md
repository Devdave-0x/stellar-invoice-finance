# Kora Protocol — Glossary

Definitions for terms used throughout the Kora Protocol codebase and documentation.

---

## A

**Access Control Contract**
The `access_control` Soroban contract that manages the protocol-wide pause state and role assignments. Other contracts call it before executing state-mutating operations.

**Admin**
An on-chain address with elevated privileges. Each contract stores its own admin reference. The top-level admin can transfer their role to a multisig address for decentralized governance.

**Asking Price**
The discounted price at which an SME lists an invoice. Always less than the invoice face value. The difference between face value and asking price represents the investor's potential yield.

---

## B

**Basis Points (bps)**
One hundredth of one percent (0.01 %). Protocol fees are expressed in basis points; 50 bps = 0.5 %.

---

## C

**IPFS CID (Content Identifier)**
A deterministic hash-based address for a file stored on the InterPlanetary File System. Kora stores full invoice documents (PDFs, structured JSON) on IPFS and records only the CID on-chain, keeping sensitive PII off the ledger.

---

## D

**Debtor**
The business or entity that owes payment on an invoice. The debtor is never stored in plaintext on-chain; only a SHA-256 hash of a canonical identifier (e.g. company registration number) is stored.

**Debtor Score**
A numeric risk indicator (0–100) stored in the risk registry for a given debtor. Higher scores indicate lower default risk. Used to suggest a discount rate when an SME lists an invoice.

**Default**
When an SME fails to repay an invoice by the due date (plus any grace period). The financing pool marks the invoice as `Defaulted`, which reduces the debtor's risk score and may trigger recovery procedures.

**Discount Rate**
The percentage by which an invoice is sold below its face value. For example, a $10,000 invoice listed at $9,500 carries a 5 % discount rate.

---

## F

**Face Value**
The full nominal amount owed on an invoice, denominated in USDC. The SME must repay the face value (not the asking price) to the financing pool.

**Financing Pool**
The `financing_pool` Soroban contract that holds investor funds in custody, tracks positions, releases funds to the SME upon full funding, and distributes repayments to investors.

**Funding Deadline**
The timestamp by which an invoice listing must be fully funded. If the deadline passes without 100 % funding, the listing is cancelled and partial contributions are refunded.

---

## I

**Invoice NFT**
An on-chain non-fungible token representing a single real-world invoice. Stored in the `invoice_nft` contract. Each NFT has a unique u64 ID and carries metadata including amount, currency, due date, debtor hash, IPFS CID, and current status.

**Invoice Status**
The state machine value for an invoice NFT. Allowed transitions:

```
Created → Listed → Funded → Repaid
                          ↘ Defaulted
```

---

## K

**Keeper**
An off-chain bot or script that periodically calls TTL-extending operations on Soroban persistent storage to prevent contract data from expiring. See `scripts/ttl_keeper.sh`.

**Kora Protocol**
The overall decentralized invoice financing protocol consisting of six Soroban smart contracts and the associated SDK, scripts, and documentation in this repository.

---

## L

**Ledger**
A single block in the Stellar network. Ledgers close approximately every 5–6 seconds. Soroban TTL values are expressed in ledgers.

**Listing**
A marketplace record created when an SME calls `Marketplace::list_invoice`. A listing records the invoice ID, asking price, funding deadline, and current funded amount.

---

## M

**Marketplace**
The `marketplace` Soroban contract that manages invoice listings, collects investor contributions, enforces the funding deadline, and charges the protocol fee.

---

## P

**Partial Funding**
Kora supports investors contributing less than the full asking price. The invoice is released for payment only when contributions reach 100 % of the asking price.

**Pause**
A protocol-wide circuit breaker. When the access control contract is paused, all state-mutating entry points on all contracts revert immediately.

---

## R

**Risk Registry**
The `risk_registry` Soroban contract that stores SME profiles and debtor risk scores. Authorized verifiers can submit scores; the protocol reads them during invoice listing.

**Risk Score**
A per-invoice or per-debtor numeric value (0–100) used to classify risk and derive a suggested discount rate.

**Risk Tier**
A categorical classification derived from the risk score: `Low`, `Medium`, `High`, or `Critical`. Used for display and gating purposes.

---

## S

**SME (Small and Medium Enterprise)**
The business that mints an invoice NFT and receives upfront financing. The SME is responsible for repaying the invoice face value to the financing pool.

**Soroban**
Stellar's smart-contract platform. Contracts are compiled to WebAssembly (Wasm) and executed in a deterministic sandbox on every validator node.

---

## T

**Treasury**
The `treasury` Soroban contract that accumulates protocol fees collected by the marketplace. Only the admin can withdraw accumulated fees.

**TTL (Time to Live)**
The number of ledgers for which a Soroban storage entry remains live before it expires and is archived. Persistent storage entries must be periodically bumped to stay accessible.

---

## V

**Verifier**
An address authorized by the risk registry admin to submit debtor risk scores. Verifiers are typically trusted off-chain credit bureaus or KYC providers.

---

## Y

**Yield**
The return earned by an investor. Yield = (Face Value − Asking Price) × (Investor Contribution / Asking Price). Distributed when the SME repays.
