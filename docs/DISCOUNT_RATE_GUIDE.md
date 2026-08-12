# Kora Protocol — Discount Rate Guide

This guide explains how discount rates work in Kora Protocol, how the risk registry informs rate suggestions, and how SMEs and investors can reason about pricing.

---

## What Is a Discount Rate?

When an SME lists an invoice on the Kora marketplace, they choose an **asking price** that is lower than the invoice's **face value**. The percentage difference is the discount rate:

```
Discount Rate = (Face Value − Asking Price) / Face Value × 100
```

**Example:**

| Field | Value |
|-------|-------|
| Face value | 10,000 USDC |
| Asking price | 9,500 USDC |
| Discount | 500 USDC |
| Discount rate | 5 % |
| Investor yield | 5.26 % (500 / 9,500) |

The SME receives the asking price (less the protocol fee) immediately. The investor earns the spread when the SME repays the face value.

---

## How Risk Scores Influence Rates

The `risk_registry` contract stores a **debtor score** (0–100) for each debtor hash. Higher scores indicate lower credit risk.

Suggested discount rate bands by risk tier:

| Risk Tier | Debtor Score | Suggested Discount Range |
|-----------|-------------|--------------------------|
| Low | 80–100 | 2 % – 4 % |
| Medium | 55–79 | 4 % – 8 % |
| High | 30–54 | 8 % – 15 % |
| Critical | 0–29 | 15 % + (or reject) |

These are **suggestions only**. The SME sets the final asking price. Market forces (liquidity, investor appetite, tenor) also affect what actually gets funded.

---

## Tenor and Annualised Yield

Invoice tenor (time to due date) matters. A 5 % discount on a 30-day invoice is very different from the same discount on a 90-day invoice:

```
Annualised Yield ≈ Discount Rate / Tenor (days) × 365
```

| Tenor | Discount | Annualised Yield |
|-------|----------|-----------------|
| 30 days | 2 % | ~24.3 % |
| 60 days | 3 % | ~18.2 % |
| 90 days | 5 % | ~20.3 % |
| 120 days | 7 % | ~21.3 % |

Shorter tenors with moderate discounts can deliver competitive annualised yields relative to traditional fixed income.

---

## Protocol Fee Impact

The marketplace charges a fee (in basis points) on each investor contribution. The fee reduces the net proceeds to the SME and is sent to the treasury.

**Net proceeds to SME:**

```
Net Proceeds = Asking Price × (1 − Fee / 10_000)
```

**Example at 50 bps (0.5 %) fee:**

| Field | Value |
|-------|-------|
| Asking price | 9,500 USDC |
| Protocol fee (50 bps) | 47.5 USDC |
| Net to SME | 9,452.5 USDC |
| Effective cost | 5.47 % discount |

SMEs should account for the protocol fee when choosing their asking price.

---

## Investor Yield Calculation

Each investor's yield is proportional to their contribution:

```
Investor Yield = (Face Value − Asking Price) × (Contribution / Asking Price)
```

**Example (two investors):**

| Investor | Contribution | Share | Face Value Received | Yield |
|----------|-------------|-------|---------------------|-------|
| A | 5,700 USDC | 60 % | 6,000 USDC | 300 USDC |
| B | 3,800 USDC | 40 % | 4,000 USDC | 200 USDC |
| Total | 9,500 USDC | 100 % | 10,000 USDC | 500 USDC |

---

## Default Risk

If the SME defaults, investors bear a loss proportional to their contribution. The risk registry's debtor score should be treated as one signal among many — not a guarantee of repayment. Always diversify across multiple invoices.

---

## Recommendations for SMEs

- Price invoices at a discount that reflects the debtor's creditworthiness and the invoice tenor.
- A discount that is too low may fail to attract investor funding before the deadline.
- A discount that is too high costs working capital unnecessarily.
- Monitor the debtor's risk score in the registry before listing.

## Recommendations for Investors

- Compare the annualised yield to the risk profile and tenor.
- Diversify across multiple invoices and debtors to reduce concentration risk.
- Check the debtor score before committing capital.
- Prefer invoices from debtors with a track record in the risk registry.
