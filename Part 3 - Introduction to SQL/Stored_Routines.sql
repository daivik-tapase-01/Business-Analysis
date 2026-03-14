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


