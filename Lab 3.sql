select orderNum, totalUSD from Orders;

select lastName, homecity from People
where prefix = 'Dr.';

select prodID, name, priceUSD from Products
where qtyOnHand > 1007;

select firstname, homeCity from People
where DOB between '1950-1-1' and '1959-12-31';

select prefix, lastname from People
where prefix != 'Mr.';

select * from Products
where city != 'Dallas' and city != 'Duluth' and priceUSD > 3;

select * from Orders
where extract(month from dateOrdered) = 03;

select * from Orders
where extract(month from dateOrdered) = 02
and totalUSD >= 20000;

select * from Orders
where custID = 007;

select * from Orders
where custID = 005;