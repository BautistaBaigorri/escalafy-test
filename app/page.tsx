export const dynamic = "force-dynamic";

import Image from "next/image";
import Dashboard from "@/components/dashboard";
import {
  getReport,
  getOrganizations,
  getAvailableMetrics,
} from "@/lib/reporting";

function getDefaultDates() {
  const end = new Date();
  const start = new Date();
  start.setDate(start.getDate() - 30);

  const format = (d: Date) => d.toISOString().split("T")[0];
  return { startDate: format(start), endDate: format(end) };
}

const DEFAULT_METRICS = [
  "revenue",
  "total_spend",
  "profit",
  "roas",
  "orders",
];

export default async function Home() {
  const { startDate, endDate } = getDefaultDates();
  const defaultOrgId = 1;

  const [initialData, organizations] = await Promise.all([
    getReport({
      orgId: defaultOrgId,
      startDate,
      endDate,
      metrics: DEFAULT_METRICS,
    }),
    getOrganizations(),
  ]);

  const availableMetrics = getAvailableMetrics();

  return (
    <div className="min-h-screen bg-background">
      <header className="border-b">
        <div className="container mx-auto px-4 py-4 flex items-center gap-3">
          <Image
            src="/escalafy.png"
            alt="Escalafy"
            width={32}
            height={32}
            className="rounded"
          />
          <h1 className="text-xl font-semibold tracking-tight">
            Dashboard de Reporting Multi-Canal
          </h1>
        </div>
      </header>

      <main className="container mx-auto px-4 py-6">
        <Dashboard
          initialData={initialData}
          organizations={organizations}
          defaultOrgId={defaultOrgId}
          defaultStartDate={startDate}
          defaultEndDate={endDate}
          defaultMetrics={DEFAULT_METRICS}
          availableMetrics={availableMetrics}
        />
      </main>
    </div>
  );
}
