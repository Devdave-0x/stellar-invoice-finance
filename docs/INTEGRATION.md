# Integration Guide

This guide explains how to integrate Stellar Invoice Finance into your application using the TypeScript SDK.

## Prerequisites

- Node.js 18+
- A Stellar account funded on testnet
- Freighter wallet (for browser integrations)

## Installation

```bash
npm install @kora/sdk
```

## Initialising the SDK Clients

```typescript
import {
  InvoiceNftClient,
  MarketplaceClient,
  FinancingPoolClient,
  PriceOracleClient,
} from "@kora/sdk";
import { Networks, Keypair } from "@stellar/stellar-sdk";

const network = Networks.TESTNET;
const rpcUrl = "https://soroban-testnet.stellar.org";

const invoiceNft = new InvoiceNftClient({ network, rpcUrl });
const marketplace = new MarketplaceClient({ network, rpcUrl });
const pool = new FinancingPoolClient({ network, rpcUrl });
const oracle = new PriceOracleClient({ network, rpcUrl });
```

## Tokenising an Invoice

```typescript
const result = await invoiceNft.mintInvoice({
  issuer: sellerKeypair.publicKey(),
  buyer: buyerAddress,
  amount: 50_000_000n, // 50 USDC (7 decimals)
  dueDate: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30, // 30 days
  ipfsMetadataHash: "bafybeig...",
});

console.log("Invoice NFT ID:", result.invoiceId);
```

## Listing on the Marketplace

```typescript
await marketplace.listInvoice({
  invoiceId: result.invoiceId,
  discountRate: 500, // 5% discount (basis points)
});
```

## Funding an Invoice (Liquidity Provider)

```typescript
await pool.fundInvoice({
  invoiceId: result.invoiceId,
  funder: lpKeypair.publicKey(),
});
```

## Querying the Price Oracle

```typescript
const price = await oracle.getPrice({ asset: "USDC" });
console.log("USDC/XLM price:", price);
```

## Error Handling

All SDK calls throw typed `KoraError` instances on failure:

```typescript
import { KoraError, KoraErrorCode } from "@kora/sdk";

try {
  await marketplace.listInvoice({ ... });
} catch (err) {
  if (err instanceof KoraError) {
    switch (err.code) {
      case KoraErrorCode.Unauthorized:
        console.error("Signer not authorised");
        break;
      case KoraErrorCode.InvoiceAlreadyFunded:
        console.error("Invoice already taken");
        break;
      default:
        console.error("Contract error:", err.message);
    }
  }
}
```

## Further Reading

- [Contract Architecture](ARCHITECTURE.md)
- [Access Control Model](access-control.md)
- [Event Reference](EVENTS.md)
- [Security Policy](SECURITY.md)
