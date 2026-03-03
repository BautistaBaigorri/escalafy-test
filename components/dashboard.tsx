"use client";

import { useState, useCallback, useEffect, useRef } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import {
  type ReportingResult,
  type Organization,
  METRIC_LABELS,
  METRIC_FORMAT,
} from "@/lib/metrics";

interface DashboardProps {
  initialData: ReportingResult;
  organizations: Organization[];
  defaultOrgId: number;
  defaultStartDate: string;
  defaultEndDate: string;
  defaultMetrics: string[];
  availableMetrics: string[];
}

function formatMetricValue(metric: string, value: number): string {
  const format = METRIC_FORMAT[metric] || "number";

  switch (format) {
    case "currency":
      return new Intl.NumberFormat("en-US", {
        style: "currency",
        currency: "USD",
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      }).format(value);
    case "number":
      return new Intl.NumberFormat("en-US").format(value);
    case "decimal":
      return new Intl.NumberFormat("en-US", {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      }).format(value);
    default:
      return String(value);
  }
}

export default function Dashboard({
  initialData,
  organizations,
  defaultOrgId,
  defaultStartDate,
  defaultEndDate,
  defaultMetrics,
  availableMetrics,
}: DashboardProps) {
  const [data, setData] = useState<ReportingResult>(initialData);
  const [orgId, setOrgId] = useState(String(defaultOrgId));
  const [startDate, setStartDate] = useState(defaultStartDate);
  const [endDate, setEndDate] = useState(defaultEndDate);
  const [selectedMetrics, setSelectedMetrics] =
    useState<string[]>(defaultMetrics);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const isFirstRender = useRef(true);

  const fetchData = useCallback(async (
    currentOrgId: string,
    currentStartDate: string,
    currentEndDate: string,
    currentMetrics: string[]
  ) => {
    if (currentMetrics.length === 0) {
      setError("Seleccioná al menos una métrica");
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const params = new URLSearchParams({
        orgId: currentOrgId,
        startDate: currentStartDate,
        endDate: currentEndDate,
        metrics: currentMetrics.join(","),
      });

      const res = await fetch(`/api/reporting?${params}`);
      const json = await res.json();

      if (!res.ok) {
        throw new Error(json.error || "Error al obtener datos");
      }

      setData(json);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Ocurrió un error");
    } finally {
      setLoading(false);
    }
  }, []);

  // Auto-fetch cuando cambian los controles (skip primer render, ya tiene datos SSR)
  useEffect(() => {
    if (isFirstRender.current) {
      isFirstRender.current = false;
      return;
    }
    fetchData(orgId, startDate, endDate, selectedMetrics);
  }, [orgId, startDate, endDate, selectedMetrics, fetchData]);

  const toggleMetric = (metric: string) => {
    setSelectedMetrics((prev) =>
      prev.includes(metric)
        ? prev.filter((m) => m !== metric)
        : [...prev, metric]
    );
  };

  const metricGroups = [
    {
      label: "Meta Ads",
      metrics: ["meta_spend", "meta_impressions", "meta_cpm"],
    },
    {
      label: "Google Ads",
      metrics: ["google_spend", "google_impressions", "google_cpm"],
    },
    {
      label: "Tienda",
      metrics: ["revenue", "orders", "fees", "average_order_value"],
    },
    {
      label: "Combinadas",
      metrics: ["total_spend", "profit", "roas"],
    },
  ];

  return (
    <div className="space-y-6">
      {/* Controls */}
      <Card>
        <CardHeader>
          <CardTitle>Filtros</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          {/* Organization & Date Range */}
          <div className="flex flex-wrap gap-4 items-end">
            <div className="space-y-1.5">
              <Label>Organización</Label>
              <Select value={orgId} onValueChange={setOrgId}>
                <SelectTrigger className="w-[200px]">
                  <SelectValue placeholder="Seleccionar organización" />
                </SelectTrigger>
                <SelectContent>
                  {organizations.map((org) => (
                    <SelectItem key={org.id} value={String(org.id)}>
                      {org.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-1.5">
              <Label>Fecha Inicio</Label>
              <Input
                type="date"
                value={startDate}
                onChange={(e) => setStartDate(e.target.value)}
                className="w-[160px]"
              />
            </div>

            <div className="space-y-1.5">
              <Label>Fecha Fin</Label>
              <Input
                type="date"
                value={endDate}
                onChange={(e) => setEndDate(e.target.value)}
                className="w-[160px]"
              />
            </div>

            {loading && (
              <span className="text-sm text-muted-foreground animate-pulse">
                Cargando...
              </span>
            )}
          </div>

          {/* Metric Selection */}
          <div className="space-y-3">
            <Label>Métricas</Label>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
              {metricGroups.map((group) => (
                <div key={group.label} className="space-y-2">
                  <span className="text-xs font-medium text-muted-foreground uppercase tracking-wider">
                    {group.label}
                  </span>
                  <div className="space-y-1.5">
                    {group.metrics.map((metric) => (
                      <div key={metric} className="flex items-center gap-2">
                        <Checkbox
                          id={metric}
                          checked={selectedMetrics.includes(metric)}
                          onCheckedChange={() => toggleMetric(metric)}
                        />
                        <Label htmlFor={metric} className="text-sm font-normal cursor-pointer">
                          {METRIC_LABELS[metric] || metric}
                        </Label>
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </CardContent>
      </Card>

      {error && (
        <div className="rounded-md bg-destructive/10 border border-destructive/20 p-4 text-sm text-destructive">
          {error}
        </div>
      )}

      {/* Metric Cards (Totals) */}
      {selectedMetrics.length > 0 && (
        <div>
          <h2 className="text-lg font-semibold mb-3">Totales</h2>
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
            {selectedMetrics.map((metric) => (
              <Card key={metric}>
                <CardHeader className="pb-2">
                  <CardTitle className="text-sm font-medium text-muted-foreground">
                    {METRIC_LABELS[metric] || metric}
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <p className="text-2xl font-bold">
                    {data.totals[metric] !== undefined
                      ? formatMetricValue(metric, data.totals[metric])
                      : "—"}
                  </p>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      )}

      {/* Daily Breakdown Table */}
      {selectedMetrics.length > 0 && data.daily.length > 0 && (
        <div>
          <div className="flex items-center gap-3 mb-3">
            <h2 className="text-lg font-semibold">Desglose Diario</h2>
            <Badge variant="secondary">{data.daily.length} días</Badge>
          </div>
          <Card>
            <CardContent className="p-0">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Fecha</TableHead>
                    {selectedMetrics.map((metric) => (
                      <TableHead key={metric} className="text-right">
                        {METRIC_LABELS[metric] || metric}
                      </TableHead>
                    ))}
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {data.daily.map((row) => (
                    <TableRow key={String(row.date)}>
                      <TableCell className="font-medium">
                        {String(row.date)}
                      </TableCell>
                      {selectedMetrics.map((metric) => (
                        <TableCell key={metric} className="text-right">
                          {row[metric] !== undefined
                            ? formatMetricValue(metric, Number(row[metric]))
                            : "—"}
                        </TableCell>
                      ))}
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </div>
      )}
    </div>
  );
}
