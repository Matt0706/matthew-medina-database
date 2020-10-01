-- 1.
select  People.*
from People
inner join Customers
on People.pid = Customers.pid;

-- 2.
select  People.*
from People
inner join Agents
on People.pid = Agents.pid;

-- 3.
select People.*, Agents.*
from People
inner join Agents
on People.pid = Agents.pid
inner join Customers
on People.pid = Customers.pid;

-- 4.
select distinct People.firstName
from People
inner join Customers
on People.pid = Customers.pid
inner join Orders
on Customers.pid = Orders.custId;

-- 5.
select distinct People.firstName
from People
right join Customers
on People.pid = Customers.pid
inner join Orders
on Customers.pid = Orders.custId;

-- 6.
select distinct Agents.pid, Agents.commissionPct
from Agents
inner join Orders
on Orders.agentId = Agents.pid
where Orders.custId = 008
order by Agents.commissionPct asc;

-- 7.
select distinct People.lastName, People.homeCity, Agents.commissionPct
from People
inner join Agents
on People.pid = Agents.pid
inner join Orders
on Orders.agentId = Agents.pid
where Orders.custId = 001
order by Agents.commissionPct desc;

-- 8.
select People.lastName, People.homeCity
from Products
inner join People
on People.homeCity = Products.city
group by Products.city, People.lastName, People.homeCity
order by count(products.city);

-- 9.
select distinct Products.name, Products.prodId
from Products
inner join Orders
on Products.prodId = Orders.prodId
inner join People
on People.pid = Orders.custId
where People.homeCity = 'Chicago'
order by Products.name desc;


select distinct Products.name, Products.prodId
from Products
where prodId in (select prodId
				 from Orders
				 where agentId in (select agentId
								   from Orders
								   where custId in (select pid
												    from People
												    where homeCity = 'Chicago')))
order by Products.name desc;

-- 10.

select People.firstName, People.lastName, People.homeCity
from People
left join Agents
on People.pid = Agents.pid
left join Customers
on People.pid = Customers.pid
where Customers.pid in (select pid
					    from People
					    where homeCity in (select homeCity
										   from People
										   where pid in (select pid
														 from Agents)));
