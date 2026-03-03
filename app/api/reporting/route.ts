import { NextRequest, NextResponse } from "next/server";
import { getReport } from "@/lib/reporting";

export async function GET(request: NextRequest) {
  const searchParams = request.nextUrl.searchParams;

  const orgId = searchParams.get("orgId");
  const startDate = searchParams.get("startDate");
  const endDate = searchParams.get("endDate");
  const metricsParam = searchParams.get("metrics");

  // Validate required parameters
  if (!orgId || !startDate || !endDate || !metricsParam) {
    return NextResponse.json(
      {
        error:
          "Missing required parameters: orgId, startDate, endDate, metrics",
      },
      { status: 400 }
    );
  }

  const orgIdNum = parseInt(orgId, 10);
  if (isNaN(orgIdNum)) {
    return NextResponse.json(
      { error: "orgId must be a valid number" },
      { status: 400 }
    );
  }

  // Validate date format
  const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
  if (!dateRegex.test(startDate) || !dateRegex.test(endDate)) {
    return NextResponse.json(
      { error: "Dates must be in YYYY-MM-DD format" },
      { status: 400 }
    );
  }

  const metrics = metricsParam
    .split(",")
    .map((m) => m.trim())
    .filter(Boolean);

  if (metrics.length === 0) {
    return NextResponse.json(
      { error: "At least one metric is required" },
      { status: 400 }
    );
  }

  try {
    const result = await getReport({
      orgId: orgIdNum,
      startDate,
      endDate,
      metrics,
    });

    return NextResponse.json(result);
  } catch (error) {
    const message =
      error instanceof Error ? error.message : "Internal server error";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
