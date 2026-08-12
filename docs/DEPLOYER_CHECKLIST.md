# Kora Protocol — Deployer Checklist

Use this checklist before and after deploying Kora Protocol contracts to any network (testnet or mainnet).

---

## Pre-Deployment

### Environment Setup
- [ ] Run `./scripts/check-versions.sh` — all required tools present
- [ ] Confirm `wasm32-unknown-unknown` target is installed (`rustup target list --installed`)
- [ ] Deployer account funded with sufficient XLM (testnet: use `./scripts/fund-testnet-accounts.sh`)
- [ ] USDC trustline established on deployer account

### Build Verification
- [ ] Run `make build` — all six contracts compile without warnings
- [ ] Wasm files are present in `target/wasm32-unknown-unknown/release/`
- [ ] Wasm file sizes are within expected bounds (< 200 KB each before optimization)
- [ ] Run `make lint` — no Clippy warnings

### Configuration Review
- [ ] `contracts.env.example` reviewed and copied to `contracts.env` with real values
- [ ] Admin address is a hardware wallet or multisig (not a hot key) for mainnet
- [ ] Fee rate (basis points) confirmed with stakeholders
- [ ] Pause admin address is separate from the treasury withdrawal admin

---

## Deployment

- [ ] Deploy `access_control` first — required by all other contracts
- [ ] Deploy `invoice_nft`
- [ ] Deploy `marketplace`
- [ ] Deploy `financing_pool`
- [ ] Deploy `treasury`
- [ ] Deploy `risk_registry`
- [ ] Record all contract IDs in `contracts.env`
- [ ] Run `./scripts/record-wasm-hashes.sh` to log Wasm hashes

---

## Post-Deployment Verification

- [ ] Run `./scripts/smoke-test.sh` — all contracts respond to read-only queries
- [ ] Run `./scripts/health-check.sh` — expected storage keys present
- [ ] Verify admin addresses match intended keys (`stellar contract read --key Admin`)
- [ ] Verify fee rate stored correctly (`stellar contract read --key FeeBps`)
- [ ] Confirm protocol is NOT paused (access_control PAUSED key should be absent or false)
- [ ] Test mint → list → fund → repay lifecycle with small amounts on testnet

---

## Mainnet-Only Additional Checks

- [ ] Third-party audit completed and findings resolved
- [ ] Legal and regulatory review completed for target markets
- [ ] Emergency contact list circulated to on-call team
- [ ] Incident response runbook reviewed by all operators (`docs/INCIDENT_RESPONSE.md`)
- [ ] TTL keeper cron job scheduled (`scripts/ttl_keeper.sh`)
- [ ] Monitoring and alerting configured for contract events

---

## After Go-Live

- [ ] Announce contract addresses to integrators
- [ ] Update `README.md` with mainnet contract IDs
- [ ] Tag release in git (`git tag v0.1.0`)
- [ ] Publish release notes on GitHub

---

*Cross-reference with [RUNBOOK.md](RUNBOOK.md) for ongoing operational procedures.*
