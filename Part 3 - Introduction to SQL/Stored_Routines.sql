use employees;


-- Stored Procedures
drop procedure if exists select_employees;

delimiter $$
create procedure select_employees()
begin 
select * from employees
limit 1000;
end$$
delimiter ;

call employees.select_employees();
call select_employees();

drop procedure select_employees;


-- Create a procedure that will provide the average salary of all employees.
delimiter $$
create procedure avg_salary()
begin 
select avg(salary) as avg_salary
from salaries;
end $$
delimiter ;

call employees.avg_salary();


-- Create Stored Procedures with an Input Parameter
drop procedure if exists emp_salary;

delimiter $$
use employees $$
create procedure emp_salary(in p_emp_no integer)
begin 
select e.first_name, e.last_name, s.salary, s.from_date, s.to_date
from employees e 
join salaries s 
on e.emp_no = s.emp_no 
where e.emp_no = p_emp_no;
end $$
delimiter ;

call employees.emp_salary(11300);


delimiter $$
use employees $$
create procedure emp_avg_salary(in p_emp_no integer)
begin 
select e.first_name, e.last_name, avg(s.salary)
from employees e 
join salaries s 
on e.emp_no = s.emp_no 
where e.emp_no = p_emp_no;
end $$
delimiter ;

call employees.emp_avg_salary(11300);


-- Create Stored Procedures with an Output Parameter
drop procedure if exists emp_avg_salary_out;

delimiter $$
create procedure emp_avg_salary_out(in p_emp_no integer,
out p_avg_salary decimal(10,2))
begin 
select avg(s.salary)
into p_avg_salary 
from employees e 
join salaries s 
on e.emp_no = s.emp_no 
where e.emp_no = p_emp_no;
end $$
delimiter ;

set @p_avg_salary = 0;
call employees.emp_avg_salary_out(11300, @p_avg_salary);
select @p_avg_salary;

drop procedure if exists emp_info;

DELIMITER $$
CREATE PROCEDURE emp_info(in p_first_name varchar(255), 
in p_last_name varchar(255), 
out p_emp_no integer)
BEGIN
SELECT e.emp_no
INTO p_emp_no 
FROM employees e
WHERE e.first_name = p_first_name
AND e.last_name = p_last_name;
END$$
DELIMITER ;

set @p_emp_no = 0;
call employees.emp_info('Bezalel', 'Simmel',@p_emp_no);
select @p_emp_no;

select * from employees;


-- SQL Variables

SET @v_avg_salary = 0;
call employees.emp_avg_salary_out(11300, @v_avg_salary);
select @v_avg_salary;

SET @v_emp_no = 0;
CALL emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;


-- The Benefit of User-Defined Functions in MySQL
drop function if exists f_emp_avg_salary;

DELIMITER $$
CREATE FUNCTION f_emp_avg_salary(p_emp_no integer) returns decimal(10,2)
DETERMINISTIC NO SQL READS SQL DATA
BEGIN

DECLARE v_avg_salary decimal (10,2);

SELECT avg(s.salary)
INTO v_avg_salary 
FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no
WHERE e.emp_no = p_emp_no;

RETURN v_avg_salary;
END$$
DELIMITER ;

select f_emp_avg_salary(11300);


drop function if exists emp_info;

DELIMITER $$
CREATE FUNCTION emp_info(p_first_name varchar(255), 
p_last_name varchar(255)) 
RETURNS decimal(10,2)
NO SQL
BEGIN

DECLARE v_max_from_date date;
DECLARE v_salary decimal(10,2);
SELECT MAX(from_date)
INTO v_max_from_date 
FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no
WHERE e.first_name = p_first_name
AND e.last_name = p_last_name;

SELECT s.salary
INTO v_salary 
FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no
WHERE e.first_name = p_first_name
AND e.last_name = p_last_name
AND s.from_date = v_max_from_date;
RETURN v_salary;

END$$
DELIMITER ;

SELECT EMP_INFO('Aruna', 'Journel') as emp_salary;


-- Concluding Stored Routines
set @v_emp_no = 11300;

select emp_no, first_name, last_name, f_emp_avg_salary(@v_emp_no) as avg_salary
from employees
where emp_no = @v_emp_no;

