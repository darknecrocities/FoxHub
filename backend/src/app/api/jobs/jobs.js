import type { NextApiRequest, NextApiResponse } from "next";
import prisma from "../../lib/db"; // adjust path if needed

const ADZUNA_APP_ID = process.env.ADZUNA_APP_ID;
const ADZUNA_APP_KEY = process.env.ADZUNA_APP_KEY;
const MAX_CALLS_PER_DAY = 50;

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const today = new Date().toISOString().slice(0, 10);

  try {
    let usage = await prisma.apiUsage.findUnique({
      where: { date: today },
    });

    if (usage && usage.count >= MAX_CALLS_PER_DAY) {
      return res.status(429).json({ error: "Daily API limit reached" });
    }

    const { query = "developer", location = "" } = req.query;
    const url = `https://api.adzuna.com/v1/api/jobs/us/search/1?app_id=${ADZUNA_APP_ID}&app_key=${ADZUNA_APP_KEY}&results_per_page=20&what=${query}${location ? `&where=${location}` : ""}`;

    const response = await fetch(url);
    const data = await response.json();

    if (usage) {
      await prisma.apiUsage.update({
        where: { date: today },
        data: { count: { increment: 1 } },
      });
    } else {
      await prisma.apiUsage.create({
        data: { date: today, count: 1 },
      });
    }

    res.status(200).json(data.results);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
}
