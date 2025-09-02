import prisma from "../lib/db";

const APP_ID = "4e8b8448";
const APP_KEY = "216a175e0c703586e158f0ab7cc08bb1";

export async function fetchJobsFromAdzuna(query: string = "developer") {
  const url = `https://api.adzuna.com/v1/api/jobs/us/search/1?app_id=${APP_ID}&app_key=${APP_KEY}&results_per_page=20&what=${query}`;

  const res = await fetch(url);
  if (!res.ok) throw new Error("Failed to fetch jobs");

  const data = await res.json();

  // Save results in DB
  for (const job of data.results) {
    await prisma.job.create({
      data: {
        title: job.title || "N/A",
        company: job.company?.display_name || "N/A",
        location: job.location?.display_name || "N/A",
        contractType: job.contract_type || "N/A",
        salary: job.salary_min && job.salary_max
          ? `${job.salary_min} - ${job.salary_max} per year`
          : "N/A",
        description: job.description || "No description available",
      },
    });
  }

  return data.results;
}

export async function getJobs(query: string = "developer") {
  // Check cache (last 24 hours)
  const oneDayAgo = new Date();
  oneDayAgo.setDate(oneDayAgo.getDate() - 1);

  const cachedJobs = await prisma.job.findMany({
    where: { createdAt: { gte: oneDayAgo } },
    take: 20,
  });

  if (cachedJobs.length > 0) {
    return cachedJobs;
  }

  // If no cache → fetch from Adzuna
  return await fetchJobsFromAdzuna(query);
}
