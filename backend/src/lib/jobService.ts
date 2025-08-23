import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

export async function getJobs(query: string = "developer") {
  // Fetch all jobs and filter manually (case-insensitive)
  const jobs = await prisma.job.findMany();
  const filteredJobs = jobs.filter(job =>
    job.title.toLowerCase().includes(query.toLowerCase())
  );
  return filteredJobs;
}
