use employees;

-- Introduction to MySQL Window Functions

-- The ROW_NUMBER() Ranking Window Function and the Relevant MySQL Syntax

select emp_no, salary, row_number() over(partition by emp_no order by salary desc) as row_num 
from salaries;

select emp_no, salary, row_number() over(order by salary desc) as row_num 
from salaries;


SELECT emp_no, dept_no,
ROW_NUMBER() OVER (ORDER BY emp_no) AS row_num
FROM dept_manager;


SELECT emp_no, first_name, last_name,
ROW_NUMBER() OVER (PARTITION BY first_name ORDER BY last_name) AS row_num
FROM employees;


-- A Note on Using Several Window Functions in a Query

SELECT emp_no, salary,
ROW_NUMBER() OVER () AS row_num1,
ROW_NUMBER() OVER (PARTITION BY emp_no) AS row_num2,
ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary desc) AS row_num3,
ROW_NUMBER() OVER (ORDER BY salary desc) AS row_num4
FROM salaries
order by emp_no, salary;

SELECT emp_no, salary,
# ROW_NUMBER() OVER () AS row_num1,
ROW_NUMBER() OVER (PARTITION BY emp_no) AS row_num2,
ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary desc) AS row_num3
# ROW_NUMBER() OVER (ORDER BY salary desc) AS row_num4
FROM salaries;



SELECT dm.emp_no, salary,
ROW_NUMBER() OVER () AS row_num1,
ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary ASC) AS row_num2
FROM dept_manager dm
JOIN salaries s ON dm.emp_no = s.emp_no
ORDER BY row_num1, emp_no, salary ASC;


SELECT dm.emp_no, salary,
ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary ASC) AS row_num1,
ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num2   
FROM dept_manager dm
JOIN salaries s ON dm.emp_no = s.emp_no;


-- MySQL Window Functions Syntax

SELECT emp_no, salary,
ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num
FROM salaries;

SELECT emp_no, salary,
ROW_NUMBER() OVER w AS row_num
FROM salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

SELECT emp_no, first_name,
ROW_NUMBER() OVER w AS row_num
FROM employees
WINDOW w AS (PARTITION BY first_name ORDER BY emp_no);


SELECT a.emp_no, MIN(salary) AS min_salary FROM (
SELECT emp_no, salary, ROW_NUMBER() OVER w AS row_num
FROM salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
GROUP BY emp_no;

SELECT a.emp_no, MIN(salary) AS min_salary FROM (
SELECT emp_no, salary, ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary) AS row_num
FROM salaries) a
GROUP BY emp_no;

SELECT a.emp_no, MIN(salary) AS min_salary
FROM (SELECT emp_no, salary
    FROM salaries) a
GROUP BY emp_no;

SELECT a.emp_no, a.salary as min_salary 
FROM (SELECT emp_no, salary, ROW_NUMBER() OVER w AS row_num
FROM salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
WHERE a.row_num=1;

SELECT a.emp_no, a.salary as min_salary 
FROM (SELECT emp_no, salary, ROW_NUMBER() OVER w AS row_num
FROM salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
WHERE a.row_num=2;


--  The MySQL RANK() and DENSE_RANK() Window Functions

SELECT emp_no, salary,
ROW_NUMBER() OVER w AS row_num
FROM salaries
WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

SELECT dm.emp_no, (COUNT(salary)) AS no_of_salary_contracts
FROM dept_manager dm
JOIN salaries s ON dm.emp_no = s.emp_no
GROUP BY emp_no
ORDER BY emp_no;

SELECT emp_no, salary,
RANK() OVER w AS rank_num
FROM salaries
WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

SELECT emp_no, salary,
DENSE_RANK() OVER w AS rank_num
FROM salaries
WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

-- RANK() DENSE_RANK()
 
SELECT e.emp_no,
RANK() OVER w as employee_salary_ranking, s.salary
FROM employees e
JOIN salaries s ON s.emp_no = e.emp_no
WHERE e.emp_no BETWEEN 10500 AND 10600
WINDOW w as (PARTITION BY e.emp_no ORDER BY s.salary DESC);

SELECT e.emp_no,
DENSE_RANK() OVER w as employee_salary_ranking,
s.salary, e.hire_date, s.from_date,
(YEAR(s.from_date) - YEAR(e.hire_date)) AS years_from_start
FROM employees e
JOIN salaries s ON s.emp_no = e.emp_no
AND YEAR(s.from_date) - YEAR(e.hire_date) >= 5
WHERE e.emp_no BETWEEN 10500 AND 10600
WINDOW w as (PARTITION BY e.emp_no ORDER BY s.salary DESC);


-- The LAG() and LEAD() Value Window Functions

SELECT emp_no, salary,
LAG(salary) OVER w AS previous_salary,
LEAD(salary) OVER w AS next_salary,
salary - LAG(salary) OVER w AS diff_salary_current_previous,
LEAD(salary) OVER w - salary AS diff_salary_next_current
FROM salaries
WHERE salary > 80000 AND emp_no BETWEEN 10500 AND 10600
WINDOW w AS (PARTITION BY emp_no ORDER BY salary);

SELECT emp_no, salary,
LAG(salary) OVER w AS previous_salary,
LAG(salary, 2) OVER w AS 1_before_previous_salary,
LEAD(salary) OVER w AS next_salary,
LEAD(salary, 2) OVER w AS 1_after_next_salary
FROM salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)
LIMIT 1000;


-- MySQL Aggregate Functions in the Context of Window Functions

SELECT s1.emp_no, s.salary, s.from_date, s.to_date
FROM salaries s
JOIN (SELECT emp_no, MIN(from_date) AS from_date
FROM salaries
GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE s.from_date = s1.from_date;


SELECT de2.emp_no, d.dept_name, s2.salary, AVG(s2.salary) 
OVER w AS average_salary_per_department
FROM (SELECT de.emp_no, de.dept_no, de.from_date, de.to_date
FROM dept_emp de
JOIN (SELECT emp_no, MAX(from_date) AS from_date
FROM dept_emp
GROUP BY emp_no) de1 ON de1.emp_no = de.emp_no
WHERE de.to_date < '2002-01-01'
AND de.from_date > '2000-01-01'
AND de.from_date = de1.from_date) de2
JOIN (SELECT s1.emp_no, s.salary, s.from_date, s.to_date
FROM salaries s
JOIN (SELECT emp_no, MAX(from_date) AS from_date
FROM salaries
GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE s.to_date < '2002-01-01'
AND s.from_date > '2000-01-01'
AND s.from_date = s1.from_date) s2 ON s2.emp_no = de2.emp_no
JOIN departments d ON d.dept_no = de2.dept_no
GROUP BY de2.emp_no, d.dept_name
WINDOW w AS (PARTITION BY de2.dept_no)
ORDER BY de2.emp_no, salary;



