

--
-- A table of Engines.
--
create table Engines (
    engineId integer not null,
    liters	 float(2) not null,
	cylinders integer not null,
	aspiration text not null,
	horsepower integer not null,
  primary key (engineId)
);

insert into Engines(engineId, liters, cylinders, aspiration, horsepower)
values (1, 3.2, 6, 'NA', 260);

insert into Engines(engineId, liters, cylinders, aspiration, horsepower)
values (2, 6.2, 8, 'SC', 707);

insert into Engines(engineId, liters, cylinders, aspiration, horsepower)
values (3, 2.0, 4, 'Turbo', 306);

select *
from Engines
order by engineId desc;


--
-- The table of Cars.
--
create table Cars (
    carId      integer not null,
    engine     integer not null references Engines(engineId),
	make	   text    not null,
	model	   text	   not null,
	year       integer not null,
	color 	   text	   not null,
    bodytype   text    not null,
	trim	   text	   not null,
	drivetrain text	   not null,
	miles	   integer not null,
	transmission text not null,
  primary key (carId)
);


insert into Cars(carId, engine, make, model, year, color, bodytype, trim, drivetrain, miles, transmission)
values (1, 1, 'Acura', 'TL', '2003', 'silver', 'sedan', 'Type-S', 'FWD', 106000, 'Automatic');

insert into Cars(carId, engine, make, model, year, color, bodytype, trim, drivetrain, miles, transmission)
values (2, 2, 'Dodge', 'Challenger', '2015', 'black', 'coupe', 'Hellcat', 'RWD', 5000, 'Manual');

insert into Cars(carId, engine, make, model, year, color, bodytype, trim, drivetrain, miles, transmission)
values (3, 2, 'Dodge', 'Charger', '2015', 'red', 'sedan', 'Hellcat', 'RWD', 11000, 'Automatic');

insert into Cars(carId, engine, make, model, year, color, bodytype, trim, drivetrain, miles, transmission)
values (4, 3, 'Honda', 'Civic', '2020', 'white', 'hatchback', 'Type-R', 'FWD', 9000, 'Manual');

select * 
from Cars
order by carId asc;


--
-- The table of People
-- 

create table People (
	pid	integer not null,
	firstname	text not null,
	lastname	text not null,
  primary key (pid)
);

insert into People (pid, firstname, lastname)
values (1, 'Matthew', 'Medina');

insert into People (pid, firstname, lastname)
values (2, 'Alan', 'Labouseur');

insert into People (pid, firstname, lastname)
values (3, 'Maggie', 'Hurst');

insert into People (pid, firstname, lastname)
values (4, 'Robert', 'Beringer');

insert into People (pid, firstname, lastname)
values (5, 'Enzo', 'Ferarri');

insert into People (pid, firstname, lastname)
values (6, 'Charles', 'Monette');

select *
from People
order by pid desc;

--
-- The table of Salespeople
--

create table Salespeople (
	pid integer not null references People(pid),
	commissionPct integer not null,
	salary integer not null,
  primary key (pid)
);

insert into Salespeople (pid, commissionPct, salary)
values (1, 10, 60000);

insert into Salespeople (pid, commissionPct, salary)
values (6, 12, 50000);

select *
from Salespeople
order by pid desc;

--
-- The table of Customers
--

create table Customers (
	pid integer not null references People(pid),
	discountPct integer not null,
  primary key (pid)
);

insert into Customers (pid, discountPct)
values (2, 50);

insert into Customers (pid, discountPct)
values (3, 5);

select *
from Customers
order by pid desc;

--
-- The table of Mechanics
--

create table Mechanics (
	pid integer not null references People(pid),
	specialty text not null,
	salary integer not null,
  primary key (pid)
);

insert into Mechanics (pid, specialty, salary)
values (4, "General", 70000);

insert into Mechanics (pid, specialty, salary)
values (5, "Engines", 100000);

select *
from Mechanics
order by pid desc;


--
-- The table of Purchases
--

create table Purchases (
	purchaseId	integer not null,
	car			integer not null references Cars(carId),
	salesperson integer not null references Salespeople(pid),
	customer	integer not null references Customers(pid),
	dateOfPurchase	date not null,
	total		integer not null,
  primary key (purchaseId)
);

insert into Purchases (purchaseId, car, salesperson, customer, dateOfPurchase, total)
values (1, 2, 1, 3, '2017-09-23', 53999);

insert into Purchases (purchaseId, car, salesperson, customer, dateOfPurchase, total)
values (2, 4, 6, 2, '2020-11-02', 32999);

select *
from Purchases
order by purchaseId desc;

--
-- The table of Repairs
--

create table Repairs (
	repairId integer not null,
	mechanic integer not null references Mechanics(pid),
	car integer not null references Cars(carId),
	job text not null,
	price integer not null,
	carInDate date not null,
	carOutDate date not null,
  primary key (repairId)
);

insert into Repairs (repairId, mechanic, car, job, price, carInDate, carOutDate)
values (1, 4, 1, 'brakes', 200, '2019-02-13', '2019-02-13');

insert into Repairs (repairId, mechanic, car, job, price, carInDate, carOutDate)
values (2, 5, 3, 'oil change', 50, '2020-04-14', '2020-04-15');

select *
from Repairs
order by repairId desc;

--
-- The view for available cars
--

create or replace view available_cars as
select *
from cars
where carId not in ( select car
				     from Purchases );
					 

select *
from available_cars;
					 
--
-- The view for employees
-

create or replace view employees as
select *
from people
where pid in ( select pid 
			   from mechanics )
or pid in ( select pid 
		    from salespeople );
			
select *
from employees;

--
-- The stored procedure for commission earned
--

create or replace function getCommission(int, refcursor) returns refcursor as
$$
declare
	purchase 	int 		:= $1;
	resultset 	refcursor 	:= $2;
begin
	open resultset for
		select p.total * (.01 * s.commissionPct) as commissionEarned
		from Purchases p, Salespeople s
		where p.salesperson = s.pid and purchaseId = purchase;
	return resultset;
end;
$$
language plpgsql;

select * from getCommission(1, 'results');
fetch all from results;


--
-- Role for managers
--

create role manager;

grant insert, select, update, delete
on cars, engines, purchases, repairs
to manager;

--
-- Role for the public
--

create role publicview;

grant select
on cars, engines
to publicview;


