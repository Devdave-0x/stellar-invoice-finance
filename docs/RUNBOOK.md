# Kora Protocol — Operations Runbook

This runbook covers day-to-day operational procedures for teams running Kora Protocol deployments on Stellar testnet or mainnet.

---

## 1. Health Checks

### 1.1 Quick health check

```bash
./scripts/health-check.sh
```

This script pings each deployed contract and verifies that it returns expected storage entries. A non-zero exit code means one or more contracts are unreachable or in an unexpected state.

### 1.2 State drift detection

```bash
./scripts/check_state_drift.sh
```

Compares on-chain contract state against the last known snapshot stored in `contracts.env.example`. Useful after an upgrade or incident.

### 1.3 Manual contract inspection

```bash
stellar contract read \
  --network testnet \
  --id <CONTRACT_ID> \
  --key <STORAGE_KEY>
```

---

## 2. Pausing the Protocol

The `access_control` contract exposes a `pause` entry point. Only the designated `PauseAdmin` role may call it.

```bash
stellar contract invoke \
  --network testnet \
  --id <ACCESS_CONTROL_CONTRACT_ID> \
  --source <PAUSE_ADMIN_SECRET_KEY> \
  -- pause
```

Verify the paused state:

```bash
stellar contract read \
  --network testnet \
  --id <ACCESS_CONTROL_CONTRACT_ID> \
  --key PAUSED
```

To unpause, call `unpause` with the same admin key.

> **Note:** Pausing blocks all state-mutating calls in marketplace, financing pool, invoice NFT, and treasury. Read-only queries continue to work.

---

## 3. Emergency Fund Recovery

If an exploit is detected, follow the [Incident Response Plan](INCIDENT_RESPONSE.md) first. For authorized emergency drains:

```bash
stellar contract invoke \
  --network testnet \
  --id <TREASURY_CONTRACT_ID> \
  --source <SUPER_ADMIN_SECRET_KEY> \
  -- emergency_drain \
  --recipient <SAFE_MULTISIG_ADDRESS>
```

This call requires the `SuperAdmin` role and should only be executed after the protocol is paused.

---

## 4. Fee Parameter Updates

Fee rates are stored in the marketplace contract. Changes take effect immediately on the next `fund_invoice` call.

```bash
stellar contract invoke \
  --network testnet \
  --id <MARKETPLACE_CONTRACT_ID> \
  --source <ADMIN_SECRET_KEY> \
  -- set_fee_rate \
  --fee_bps <NEW_FEE_IN_BASIS_POINTS>
```

Example: 50 basis points = 0.5 % protocol fee.

---

## 5. TTL Management

Soroban storage entries expire. The keeper script renews TTL for all active contracts:

```bash
./scripts/ttl_keeper.sh
```

Run this at least once per week, or set it up as a cron job:

```
0 0 * * 1 /path/to/repo/scripts/ttl_keeper.sh >> /var/log/kora-ttl.log 2>&1
```

---

## 6. Adding a New Verifier to the Risk Registry

```bash
stellar contract invoke \
  --network testnet \
  --id <RISK_REGISTRY_CONTRACT_ID> \
  --source <ADMIN_SECRET_KEY> \
  -- add_verifier \
  --verifier <NEW_VERIFIER_ADDRESS>
```

Verifiers can then call `submit_score` to update debtor risk scores.

---

## 7. Diagnosing Transaction Failures

```bash
./scripts/diagnose.sh <TRANSACTION_HASH>
```

This script decodes the transaction result XDR and maps error codes to their human-readable variants from `contracts/shared/src/errors.rs`.

Common errors:

| Code | Name | Likely Cause |
|------|------|--------------|
| 1    | Unauthorized | Caller lacks required role |
| 2    | AlreadyInitialized | Contract `init` called twice |
| 10   | InvoiceNotFound | Wrong invoice ID |
| 20   | InsufficientFunds | Investor balance too low |
| 30   | FundingDeadlinePassed | Listing expired |

See `contracts/shared/src/errors.rs` for the full error table.

---

## 8. Rollback Procedure

Kora v0.1.0 does not support in-place contract upgrades. A rollback requires redeploying the previous Wasm and migrating state. Until the upgrade mechanism lands in v0.2.0, the recommended rollback is:

1. Pause the protocol (section 2).
2. Deploy the previous Wasm to a new contract address.
3. Update the address registry in `contracts.env.example`.
4. Migrate or replay state using the SDK scripts in `sdk/`.
5. Announce the new addresses to integrators.

---

*For incidents, refer to [INCIDENT_RESPONSE.md](INCIDENT_RESPONSE.md). For security vulnerabilities, follow [SECURITY.md](../SECURITY.md).*
