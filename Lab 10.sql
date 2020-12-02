create or replace function PreReqsFor(int, refcursor) returns refcursor as
$$
declare
	course 		int 		:= $1;
	resultset 	refcursor 	:= $2;
begin
	open resultset for
		select prereqnum 
		from Prerequisites
		where courseNum = course;
	return resultset;
end;
$$
language plpgsql;




create or replace function IsPreReqFor(int, refcursor) returns refcursor as
$$
declare
	prereq 		int 		:= $1;
	resultset 	refcursor 	:= $2;
begin
	open resultset for
		select courseNum 
		from Prerequisites
		where prereqnum = prereq;
	return resultset;
end;
$$
language plpgsql;
