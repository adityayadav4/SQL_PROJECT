/*
Objective:
- Find the top 6 skills most requested in remote Data Analyst and Business Analyst postings.
- Count skill frequency across all postings by joining job and skill tables.
- Filter for remote-only roles for both job titles.

Business Value:
Highlights which core tools job seekers must know to maximize their chances in the remote analytics market.
*/

SELECT 
    skills,
    COUNT(skills_dim.skill_id) AS skills_count
FROM
    skills_dim
INNER JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE 
    job_title_short IN ('Data Analyst', 'Business Analyst') AND
    job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY
    skills_count DESC
LIMIT 6;