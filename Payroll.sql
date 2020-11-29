-- UC 1 : Creating a new database 
create database payroll_services;
 --Go to the database command 
use payroll_services;

-- UC 2 : Ability to create a employee payroll table in the payroll service database to manage employee payrolls
--Creating a table 
create table employee_payroll
(EmpID int not null identity(1,1) primary key,
EmpName varchar(150) not null,
Salary float not null,
StartDate date not null
);

--UC 3 : Ability to insert data into the table 
--Inserting data into table 
insert into employee_payroll(EmpName,Salary,StartDate) values
('Kendall',30000,'2020-03-28'),
('Teressa',40000,'2019-05-12'),
('Kylie',50000,'2019-02-13'),
('Stormi',45000,'2020-06-04');

-- UC 4 : Ability to retrieve all employee payroll data 
-- Select all columns and display all data 
select * from employee_payroll;

--UC 5 : Ability to retrieve salary data for a particular employee as well as employees who joined in a particular date range

 --Retrieve salary data for employee Teressa
 select EmpId,EmpName,Salary from employee_payroll where EmpName='Teressa';
 --Retrieve data of employees who joined in the given data range
 select * from employee_payroll where StartDate between cast('2020-01-01' as date) and cast(getdate() as date);

 --UC 6 : Ability to add gender to employee payroll table and update rows to display correct emp gender
-- Alter the table to add new colulmn
alter table employee_payroll add Gender char(1);
--Update the newly created column
update employee_payroll set Gender='F' where EmpName ='Teressa' or EmpName ='Kendall' or EmpName ='Kylie' or EmpName ='Stormi';

--UC 7 : Ability to find sum, average, min salary, max salary and number of male and female employees
--Ability to find sum, average, min salary, max salary and number of male and female employees
select Gender,
count(salary) as EmpCount,
min(salary) as MinSalary,
max(salary) as MaxSalary,
sum(salary) as SalarySum,
avg(salary) as AvgSalary
from employee_payroll where Gender='F' group by Gender;

--UC 8 : Ability to extend employee_payroll data to store employee information like employee phone, address and department
select * from employee_payroll;
--Adding new columns
alter table employee_payroll add 
PhoneNo bigint,
Address varchar(600) not null default 'ADDRESS NOT AVAILABLE',
Department varchar(500) not null default 'DEPARTMENT NOT AVAILABLE';

--UC 9 : Ability to extend employee_payroll table to have Basic Pay,Deductions,Taxable Pay,Income Tax, Net Pay
--Adding new columns
alter table employee_payroll add
BasicPay float,
Deductions float,
TaxablePay float,
Income_Tax float,
NetPay float;

--UC 10 : Ability to make Terissa as part of Sales and Marketing Department
--update data into the table
update employee_payroll set 
PhoneNo=9988778877,
Address='Lucknow',
Department='Sales',
BasicPay=20000,
Deductions=2000,
TaxablePay=1000,
Income_Tax=200,
NetPay=18000
where EmpName='Teressa';

--Adding Teressa as a part of Marketing team also
insert into employee_payroll values('Teressa',40000,'2019-05-12','F',9988778877,'Lucknow','Marketing',20000,2000,1000,200,18000);
--Two rows for Teressa is created with different emp id which means they are two different employee
--If any column is to be updated all rows for the same need to be updated creating unnecessary redundancy
select * from employee_payroll where EmpName='Teressa';

--UC 11 : Implemetation of E-R concept
--Creating table departments
create table departments
(DeptId int not null primary key,
DeptName varchar(100) not null);

--Adding data into departments table
insert into departments values
(100,'Sales'),
(101,'Marketing'),
(102,'HR'),
(103,'Accounts and Finance');

select * from departments;

--Creating companies table
create table companies
(CompanyId int not null primary key,
CompanyName varchar(150) not null);

select * from companies;

--Adding data to table
insert into companies values
(1,'Capgemini'),
(2,'Bridgelabz');

--Creating employees Table
create table employees
(EmpId int not null identity(1,1) primary key,
deptID int not null foreign key references departments(DeptID),
EmpName varchar(150) not null,
Gender char(1) not null,
PhoneNo bigint not null,
Address varchar(500) not null,
StartDate date not null,
CompanyId int not null foreign key references companies(CompanyID),
salary float NOT NULL);

--Adding data to employees table
insert into employees values
(101,'Tony','M',3456787654,'Gujrat','2020-03-28',1,40000),
(100,'Teressa','F',5677893456,'Hyderabad','2019-05-12',1,35000),
(103,'Steve Rogers','M',2345678765,'Orissa','2019-02-13',2,32000),
(102,'Nick Fury','M',3452341234,'Karnataka','2020-06-04',1,72000),
(102,'Steph Curry','M',7898765678,'Haryana','2020-07-04',2,50000);
select * from employees;

--Creating table payrolls
create table payrolls
(EmpId int not null foreign key references employees(EmpID),
BasicPay float not null,
Deductions float not null,
TaxablePay float not null,
Tax float not null,
NetPay float not null);

--Creating new table employee_dept to reduce many to many relation between employee and department
create table employee_depts
(EmpId int not null foreign key references employees(EmpID),
DeptId int not null foreign key references departments(DeptID));

--Adding data into the payrolls table
insert into payrolls values
(5,90000,5000,85000,5000,80000),
(6,50000,5000,45000,4000,41000),
(7,60000,4000,56000,4000,52000),
(8,90000,5000,85000,5000,80000),
(9,90000,5000,85000,5000,80000);

--Adding Teressa details into table
insert into employee_depts values
(5,101),
(6,100),
(7,103),
(8,102),
(9,102),
(6,101);
select * from employee_depts;

/*UC 12 : Ensuring all retrieve queries are working fine with new table structure*/

select * from companies;
select * from employees;
select * from payrolls;
select * from departments;
select * from employee_depts;

--UC 4 working
select e.EmpId,e.EmpName,e.Gender,e.PhoneNo,e.Address,e.StartDate,p.NetPay,d.DeptName
from employees e,payrolls p,departments d,employee_depts ed
where e.EmpId=p.EmpId and ed.EmpId=e.EmpId and ed.DeptId=d.DeptId;

--UC 5 working
select e.EmpId,e.EmpName,p.BasicPay,p.Deductions,p.TaxablePay,p.Tax,p.NetPay
from employees e,payrolls p
where e.EmpName='Teressa' and e.EmpId=p.EmpId;

--UC 7
select e.Gender,
count(e.EmpId) as EmpCount,
min(p.NetPay) as MinSalary,
max(p.NetPay) as MaxSalary,
sum(p.NetPay) as SalarySum,
avg(p.NetPay) as AvgSalary
from employees e,payrolls p
 where e.EmpId=p.EmpId group by Gender;
 select * from payrolls

 --Add procedure to store data
create procedure SpAddEmployeeDetails
(
@name varchar(255),
@start Date,
@Gender char(1),
@phone_number varchar(255),
@address varchar(255),
@department  varchar(255),
@Basic_Pay  float,
@Deductions float,
@Taxable_pay float,
@Income_tax float,
@Net_pay float
)
as
begin
insert into employee_payroll values
(
@Name,@Start,@Gender,@phone_number,@address,@department,@Basic_pay,@Deductions,@Taxable_pay,@Income_tax,@Net_pay
)
end