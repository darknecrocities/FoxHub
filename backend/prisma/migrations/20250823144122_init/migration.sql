/*
  Warnings:

  - A unique constraint covering the columns `[date]` on the table `ApiUsage` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "ApiUsage_date_key" ON "ApiUsage"("date");
