import { NextResponse } from "next/server";
import { getJobs } from "../../../services/adzunaService";

export async function GET(req: Request) {
  const { searchParams } = new URL(req.url);
  const query = searchParams.get("query") || "developer";

  try {
    const jobs = await getJobs(query);
    return NextResponse.json(jobs);
  } catch (error) {
    // Type-safe way to handle unknown error
    const message = error instanceof Error ? error.message : "Internal Server Error";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
