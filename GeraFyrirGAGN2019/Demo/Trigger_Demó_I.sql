-- Lesefni:  http://www.mysqltutorial.org/mysql-triggers.aspx

-- Búum til gagnagrunn til að nota í þessu demói.  Svo má droppa honum á eftir.
drop database if exists Triggerbase;
create database Triggerbase;
use Triggerbase;

-- Triggerinn í þessu demói fer í gang þegar update skipun er keyrð á töfluna employees.
-- Hann er skilgreindur sem "after trigger" og kóðinn í honum keyrir EFIR að þúið er að
-- keyra update-ið.
-- Þessi trigger loggar í ActionLog töfluna upplýsingar um uppfærlsuna
drop table if exists Employees;

create table Employees
(
    ID int,
    empName varchar(95) not null,
    email varchar(125) not null,
    jobTitle varchar(50) default 'Unknown',
    monthlySalary int,
    constraint employee_PK primary key(ID)
);

-- Log- tafla.  
-- Svona log - töflur eru notaðar til að logga stöff!!
drop table if exists ActionLogs;

create table ActionLogs
(
	id int auto_increment,
    employeeID int not null,
    empName varchar(50) not null,
    changedOn datetime default current_timestamp,
    actionInfo varchar(75) default null,
    constraint actionlog_PK  primary key(id)
); 

delimiter $$
drop trigger if exists After_Employee_Update $$
-- Þessi trigger gerir svo sem ekki mikið en er fínt demó.
-- Hann er skilgreindur til að fara í gang þegar gerð er UPDATE skipun í töflunni employees
-- old.ID og old.empName eru gildin fyrir þennan Employee sem fyrir eru í töflunni og
-- triggerinn hefur aðgang að!
create trigger After_Employee_Update 
after update on Employees
for each row 
begin
    insert into ActionLogs(employeeID,empName,actionInfo)
    values(old.ID,old.empName,'update action was performed');
end $$

delimiter ;
-- Setjum test data í töfluna employees
insert into Employees values(1000,'John Doe','doe@fakemail.ru','Assistant',420000);
insert into Employees values(1005,'Jean Smith','jdoe@fakemail.edu','CEO',750000);
insert into Employees values(1010,'Peter Pan','pphan@fakemail.is',null,250000);

-- Þegar við keyrum þetta update þá fer triggerinn í gang og gerir sitt stöff.
update Employees set jobTitle = 'Bellboy' where ID = 1010;

-- Tékkum á því hvort eitthvað hefur gerst
select * from ActionLogs;
select * from Employees;
