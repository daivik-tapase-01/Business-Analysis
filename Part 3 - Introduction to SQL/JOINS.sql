-- INNER JOIN
select m.dept_no, m.emp_no, d.dept_name
from dept_manager_dup m
inner join departments_dup d on m.dept_no = d.dept_no 
order by m.dept_no;

select e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date
from employees e 
inner join dept_manager dm on e.emp_no = dm.emp_no
order by e.emp_no;

-- DUPLICATE RECORDS 
insert into dept_manager_dup 
values ('110228', 'd003', '1992-03-21', '9999-01-01');

insert into departments_dup 
values ('d009', 'Customer Service');

select m.dept_no, m.emp_no, d.dept_name
from dept_manager_dup m
inner join departments_dup d on m.dept_no = d.dept_no 
order by m.dept_no;

-- LEFT JOIN
select m.dept_no, m.emp_no, d.dept_name
from dept_manager_dup m
left join departments_dup d on m.dept_no = d.dept_no 
order by m.dept_no;

-- reverse of above query 
select d.dept_no, m.emp_no, d.dept_name
from departments_dup d 
left join dept_manager_dup m on m.dept_no = d.dept_no 
order by d.dept_no;

-- just left side which donen't come in right side
select m.dept_no, m.emp_no, d.dept_name
from dept_manager_dup m
left join departments_dup d on m.dept_no = d.dept_no 
where dept_name is null
order by m.dept_no;

select e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date
from employees e 
left join dept_manager dm
on e.emp_no = dm.emp_no
where e.last_name = 'Markovitch'
order by dm.dept_no desc, e.emp_no;

-- RIGHT JOIN
select d.dept_no, m.emp_no, d.dept_name
from dept_manager_dup m
right join departments_dup d on m.dept_no = d.dept_no 
order by d.dept_no;

-- WHERE OLD JOIN SYNTAX
SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date
FROM employees e, dept_manager dm
WHERE e.emp_no = dm.emp_no;

-- USE BOTH JOIN AND WHERE CLAUSE
SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s
ON e.emp_no= s.emp_no
WHERE s.salary > 145000 
order by s.salary;

set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');

SELECT e.first_name, e.last_name, e.hire_date, t.title
FROM employees e
JOIN titles t 
ON e.emp_no = t.emp_no
WHERE first_name = 'Margareta' AND last_name = 'Markovitch'
ORDER BY e.emp_no;   

-- CROSS JOIN 
select dm.*, d.*
from dept_manager dm
cross join departments d
order by dm.emp_no, d.dept_no;

SELECT dm.*, d.*
FROM departments d
CROSS JOIN dept_manager dm
WHERE d.dept_no = 'd009'
ORDER BY d.dept_name;

SELECT e.*, d.*
FROM employees e
CROSS JOIN departments d
WHERE e.emp_no < 10011
ORDER BY e.emp_no, d.dept_no;

-- AGGREGATE FUNCTION WITH JOINS 
select e.gender, avg(s.salary) as average_salary
from employees e
join salaries s 
on e.emp_no = s.emp_no
group by gender;

-- JOIN MORE THAN TWO TABLES 
select e.first_name, e.last_name, e.hire_date, m.from_date, d.dept_name
from employees e
join dept_manager m on e.emp_no = m.emp_no
join departments d on m.dept_no = d.dept_no;

SELECT e.first_name, e.last_name, e.hire_date, t.title, m.from_date, d.dept_name
FROM employees e
JOIN dept_manager m ON e.emp_no = m.emp_no
JOIN departments d ON m.dept_no = d.dept_no
JOIN titles t ON e.emp_no = t.emp_no
WHERE t.title = 'Manager'
ORDER BY e.emp_no;

-- TIPS FOR JOINS
select d.dept_name, avg(salary) as average_salary
from departments d 
join dept_manager m on d.dept_no = m.dept_no 
join salaries s on m.emp_no = s.emp_no
group by d.dept_name
having average_salary > 60000
order by average_salary desc;

SELECT e.gender, COUNT(dm.emp_no) as count
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY gender;

-- UNION AND UNION ALL
SELECT * FROM (SELECT 
		e.emp_no, 
		e.first_name, 
		e.last_name,
		NULL AS dept_no,
		NULL AS from_date
FROM employees e
WHERE last_name = 'Denis' 
UNION SELECT
		NULL AS emp_no,
		NULL AS first_name,
		NULL AS last_name,
		dm.dept_no,
		dm.from_date
FROM dept_manager dm) as a
ORDER BY -a.emp_no desc;





select * from dept_manager_dup
order by dept_no;

select * from departments_dup
order by dept_no;