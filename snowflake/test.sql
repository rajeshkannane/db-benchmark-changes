use database testrun;
use schema TESTSCHEMA;
create or replace table testsqlfile (name varchar,id number, age number);
insert into testsqlfile values('Rajesh',201,32);
select * from testsqlfile;
select * from table(information_schema.query_history_by_session()) order by start_time;

