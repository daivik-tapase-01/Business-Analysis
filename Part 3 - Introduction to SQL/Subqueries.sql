use employees;

-- Subqueries are used in WHERE clause    AND	 IN 
select e.first_name, e.last_name
from employees e
where e.emp_no in (select dm.emp_no
from dept_manager dm);

select * from dept_manager
where emp_no in (select emp_no 
from employees 
where hire_date between '1990-01-01' and '1995-01-01');

-- EXISTS
select e.first_name, e.last_name
from employees e
where exists (select *
from dept_manager dm
where dm.emp_no = e.emp_no);

select * from employees e 
where exists (select *
from titles t 
where t.emp_no = e.emp_no 
and title = 'Assistant Engineer');	

--  SQL Subqueries Nested in SELECT and FROM
select A.* from
(select e.emp_no as employee_ID,
MIN(de.dept_no) as deartment_code,
(select emp_no 
from dept_manager 
where emp_no = 110022) as manager_ID
from employees e
join dept_emp de on e.emp_no = de.emp_no 
where e.emp_no <= 10020
group by e.emp_no 
order by e.emp_no) as A
union 
select B.* from
(select e.emp_no as employee_ID,
MIN(de.dept_no) as deartment_code,
(select emp_no 
from dept_manager 
where emp_no = 110039) as manager_ID
from employees e
join dept_emp de on e.emp_no = de.emp_no 
where e.emp_no > 10020
group by e.emp_no 
order by e.emp_no
limit 20) as B ;







