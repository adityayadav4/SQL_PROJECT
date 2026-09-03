/*
Objective:
- Find the top-paying skills for Data Analyst roles based on average annual salary.
- Join job postings with skills and calculate the average salary per skill.
- Filter for postings with reported salaries across all locations.

Business Value:
Shows which tools and technologies command the highest pay, helping analysts target the most financially rewarding skills.
*/

SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS salary_based_on_skills
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    salary_year_avg IS NOT NULL AND 
    job_title_short IN ('Data Analyst', 'Business Analyst') AND
    job_work_from_home = TRUE
GROUP BY
    skills
HAVING
    COUNT(skills_dim.skill_id) > 50
ORDER BY
    salary_based_on_skills DESC
LIMIT 20;
