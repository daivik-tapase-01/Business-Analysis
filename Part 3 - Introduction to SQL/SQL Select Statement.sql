use employees;

/* SELECT 
   FROM 
   WHERE 
   GROUP BY 
   HAVING 
   ORDER BY   */

select first_name, last_name from employees;

select * from employees;

select dept_no from departments;

select * from departments;

-- WHERE
select * from employees
where first_name = 'Denis';

select * from employees
where first_name = 'Elvis';

-- AND
select * from employees
where first_name = 'Denis' and gender = 'M';

select * from employees
where first_name = 'Kellie' and gender = 'F'; 

-- OR
select * from employees
where first_name = 'Denis' or first_name = 'Elvis';

select * from employees
where first_name = 'Kellie' or first_name = 'Aruna';

-- Logical operator precedence AND > OR
select * from employees
where first_name = 'Denis' 
and (gender = 'M' or  gender = 'F');

select * from employees
where gender = 'F'
and (first_name = 'Kellie' or  first_name = 'Aruna');

-- IN    NOT IN 
select * from employees 
where first_name in ('Cathie', 'Mark', 'Nathan');

select * from employees 
where first_name in ('Denis', 'Elvis');

select * from employees 
where first_name not in ('John', 'Mark', 'Jacob');

-- LIKE   NOT LIKE
select * from employees 
where first_name like ('Mar%');

select * from employees 
where first_name like ('Mar_');

select * from employees 
where first_name not like ('Mar%');

select * from employees 
where first_name like ('Mark%');

select * from employees 
where hire_date like ('%2000%');

select * from employees 
where emp_no like ('1000_');

-- Wildcard characters   %    _    *
select * from employees 
where first_name like ('%Jack%');

select * from employees 
where first_name not like ('%Jack%');

-- BETWEEN....  AND....         NOT BETWEEN....  AND....
select * from salaries
where salary between 66000 and 70000;

select * from employees
where emp_no not between '10004' and '10012';

select dept_name from departments
where dept_no between 'd003' and 'd006';

-- IS NULL   NOT NULL
select * from employees 
where first_name is null;

select * from employees 
where first_name is not null;

select dept_name from departments
where dept_no is not null;

--  	=	>	>=	<	<=	      not equal -> != <> 
select * from employees 
where hire_date >= '2000-01-01';

select * from employees 
where gender = 'F' and hire_date >= '2000-01-01';

select * from salaries 
where salary > 150000;

-- SELECT DISTINCT
select distinct gender from employees;

select distinct hire_date from employees;

-- Aggregate Functions   COUNT()	SUM()	MIN()	MAX()	AVG()
select count(emp_no) from employees;

select count(first_name) from employees;

select count(distinct first_name) from employees;

select count(*) from salaries
where salary >= 100000;

select count(*) from dept_manager;

-- ORDER BY     ASC     DESC
select * from employees
order by first_name;

select * from employees
order by first_name desc;

select * from employees
order by first_name, last_name ASC;

select * from employees
order by hire_date desc;

-- GROUP BY 
select first_name from employees
group by first_name;

select first_name, count(first_name) from employees
group by first_name
order by first_name;

-- ALIASES  (AS)
select first_name, count(first_name) as names_counts 
from employees
group by first_name
order by first_name;


select salary, count(emp_no) as emps_with_same_salary 
from salaries 
where salary > 80000
group by salary
order by salary;

-- HAVING clause
select * from employees
having hire_date >= '2000-01-01';

select first_name, count(first_name) as names_count
from employees
group by first_name
having count(first_name) > 250
order by first_name;

select * from salaries
where salary > 120000;

select emp_no, avg(salary)
from salaries
group by emp_no
having avg(salary) > 120000
order by emp_no;


-- HAVING VS WHERE clause
select first_name, count(first_name) as names_count
from employees
where hire_date > '1999-01-01'
group by first_name 
having count(first_name) < 200
order by first_name;

select emp_no from dept_emp 
where to_date > '2000-01-01'
group by emp_no
having count(from_date) > 1
order by emp_no;

-- LIMIT
select * 
from salaries
order by salary desc
limit 10;

select * from dept_emp
limit 100;

