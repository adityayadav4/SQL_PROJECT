/*
Objective:
- Identify the top 10 highest-paying remote Data Analyst jobs.
- Filter out those where salary is NULL.
- Surface key context: exact role titles, hiring companies, and posting dates.

Business Value:
Highlights top-tier salaries and identifies which employers 
are offering premier remote analytics opportunities.
*/

SELECT
    job_id,
    job_title,
    job_location,
    name AS company_name,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_work_from_home = TRUE AND
    salary_year_avg IS NOT NULL AND
    job_title_short IN ('Data Analyst', 'Business Analyst')
ORDER BY 
    salary_year_avg DESC
LIMIT 10;
