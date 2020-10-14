-- 1.

select city
from Products
group by city
having count(*) = (select count(city)
					from Products
					group by city
					order by count(*) desc
				    limit 1);


-- 2.

select name
from products
group by name, priceusd
having priceusd >= (select avg(priceUSD)
				    from products)
order by name desc;


-- 3.

select p.lastname, o.prodid, o.totalusd
from people p
inner join orders o on p.pid = o.custid
where o.dateordered between '2020-03-01' and '2020-03-31'
order by o.totalusd desc;


-- 4.

select p.lastname, coalesce(o.totalusd)
from people p
inner join customers c on p.pid = c.pid
left join orders o on p.pid = o.custid
order by p.lastname desc;


-- 5. I had trouble adding the agents names to the results

select 	p1.firstname as custFName,
		p1.lastname as custLName,
		pr.name as prodName
from people p1
left join orders on p1.pid = orders.custid
left join products pr on orders.prodid = pr.prodid
where p1.pid in (select distinct custid
			    from orders
			    where agentid in (select p2.pid
								  from people p2
								  inner join agents on p2.pid = agents.pid
								  where p2.homeCity = 'Teaneck'));
                                  
                                  
-- 6. Order number 1017 has a totalusd of 25643.88, the calculation performed returns 25643.888, which gets rounded to 89 cents. Hence order 1017 being returned by the query.

select *
from orders
where totalUSD not in (select round(o.quantityOrdered * pr.priceUSD * (.01* (100 - c.discountpct)), 2)
					   from orders o
					   inner join products pr on o.prodid = pr.prodid
					   inner join customers c on o.custid = c.pid);
                       
                       
-- 7. 

select firstname, lastname
from people
inner join customers on people.pid = customers.pid
inner join agents on people.pid = agents.pid;


-- 8.


create view PeopleCustomers as
select people.*, customers.paymentterms, customers.discountpct
from people
inner join customers on people.pid = customers.pid;


create view PeopleAgents as
select people.*, agents.paymentterms, agents.commissionpct
from people
inner join agents on people.pid = agents.pid;

select *
from PeopleCustomers;

select *
from PeopleAgents;


-- 9.

select c.firstname, c.lastname
from peoplecustomers c
inner join peopleagents a on c.pid = a.pid;


-- 10.

-- The output is the same using both queries because the query with views is simply referencing the create query used to create the view. In both cases, the pids of all customers is joined with the pids of all agents.


-- 11.

select *
from people
left join customers on people.pid = customers.pid;

select *
from people
right join customers on people.pid = customers.pid;

-- A left outer join will return all of the rows from the left table, even if there is not a match. In the left join shown here, all of the people rows are returned, and their data from the right table, customers. Any people that are not customers will return nulls for the customer data. The right outer join query will return all of the rows from the right table, in this case customers, and their data from the left table, people.
