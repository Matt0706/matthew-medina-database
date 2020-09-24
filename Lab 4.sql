select * 
from People
where pid in (select pid
			  from Customers
			  );
              
              
select *
from People
where pid in (select pid
			  from agents
			 );
             
select *
from People
where pid in (select pid
			  from Customers
			  where pid in (select pid
						    from Agents
						   )
			 );
             
             
             
select *
from People
where pid not in (select pid
				  from Customers
				 )
and pid not in (select pid
			   from Agents
			  );



select custId
from Orders
where prodId = 'p01'
or prodId = 'p07';




select distinct custId 
from Orders 

where custId in (select custId
				 from Orders
				 where prodId = 'p01'
				)
and custId in (select custId
			   from Orders
			   where prodId = 'p07'
			  )
order by custId ASC;



select distinct custId 
from Orders 

where custId in (select custId
				 from Orders
				 where prodId = 'p01'
				)
and custId in (select custId
			   from Orders
			   where prodId = 'p07'
			  )
order by  custId ASC;


select firstname, lastname
from People
where pid in (select agentId
			  from Orders
			  where prodId = 'p05' or prodId = 'p07')
order by lastname desc;


select homeCity, DOB
from People
where pid in (select agentId
			  from Orders
			  where custId = '1'
			 )
order by homeCity asc;


select distinct prodId
from Orders
where agentId in (select agentId
				  from Orders
				  where custId in (select pid
								   from People
								   where homeCity = 'Toronto'
								   )
				  )
order by prodId desc;


select lastName, homeCity
from People
where pid in (select custId
			  from Orders
			  where agentId in (select pid
								from People
								where homeCity = 'Teaneck'
								or homeCity = 'Santa Monica'
							   )
			 );