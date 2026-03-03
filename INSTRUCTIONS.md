# Full-Stack Engineer — Take-Home Assignment

## Overview

Build a **Multi-Channel Reporting Dashboard** — a Next.js application that provides a reporting function for a multi-tenant platform. Each organization has connected ad accounts (Meta, Google) and a store. Your job is to build the reporting logic that aggregates data from these sources, expose it via an API endpoint, and render a simple dashboard.

The core deliverable is a **reusable reporting function** that:
1. Is called **directly** in a server component to render the initial dashboard (server-side)
2. Is also exposed through a **REST API endpoint** so it can be consumed by client-side components or external clients

The task is designed to take around **three to four hours** to complete.
In your next interview, you'll review your solution together with the interviewer.

---

## Tools & Technologies

| Layer | Technology |
|-------|-----------|
| Framework | **Next.js** (App Router, API Routes) — already set up |
| Language | **TypeScript** |
| Database | **PostgreSQL** |
| ORM | Optional (Prisma, Drizzle, TypeORM, or raw SQL — your choice) |
| UI | **shadcn/ui** is pre-installed, or use plain CSS/Tailwind |

---

## Database

The schema and seed data are provided in `database/seed.sql`. Run this file against your PostgreSQL database to create and populate all tables.

```bash
psql -U your_user -d your_database -f database/seed.sql
```

The script creates the following tables:

### `organization`
| Column | Type | Notes |
|--------|------|-------|
| id | integer, PK, auto-increment | |
| name | string | |
| meta_account_id | string | The linked Meta Ads account identifier |
| google_account_id | string | The linked Google Ads account identifier |
| store_id | string | The linked e-commerce store identifier |
| created_at | timestamp | |

### `meta_ads_data`
| Column | Type | Notes |
|--------|------|-------|
| id | integer, PK, auto-increment | |
| account_id | string | References the Meta account |
| date | date | Reporting date |
| spend | decimal(12,2) | Amount spent in USD |
| impressions | integer | Number of ad impressions |

### `google_ads_data`
| Column | Type | Notes |
|--------|------|-------|
| id | integer, PK, auto-increment | |
| account_id | string | References the Google account |
| date | date | Reporting date |
| spend | decimal(12,2) | Amount spent in USD |
| impressions | integer | Number of ad impressions |

### `store_data`
| Column | Type | Notes |
|--------|------|-------|
| id | integer, PK, auto-increment | |
| store_id | string | References the store |
| date | date | Order date |
| revenue | decimal(12,2) | Total revenue |
| orders | integer | Number of orders |
| fees | decimal(12,2) | Platform/transaction fees |

The seed data includes **2 organizations** with **30 days** of daily data across all three data sources.

---

## Available Metrics

Each data source provides **raw metrics**. Some metrics are **calculated** from raw values, and some are **derived** by combining data from multiple sources.

### Raw Metrics (stored in DB)

| Source | Metrics |
|--------|---------|
| Meta Ads | `meta_spend`, `meta_impressions` |
| Google Ads | `google_spend`, `google_impressions` |
| Store | `revenue`, `orders`, `fees` |

### Calculated Metrics

| Metric | Formula |
|--------|---------|
| `meta_cpm` | (meta_spend / meta_impressions) × 1000 |
| `google_cpm` | (google_spend / google_impressions) × 1000 |
| `average_order_value` | revenue / orders |

### Derived Metrics

| Metric | Formula |
|--------|---------|
| `total_spend` | meta_spend + google_spend |
| `profit` | revenue − meta_spend − google_spend − fees |
| `roas` | revenue / total_spend |

---

## Reporting Function

Build a reporting function that accepts:

```typescript
{
  orgId: number;
  startDate: string;   // "YYYY-MM-DD"
  endDate: string;     // "YYYY-MM-DD"
  metrics: string[];   // e.g. ["revenue", "meta_spend", "profit"]
}
```

And returns both **totals** (aggregated over the full date range) and a **daily breakdown** (one row per day with the requested metrics):

```json
{
  "totals": {
    "revenue": 45000.00,
    "meta_spend": 12000.00,
    "profit": 18500.00
  },
  "daily": [
    { "date": "2025-01-01", "revenue": 1500.00, "meta_spend": 400.00, "profit": 620.00 },
    { "date": "2025-01-02", "revenue": 1320.00, "meta_spend": 380.00, "profit": 510.00 }
  ]
}
```

The function should only return the metrics that were requested.

---

## API Endpoint

### `GET /api/reporting`

Expose the reporting function as a REST endpoint.

Query parameters:
- `orgId` (required) — The organization ID
- `startDate` (required) — Start of the date range (YYYY-MM-DD)
- `endDate` (required) — End of the date range (YYYY-MM-DD)
- `metrics` (required) — Comma-separated list of metric keys (e.g., `metrics=revenue,meta_spend,profit`)

---

## Dashboard UI

### Initial Load (Server-Side)
When the page (`/`) loads, it should render data **on the server** by calling the reporting function directly (not via HTTP). Use default values for the date range and metrics so the user sees data immediately on first load.

### Interactive Controls (Client-Side)

The page should include interactive controls that allow the user to:
- **Select a date range** — Two date inputs (start date and end date)
- **Choose metrics** — Pick which metrics to display

When the user changes the controls, fetch updated data from the `/api/reporting` endpoint and re-render.

### Data Display
1. **Metric cards** — Show the `totals` for each selected metric (e.g., a card for "Revenue: $45,000", a card for "Profit: $18,500")
2. **Daily breakdown table** — A simple table showing one row per day with columns for each selected metric

Keep the UI clean and functional. We value usability over design polish.

---

## Deliverables

Push your solution to this repository. Make sure to include:
- Full source code
- Updated **README.md** with:
  - How to set up the database and run the seed
  - How to install dependencies and start the application
  - Brief explanation of your architecture and key decisions

---

Good luck! We look forward to reviewing your solution.
