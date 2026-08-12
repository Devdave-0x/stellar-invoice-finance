# Kora Protocol — Contract Interaction Matrix

This table shows which contracts call each other and for what purpose. Use it to understand cross-contract dependencies and to plan upgrade ordering.

---

## Caller → Callee Matrix

| Caller | Calls | Purpose |
|--------|-------|---------|
| `marketplace` | `invoice_nft` | Read invoice data; update invoice status to `Listed` / `Funded` / `Defaulted` |
| `marketplace` | `financing_pool` | Transfer investor funds into the pool; trigger fund release to SME |
| `marketplace` | `treasury` | Transfer protocol fee on each investor contribution |
| `marketplace` | `access_control` | Check pause state before any state mutation |
| `marketplace` | `risk_registry` | Read debtor score to validate risk tier on listing |
| `financing_pool` | `invoice_nft` | Update invoice status to `Repaid` or `Defaulted` on repayment/default |
| `financing_pool` | `access_control` | Check pause state before repayment and default marking |
| `invoice_nft` | `access_control` | Check pause state before minting and status transitions |
| `risk_registry` | `access_control` | Check pause state before score updates |
| `treasury` | *(none)* | Treasury only receives tokens; no outbound contract calls |
| `access_control` | *(none)* | Access control only manages its own state |

---

## Dependency Graph

```
marketplace ──────────────────────────────────────────────────────────────────────┐
     │                                                                             │
     ├──► invoice_nft ──► access_control                                          │
     │                                                                             │
     ├──► financing_pool ──► invoice_nft                                           │
     │         │             access_control                                        │
     │         │                                                                   │
     │         └──► access_control                                                 │
     │                                                                             │
     ├──► treasury                                                                 │
     │                                                                             │
     ├──► access_control                                                           │
     │                                                                             │
     └──► risk_registry ──► access_control                                         │
```

**Root dependency:** `access_control` must be deployed first; all other contracts reference it at initialization.

**Deployment order:**
1. `access_control`
2. `invoice_nft`
3. `risk_registry`
4. `treasury`
5. `financing_pool`
6. `marketplace`

---

## Upgrade Considerations

When upgrading a contract, any contract that **calls** it may be affected. Use this matrix to determine which contracts need re-testing or re-initialization after an upgrade.

| Upgraded Contract | Re-test / Notify |
|-------------------|-----------------|
| `access_control` | All five other contracts |
| `invoice_nft` | `marketplace`, `financing_pool` |
| `financing_pool` | `marketplace` |
| `treasury` | `marketplace` |
| `risk_registry` | `marketplace` |
| `marketplace` | No callers (user-facing only) |

---

*See [ARCHITECTURE.md](ARCHITECTURE.md) for a higher-level system overview.*
