-- COUNT()  SUM()  MIN()  MAX()  AVG()
use employees;


-- COUNT()
select count(distinct from_date)
from salaries;

select count(*) as all_rows 
from salaries;

select count(distinct dept_no)
from dept_emp;

-- SUM()
select sum(salary)
from salaries;

select sum(salary)
from salaries
where from_date > '1997-01-01';

-- MIN()  MAX()
select max(salary)
from salaries;

select min(salary)
from salaries;

select min(emp_no)
from employees;

select max(emp_no)
from employees;

-- AVG()
select avg(salary)
from salaries;

select avg(salary)
from salaries
where from_date > '1997-01-01';

-- ROUND()
select round(avg(salary),2)
from salaries;

select round(avg(salary),2)
from salaries
where from_date > '1997-01-01';