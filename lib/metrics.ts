export interface ReportingParams {
  orgId: number;
  startDate: string; // "YYYY-MM-DD"
  endDate: string; // "YYYY-MM-DD"
  metrics: string[];
}

export interface ReportingResult {
  totals: Record<string, number>;
  daily: Array<Record<string, string | number>>;
}

export interface Organization {
  id: number;
  name: string;
}

export const ALL_METRICS = [
  "meta_spend",
  "meta_impressions",
  "google_spend",
  "google_impressions",
  "revenue",
  "orders",
  "fees",
  "meta_cpm",
  "google_cpm",
  "average_order_value",
  "total_spend",
  "profit",
  "roas",
] as const;

export type MetricName = (typeof ALL_METRICS)[number];

export const METRIC_LABELS: Record<string, string> = {
  meta_spend: "Gasto Meta",
  meta_impressions: "Impresiones Meta",
  google_spend: "Gasto Google",
  google_impressions: "Impresiones Google",
  revenue: "Ingresos",
  orders: "Órdenes",
  fees: "Comisiones",
  meta_cpm: "CPM Meta",
  google_cpm: "CPM Google",
  average_order_value: "Valor Promedio de Orden",
  total_spend: "Gasto Total",
  profit: "Ganancia",
  roas: "ROAS",
};

export const METRIC_FORMAT: Record<string, "currency" | "number" | "decimal"> =
  {
    meta_spend: "currency",
    meta_impressions: "number",
    google_spend: "currency",
    google_impressions: "number",
    revenue: "currency",
    orders: "number",
    fees: "currency",
    meta_cpm: "currency",
    google_cpm: "currency",
    average_order_value: "currency",
    total_spend: "currency",
    profit: "currency",
    roas: "decimal",
  };
