# Kora Protocol — Error Code Reference

When a Soroban transaction fails, the result XDR contains a numeric error code. This page maps those codes to their name and likely cause.

Error codes are defined in `contracts/shared/src/errors.rs` as the `KoraError` enum.

---

## Error Table

| Code | Name | Contract(s) | Description |
|------|------|-------------|-------------|
| 1 | `Unauthorized` | All | Caller does not have the required role or is not the expected address. |
| 2 | `AlreadyInitialized` | All | The contract's `initialize` entry point has already been called. |
| 3 | `NotInitialized` | All | A required contract dependency is not yet configured. |
| 4 | `Paused` | All | The protocol is paused. No state-mutating calls are allowed. |
| 10 | `InvoiceNotFound` | invoice_nft, marketplace, financing_pool | The given invoice ID does not exist. |
| 11 | `InvalidInvoiceStatus` | invoice_nft, marketplace | The invoice is in a status that does not permit this operation. |
| 12 | `InvoiceFrozen` | invoice_nft, marketplace, financing_pool | The invoice has been individually frozen by an admin. |
| 13 | `InvalidAmount` | invoice_nft, marketplace, financing_pool | Amount is zero or overflows. |
| 14 | `InvalidDueDate` | invoice_nft | Due date is in the past. |
| 15 | `InvalidRiskScore` | invoice_nft | Risk score is outside the 0–100 range. |
| 16 | `StringTooLong` | invoice_nft | A string field (e.g. IPFS CID) exceeds the maximum allowed length. |
| 17 | `BytesTooLong` | invoice_nft | A bytes field (e.g. debtor hash) exceeds the maximum allowed length. |
| 18 | `EmptyString` | invoice_nft | A required string field is empty. |
| 19 | `EmptyBytes` | invoice_nft | A required bytes field is empty. |
| 20 | `InsufficientFunds` | marketplace, financing_pool | Caller's token balance is less than the requested amount. |
| 21 | `ListingNotFound` | marketplace | The given invoice ID has no active listing. |
| 22 | `FundingDeadlinePassed` | marketplace | The listing's funding deadline has expired. |
| 23 | `AlreadyFullyFunded` | marketplace | The invoice is already 100 % funded; no more contributions accepted. |
| 24 | `FeeTooHigh` | marketplace | The configured fee in basis points exceeds the allowed maximum. |
| 25 | `TokenNotWhitelisted` | marketplace | The payment token is not on the marketplace whitelist. |
| 26 | `RefundAlreadyClaimed` | marketplace | The investor has already claimed their refund for this invoice. |
| 27 | `NothingToRefund` | marketplace | The invoice was successfully funded; no refund is owed. |
| 30 | `PositionNotFound` | financing_pool | The caller has no recorded position for this invoice. |
| 31 | `RepaymentTooLow` | financing_pool | The repayment amount is less than the outstanding face value. |
| 32 | `AlreadyRepaid` | financing_pool | The invoice has already been repaid. |
| 33 | `AlreadyDefaulted` | financing_pool | The invoice has already been marked as defaulted. |
| 40 | `VerifierNotFound` | risk_registry | The address is not a registered verifier. |
| 41 | `SMEProfileNotFound` | risk_registry | No SME profile exists for this address. |
| 42 | `DebtorScoreNotFound` | risk_registry | No debtor score exists for this hash. |
| 50 | `TreasuryEmpty` | treasury | No accumulated fees to withdraw. |
| 60 | `UpgradeNotProposed` | All | An upgrade was not proposed before calling `apply_upgrade`. |
| 61 | `UpgradeTimelockActive` | All | The required timelock period has not yet elapsed since the upgrade was proposed. |
| 70 | `ArithmeticOverflow` | shared | An arithmetic operation would overflow. |
| 80 | `MilestoneTooShort` | financing_pool | A milestone interval is below the minimum allowed duration. |
| 81 | `BatchTooLarge` | financing_pool, risk_registry | A batch operation exceeds the maximum allowed batch size. |
| 84 | `TooManyParticipants` | financing_pool | The number of investors in a single invoice exceeds the cap. |

---

## Decoding Errors in Practice

When a `stellar contract invoke` call fails, the CLI prints an XDR-encoded `ScError`. Use the `diagnose.sh` script to decode it:

```bash
./scripts/diagnose.sh <TRANSACTION_HASH>
```

Or decode manually:

```bash
stellar tx result <TRANSACTION_HASH> --network testnet | stellar xdr decode --type TransactionResult
```

The `result_code` field maps to the `KoraError` code above.

---

## Handling Errors in the SDK

```typescript
import { KoraError } from "@kora-protocol/sdk";

try {
  await marketplace.fundInvoice({ invoiceId: 1n, amount: 500_000_000n });
} catch (err) {
  if (err instanceof KoraError) {
    switch (err.code) {
      case 22: // FundingDeadlinePassed
        console.error("Too late — the funding window has closed.");
        break;
      case 23: // AlreadyFullyFunded
        console.error("Invoice is already fully funded.");
        break;
      default:
        console.error(`Unexpected error code: ${err.code}`);
    }
  }
}
```

---

*Error codes match `contracts/shared/src/errors.rs`. If you see a code not listed here, check that file for recent additions.*
