# Introduction
Welcome to my SQL portfolio project! I built this repository to apply my database querying skills and demonstrate my ability to extract practical, real-world insights from raw data.

Using a massive job market dataset from 2023, this project serves as both a hands-on technical sandbox and a strategic guide for navigating the data analytics industry. All the SQL queries used to extract these insights are located in the [`project_sql folder`](/project_sql/) .

## Background
As I focus on transitioning fully into data analytics, I wanted to take a data-driven approach to my own skill development. Instead of guessing or relying on generic advice about what tools to learn next, I used this 2023 dataset to uncover the actual trends in salaries, remote work, and tool requirements.

**My goal was to establish a clear baseline of what makes a data analyst valuable and build a strategic learning roadmap. I structured my analysis around five key questions:**
1. What were the absolute highest-paying remote Data Analyst jobs in 2023?
2. What specific skills did those top-tier roles require?
3. Which foundational skills were requested most frequently across the entire market?
4. Which niche skills commanded the highest average salaries?
5. Where was the "sweet spot"—the optimal skills that offered both high job availability and high pay?

# Tools I Used
To analyze this dataset and build this project, I utilized the following stack:
- **SQL (PostgreSQL):** The core engine for my analysis. I used it to write complex queries, join multiple tables, and aggregate millions of rows of job posting data.
- **Visual Studio Code & pgAdmin:** My primary environments for database management and executing SQL scripts.
- **Git & GitHub:** For version control, organizing my code, and sharing my portfolio.

#  Analysis
### 1. Top Paying Jobs
**Goal:** Find the top 10 highest-paying remote roles available for Data Analysts and Business Analysts to see what the top end of the market actually pays.
- **Query File:** [`query_1_top_paying_jobs.sql`](project_sql/query_1_top_paying_jobs.sql)

```sql
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
```
| job_id | job_title | job_location | company_name | job_schedule_type | salary_year_avg | job_posted_date |
| :---: | :--- | :--- | :--- | :--- | ---: | :--- |
| 226942 | Data Analyst | Anywhere | Mantys | Full-time | $650,000 | 2023-02-20 15:13:33 |
| 547382 | Director of Analytics | Anywhere | Meta | Full-time | $336,500 | 2023-08-23 12:04:42 |
| 552322 | Associate Director- Data Insights | Anywhere | AT&T | Full-time | $255,829.50 | 2023-06-18 16:03:12 |
| 99305 | Data Analyst, Marketing | Anywhere | Pinterest Job Advertisements | Full-time | $232,423 | 2023-12-05 20:00:40 |
| 502610 | Lead Business Intelligence Engineer | Anywhere | Noom | Full-time | $220,000 | 2023-08-29 18:26:36 |
| 1021647 | Data Analyst (Hybrid/Remote) | Anywhere | Uclahealthcareers | Full-time | $217,000 | 2023-01-17 00:17:23 |
| 112859 | Manager II, Applied Science - Marketplace Dynamics | Anywhere | Uber | Full-time | $214,500 | 2023-12-18 08:02:37 |
| 168310 | Principal Data Analyst (Remote) | Anywhere | SmartAsset | Full-time | $205,000 | 2023-08-09 11:00:01 |
| 1069582 | Analyst | Anywhere | Multicoin Capital | Full-time | $200,000 | 2023-12-21 13:01:17 |
| 998056 | Analyst | Anywhere | Multicoin Capital | Full-time | $200,000 | 2023-10-04 11:01:48 |

### Takeaways
 - Huge Pay Ceilings: Top remote roles start around $200,000 and climb up to $650,000, proving that high-impact analytics work is heavily compensated.

- Seniority is Key: Most positions crossing the $220,000 mark carry titles like "Director" or "Lead", meaning true business ownership is where the highest payouts sit.

- Tech Dominates: Major tech firms (Meta, Uber, Pinterest) and specialized investment groups make up the bulk of these elite remote listings.

### 2. Skills For Top Paying Jobs
**Goal:** Identify the specific technical skills required by those top 10 highest-paying remote data analyst positions.
- **Query File:** [`query_2_skills_for_top_paying_jobs.sql`](project_sql/query_2_skills_for_top_paying_jobs.sql)

```sql
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
```
![`Skills For Top Paying Jobs`](./assets/query_2_skills_for_top_paying_jobs.png)
*Bar chart showing the most frequently requested skills among the top 10 highest-paying roles.*


### Takeaways
- The Big Three: SQL, Python, and Tableau tied as the most demanded skills, appearing in 5 of the top postings.

- Cloud is Crucial: High-paying roles consistently pair core querying skills with enterprise infrastructure like AWS, Azure, Databricks, and Snowflake.

- Heavy Data Lifting: Tools like Pandas and PySpark show up alongside Python, indicating that top earners are expected to handle complex data transformation.

### 3. Most Demanded Skills
**Goal:** Determine the most frequently requested technical skills across the entire remote Data and Business Analyst market to establish baseline requirements.
- **Query File:** [`query_3_most_demanded_skills.sql`](project_sql/query_3_most_demanded_skills.sql)

```sql
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
```
| Skill | Job Postings Demand |
| :--- | :--- |
| SQL | 8,557 |
| Excel | 5,594 |
| Python | 4,876 |
| Tableau | 4,473 |
| Power BI | 3,164 |
| R | 2,396 |

### Takeaways
- SQL is Mandatory: Showing up in 8,557 postings, SQL is the undeniable foundation of the analytics market.

- Spreadsheets Aren't Dead: Excel ranks second, proving that traditional spreadsheet modeling is still heavily relied upon.

- The Python/Tableau Advantage: Python comfortably beats R as the top scripting language, while Tableau slightly edges out Power BI.

### 4. Top Skills Based On Salary
**Goal:** Figure out which skills actually command the highest average salaries, filtering out low-volume anomalies.
- **Query File:** [`query_4_top_skills_based_on_salary.sql`](project_sql/query_4_top_skills_based_on_salary.sql)

```sql
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
```
| Skill | Average Annual Salary |
| :--- | ---: |
| Looker | $106,259 |
| Python | $102,578 |
| R | $101,223 |
| Tableau | $99,807 |
| SAS | $98,908 |
| SQL | $97,417 |
| Power BI | $96,744 |
| PowerPoint | $89,661 |
| Excel | $88,027 |
| Word | $84,012 |

### Takeaways
- Programming Pays: Python and R push average salaries past the six-figure mark, proving the financial value of knowing how to code.

- Core BI is Stable: Standard tools like Tableau, SQL, and Power BI hover steadily in the high $90K range.

- Office Tools Sit at the Bottom: While necessary, basic productivity software like Excel and Word lag behind specialized analytics platforms by over $10,000 annually.

### 5. Most Optimal Skills
**Goal:** Identify the "sweet spot" skills that balance high market demand (job security) with top earning potential.
- **Query File:** [query_5_most_optimal_jobs.sql](./project_sql/query_5_most_optimal_jobs.sql)

```sql
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
LIMIT 10;
```
*Query Optimization Note: This single-query approach aggregates both demand and salary metrics in one pass, minimizing I/O and execution time rather than relying on multiple CTEs.*

| skill_id | Skill | Posting Count | Average Annual Salary |
| :---: | :--- | ---: | ---: |
| 75 | Databricks | 11 | $139,006 |
| 80 | Snowflake | 38 | $112,989 |
| 97 | Hadoop | 25 | $111,849 |
| 8 | Go | 30 | $111,121 |
| 77 | BigQuery | 16 | $110,813 |
| 74 | Azure | 35 | $110,804 |
| 234 | Confluence | 14 | $108,415 |
| 76 | AWS | 32 | $108,317 |
| 194 | SSIS | 12 | $106,683 |
| 185 | Looker | 54 | $106,259 |

### Takeaways
- Data Engineering is Highly Valued: Databricks leads the pack at $139,006, followed by Snowflake and BigQuery. Enterprise pipeline skills clearly drive top-tier compensation.

- Cloud Ecosystems are Safe Bets: Major cloud platforms like Azure and AWS provide a predictable path to six-figure salaries.

- Looker is the Ultimate Sweet Spot: Looker balances solid demand (54 postings) with a strong average salary ($106,259), making it highly optimal to learn.

# What I Learned
Building this project taught me a lot more than just writing syntax. It leveled up my practical problem-solving skills:

- Complex Joins: I learned how to seamlessly connect fact and dimension tables using intermediate bridge tables (skills_job_dim).

- Data Aggregation: I got comfortable using GROUP BY with aggregate functions like COUNT() and AVG() to pull high-level metrics out of massive, raw datasets.

- Execution Order Logic: I gained a real understanding of when to use WHERE (filtering raw data before grouping) versus HAVING (filtering aggregated metrics after grouping)—a crucial distinction for getting accurate salary trends.

# Conclusion
This data-driven dive into the job market gave me exactly what I was looking for—a clear, no-nonsense roadmap for my own upskilling:

- Nail the Basics First: SQL and Excel are mandatory. You can't enter the market without them.

- Learn to Code: Python is the highest-value addition to a basic analyst stack, unlocking advanced analytics and better pay.

- Target the Cloud: Adding tools like Snowflake or AWS to my toolbelt is the smartest way to push into senior salary bands once the foundation is set.







