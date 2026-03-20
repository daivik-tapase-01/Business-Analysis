use employees;

--  Common Table Expressions 

with cte as ( 
select avg(salary) as avg_salary from salaries)
select 
sum( case 
when s.salary > c.avg_salary then 1 else 0 
end) as no_f_salaries_above_avg,
count(s.salary) as total_no_of_salary_contracts
from salaries s
join employees e on s.emp_no = e.emp_no and e.gender = 'F'
cross join cte c;


WITH cte AS (
SELECT AVG(salary) AS avg_salary FROM salaries)
SELECT
SUM(CASE WHEN s.salary < c.avg_salary THEN 1 ELSE 0 END) AS no_salaries_below_avg,
COUNT(s.salary) AS no_of_salary_contracts
FROM salaries s JOIN employees e ON s.emp_no = e.emp_no AND e.gender = 'M' JOIN cte c;

WITH cte AS (
SELECT AVG(salary) AS avg_salary FROM salaries)
SELECT
COUNT(CASE WHEN s.salary < c.avg_salary THEN s.salary ELSE NULL END) AS no_salaries_below_avg_w_count,
COUNT(s.salary) AS no_of_salary_contracts
FROM salaries s JOIN employees e ON s.emp_no = e.emp_no AND e.gender = 'M' JOIN cte c;

SELECT
SUM(CASE
WHEN s.salary < a.avg_salary THEN 1 ELSE 0
END) AS no_salaries_below_avg,
COUNT(s.salary) AS no_of_salary_contracts
FROM (SELECT
AVG(salary) AS avg_salary
FROM salaries s) a
JOIN salaries s
JOIN employees e ON e.emp_no = s.emp_no AND e.gender = 'M';

WITH cte AS (
SELECT AVG(salary) AS avg_salary FROM salaries)
SELECT
SUM(CASE WHEN s.salary < c.avg_salary THEN 1 ELSE 0 END) AS no_salaries_below_avg_w_sum,
# COUNT(CASE WHEN s.salary < c.avg_salary THEN s.salary ELSE NULL END) AS no_salaries_below_avg_w_count,
COUNT(s.salary) AS no_of_salary_contracts
FROM salaries s JOIN employees e ON s.emp_no = e.emp_no AND e.gender = 'M' CROSS JOIN cte c;


--  Using Multiple Subclauses in a WITH Clause 

WITH cte1 AS (
SELECT AVG(salary) AS avg_salary FROM salaries),
cte2 AS (
SELECT s.emp_no, MAX(s.salary) AS max_salary
FROM salaries s
JOIN employees e ON e.emp_no = s.emp_no AND e.gender = 'M'
GROUP BY s.emp_no)
SELECT
SUM(CASE WHEN c2.max_salary < c1.avg_salary THEN 1 ELSE 0 END) AS highest_salaries_below_avg
FROM employees e
JOIN cte2 c2 ON c2.emp_no = e.emp_no
JOIN cte1 c1;

WITH cte_avg_salary AS (
SELECT AVG(salary) AS avg_salary FROM salaries),
cte_m_highest_salary AS (
SELECT s.emp_no, MAX(s.salary) AS max_salary
FROM salaries s JOIN employees e ON e.emp_no = s.emp_no AND e.gender = 'M'
GROUP BY s.emp_no)
SELECT
COUNT(CASE WHEN c2.max_salary < c1.avg_salary THEN c2.max_salary ELSE NULL END) AS max_salary
FROM employees e
JOIN cte_m_highest_salary c2 ON c2.emp_no = e.emp_no
JOIN cte_avg_salary c1;

WITH cte_avg_salary AS (
SELECT AVG(salary) AS avg_salary FROM salaries),
cte_m_highest_salary AS (
SELECT s.emp_no, MAX(s.salary) AS max_salary
FROM salaries s JOIN employees e ON e.emp_no = s.emp_no AND e.gender = 'M'
GROUP BY s.emp_no)
SELECT
COUNT(CASE WHEN c2.max_salary < c1.avg_salary THEN c2.max_salary ELSE NULL END) AS max_salary
FROM cte_m_highest_salary c2
JOIN cte_avg_salary c1;













