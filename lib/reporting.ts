import pool from "./db";
import {
  type ReportingParams,
  type ReportingResult,
  type Organization,
  ALL_METRICS,
} from "./metrics";

export type { ReportingParams, ReportingResult, Organization };

export function getAvailableMetrics(): string[] {
  return [...ALL_METRICS];
}

function safeDiv(numerator: number, denominator: number): number {
  if (denominator === 0) return 0;
  return numerator / denominator;
}

interface RawRow {
  date: string;
  meta_spend: number;
  meta_impressions: number;
  google_spend: number;
  google_impressions: number;
  revenue: number;
  orders: number;
  fees: number;
}

function computeMetrics(
  raw: RawRow,
  requestedMetrics: string[]
): Record<string, number> {
  const result: Record<string, number> = {};

  const computed: Record<string, () => number> = {
    meta_spend: () => raw.meta_spend,
    meta_impressions: () => raw.meta_impressions,
    google_spend: () => raw.google_spend,
    google_impressions: () => raw.google_impressions,
    revenue: () => raw.revenue,
    orders: () => raw.orders,
    fees: () => raw.fees,
    meta_cpm: () => safeDiv(raw.meta_spend, raw.meta_impressions) * 1000,
    google_cpm: () => safeDiv(raw.google_spend, raw.google_impressions) * 1000,
    average_order_value: () => safeDiv(raw.revenue, raw.orders),
    total_spend: () => raw.meta_spend + raw.google_spend,
    profit: () =>
      raw.revenue - raw.meta_spend - raw.google_spend - raw.fees,
    roas: () => safeDiv(raw.revenue, raw.meta_spend + raw.google_spend),
  };

  for (const metric of requestedMetrics) {
    if (computed[metric]) {
      result[metric] = Math.round(computed[metric]() * 100) / 100;
    }
  }

  return result;
}

export async function getReport(
  params: ReportingParams
): Promise<ReportingResult> {
  const { orgId, startDate, endDate, metrics } = params;

  // Get organization details
  const orgResult = await pool.query(
    "SELECT meta_account_id, google_account_id, store_id FROM organization WHERE id = $1",
    [orgId]
  );

  if (orgResult.rows.length === 0) {
    throw new Error(`Organization with id ${orgId} not found`);
  }

  const org = orgResult.rows[0];

  // Query all raw data joined by date using generate_series
  const dataResult = await pool.query(
    `SELECT
      d.date::text as date,
      COALESCE(m.spend, 0)::float as meta_spend,
      COALESCE(m.impressions, 0)::int as meta_impressions,
      COALESCE(g.spend, 0)::float as google_spend,
      COALESCE(g.impressions, 0)::int as google_impressions,
      COALESCE(s.revenue, 0)::float as revenue,
      COALESCE(s.orders, 0)::int as orders,
      COALESCE(s.fees, 0)::float as fees
    FROM generate_series($1::date, $2::date, '1 day'::interval) AS d(date)
    LEFT JOIN meta_ads_data m ON m.date = d.date AND m.account_id = $3
    LEFT JOIN google_ads_data g ON g.date = d.date AND g.account_id = $4
    LEFT JOIN store_data s ON s.date = d.date AND s.store_id = $5
    ORDER BY d.date`,
    [startDate, endDate, org.meta_account_id, org.google_account_id, org.store_id]
  );

  // Compute daily metrics
  const daily: Array<Record<string, string | number>> = [];
  const rawTotals: RawRow = {
    date: "",
    meta_spend: 0,
    meta_impressions: 0,
    google_spend: 0,
    google_impressions: 0,
    revenue: 0,
    orders: 0,
    fees: 0,
  };

  for (const row of dataResult.rows) {
    const raw: RawRow = {
      date: row.date,
      meta_spend: parseFloat(row.meta_spend) || 0,
      meta_impressions: parseInt(row.meta_impressions) || 0,
      google_spend: parseFloat(row.google_spend) || 0,
      google_impressions: parseInt(row.google_impressions) || 0,
      revenue: parseFloat(row.revenue) || 0,
      orders: parseInt(row.orders) || 0,
      fees: parseFloat(row.fees) || 0,
    };

    // Accumulate totals from raw values
    rawTotals.meta_spend += raw.meta_spend;
    rawTotals.meta_impressions += raw.meta_impressions;
    rawTotals.google_spend += raw.google_spend;
    rawTotals.google_impressions += raw.google_impressions;
    rawTotals.revenue += raw.revenue;
    rawTotals.orders += raw.orders;
    rawTotals.fees += raw.fees;

    // Compute requested metrics for this day
    const dayMetrics = computeMetrics(raw, metrics);
    daily.push({ date: row.date, ...dayMetrics });
  }

  // Compute totals from aggregated raw values (not from averaging daily computed values)
  const totals = computeMetrics(rawTotals, metrics);

  return { totals, daily };
}

export async function getOrganizations(): Promise<Organization[]> {
  const result = await pool.query(
    "SELECT id, name FROM organization ORDER BY id"
  );
  return result.rows;
}
