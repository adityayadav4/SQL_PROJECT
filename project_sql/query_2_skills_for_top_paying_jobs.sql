/*
Objective:
- Map specific  skills required to the top 10 highest-paying remote Data Analyst jobs.
- Connect top-paying roles to skills through normalized bridge and dimension tables.
- Filter for postings with defined skill profiles.

Business Value:
Reveals which specific tools, platforms, and competencies command 
the highest compensation in the remote analytics market.
*/

WITH top_paying_jobs AS (
    SELECT
    job_id,
    job_title,
    name AS company_name,
    salary_year_avg
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_work_from_home = TRUE AND
    salary_year_avg IS NOT NULL AND
    job_title_short IN ('Data Analyst', 'Business Analyst')
ORDER BY
    salary_year_avg DESC
LIMIT 10
)
SELECT 
   top_paying_jobs.*,
   skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC;
