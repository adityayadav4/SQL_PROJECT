/*
Question: What are the most optimal skills to learn (high-demand AND high-paying)?
- Identify skills in high demand associated with high average salaries for Data & Business Analysts.
- Concentrate on remote positions with specified salaries.
- Why? Targets skills that offer high financial value and job security, optimizing learning priority.
*/

-- Approach 1: Common Table Expressions (CTEs)

WITH top_skills AS(
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(job_postings_fact.job_id) AS skill_count
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short IN ('Data Analyst', 'Business Analyst')
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
)   , top_paying_skills AS(
    SELECT
        skills_dim.skill_id,
        ROUND (AVG(salary_year_avg),0) AS avg_salary
    FROM 
        job_postings_fact 
    INNER JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        salary_year_avg IS NOT NULL AND
        job_title_short IN ('Data Analyst', 'Business Analyst')
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
)

SELECT
    top_skills.skill_id,
    top_skills.skills,
    top_skills.skill_count,
    avg_salary
FROM
    top_skills
INNER JOIN 
    top_paying_skills  ON top_skills.skill_id = top_paying_skills.skill_id
WHERE
    skill_count > 10
ORDER BY
     avg_salary DESC,
    skill_count DESC
   
LIMIT 25;


-- Approach 2: Consolidated Direct Join (Query Optimization)

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS skill_count,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short IN ('Data Analyst', 'Business Analyst')
    AND job_work_from_home = TRUE
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(job_postings_fact.job_id) > 10
ORDER BY
    avg_salary DESC,
    skill_count DESC
LIMIT 25;
