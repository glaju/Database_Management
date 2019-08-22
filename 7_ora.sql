create table allinfo(
ID varchar2(255),
name varchar2(255),
salary number,
dept_name varchar2(255),
building varchar2(255),
budget number
);

insert into allinfo values('22222','Einstein',95000,'Physics','Watson',70000);
insert into allinfo values('12121','Wu',90000,'Finance','Painter',120000);
insert into allinfo values('32343','El Said',60000,'History','Painter',50000);
insert into allinfo values('45565','Katz',75000,'Comp. Sci.','Taylor',100000);
insert into allinfo values('98345','Kim',80000,'Elec. Eng','Taylor',85000);
insert into allinfo values('76766','Crick',72000,'Biology','Watson',90000);
insert into allinfo values('10101','Srinivasan',65000,'Comp. Sci.','Taylor',100000);
insert into allinfo values('58583','Califieri',62000,'History','Painter',50000);
insert into allinfo values('83821','Brandt',92000,'Comp. Sci.','Taylor',100000);
insert into allinfo values('15151','Mozart',40000,'Music','Packard',80000);
insert into allinfo values('33456','Gold',87000,'Physics','Watson',70000);
insert into allinfo values('76543','Singh',80000,'Finance','Painter',120000);

drop table persons cascade constraints purge;
drop table buildings cascade constraints purge;
drop table persons2 cascade constraints purge;
drop table departments cascade constraints purge;
--1. Szedd sz�t a t�bl�t k�t k�l�n t�bl�ra (persons, buildings). A k�z�s attrib�tum a building legyen!
create table persons as
select distinct id, name, salary,building from allinfo;

create table buildings as
select distinct building, dept_name,budget from allinfo;

--2. Ellen�rizd le, hogy a k�t keletkezett t�bla JOIN-ja (inner join) ugyanannyi sort tartalmaz-e, mint az eredeti t�bla!
select * from allinfo
order by building;

select * from persons inner join buildings
on persons.building= buildings.BUILDING
order by buildings.building;

select id,name,salary,dept_name,buildings.building,budget 
from persons inner join buildings
on persons.building= buildings.BUILDING
minus
select * from allinfo;

--3. Vizsg�ld meg, hogy a buildings t�bl�ban a building attrib�tumt�l funckion�lisan f�ggnek-e a tov�bbi attrib�tumok!
select building, count(distinct dept_name)
from buildings
group by BUILDING
having count(distinct dept_name)>1;

select building, count(distinct budget)
from buildings
group by BUILDING
having count(distinct budget)>1;

--4. Szedd sz�t a t�bl�t k�t k�l�n t�bl�ra (persons2, departments). A k�z�s attrib�tum a dept_name legyen!
create table persons2 as
select distinct id, name, salary,dept_name from allinfo;

create table departments as
select distinct dept_name, building, budget from allinfo;

--5. Ellen�rizd le, hogy a k�t keletkezett t�bla JOIN-ja ugyanannyi sort tartalmaz-e, mint az eredeti t�bla!
select id,name,salary,departments.dept_name,building,budget from persons2 inner join departments
on persons2.DEPT_NAME= departments.DEPT_NAME
minus
select * from allinfo;

--6. Vizsg�ld meg, hogy a departments t�bl�ban a dept_name attrib�tumt�l funckion�lisan f�ggnek-e a tov�bbi attrib�tumok! 
select dept_name, count(distinct budget)
from departments
group by dept_name
having count(distinct budget)>1;

select dept_name, count(distinct building)
from departments
group by dept_name
having count(distinct building)>1;

