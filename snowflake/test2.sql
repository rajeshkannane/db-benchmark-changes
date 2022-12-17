CREATE DATABASE testrun;
use database testrun;
create schema testschema;
use schema testschema;
create or replace TABLE testtable (
	ID1 VARCHAR(16777216),
	ID2 VARCHAR(16777216),
	ID3 VARCHAR(16777216),
	ID4 NUMBER(38,0),
	ID5 NUMBER(38,0),
	ID6 NUMBER(38,0),
	V1 NUMBER(38,0),
	V2 NUMBER(38,0),
	V3 FLOAT
);
create or replace stage teststage file_format = (type = 'CSV' field_delimiter = ',' skip_header = 1);
put file:///home/rajesh/git/db-benchmark/data/G1_1e7_1e2_0_0.csv @teststage;
COPY into testtable FROM @teststage/G1_1e7_1e2_0_0.csv.gz file_format = (type=CSV RECORD_DELIMITER='\n') on_error = 'continue';
rm @teststage;
select count(*) from testtable;
