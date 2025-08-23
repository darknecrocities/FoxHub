import type { NextApiRequest, NextApiResponse } from "next";
import { getJobs } from "../../lib/jobService";

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const { query = "developer" } = req.query;

  try {
    const jobs = await getJobs(query as string);
    res.status(200).json(jobs);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
}
