-----------------------------------------------------------------------------------
-- SQL: structured query language
-----------------------------------------------------------------------------------
-- resources:
-- - mode analytics: community.modeanalytics.com/sql/tutorial/introduction-to-sql/

-----------------------------------------------------------------------------------
-- general overview:
-- - SQL is an object oriented program, with dbo being the database object
-- - any given execution is an instance, with no memory storage
-- - not case sensitve
-- - can add ";" after line to separate commands
-- - "F5" runs the entire query
-- - can include "[]" to bracket file names
-- - use '' to surround the string
-- - use "" if the string has a space
-- - % represents wildcards - i.e. missing letters
-- - _ represents a single wildcard
-- - [abcd] represents a list of all possible characters
-- - [^abcd] represents a list of all possible characters that are not these

-----------------------------------------------------------------------------------
-- helpful hints:
-- - capitalize the commands for visual purposes
-- - look for "FROM" clauses, to see where the data (table) comes from
-- - you can nest multiple layers of derived results
-- - break statements into clauses and stagger them, like in normal programming
-- - analyze complicated queries / read other people's queries to get a sense the DB
-- - analytics should be part of the whole analysis process
-- - shortcut: http://msdn.microsoft.com/en-us/library/ms174205(v=sql.110).aspx

-----------------------------------------------------------------------------------
-- helpful terminal operations:

-- starting / stopping server:
sudo /usr/local/mysql/support-files/mysql.server start
sudo /usr/local/mysql/support-files/mysql.server stop

-- access MySQL through terminal:
mysql -u root -p

-- delete files from tmp folder: 
cd /tmp
sudo rm -r *

-----------------------------------------------------------------------------------
-- commands:

USE db -- use a database
SHOW DATABASE -- shows databases
SHOW TABLES in db -- shows tables in db
SHOW COLUMNS in table -- shows columns in tables
DESCRIBE table -- shows schema of table

-- postgres
\l -- list databases 
\dn -- list schemas
\dt *.* -- list tables (2nd *) in schema (1st *)

SELECT -- extracts data from a database
UPDATE -- updates data in a database
DELETE -- deletes data from a database
INSERT INTO -- inserts new data into a database
CREATE DATABASE -- creates a new database
ALTER DATABASE -- modifies a database
CREATE TABLE -- creates a new table
ALTER TABLE -- modifies a table
DROP TABLE -- deletes a table
CREATE INDEX -- creates an index (search key)
DROP INDEX -- deletes an index

-----------------------------------------------------------------------------------
-- operators:

=	-- equal
<>	-- not equal. Note: In some versions of SQL this operator may be written as !=
>	-- greater than
<	-- less than
>=	-- greater than or equal
<=	-- less than or equal
BETWEEN	-- between an inclusive range: between lower AND upper
LIKE -- search for a pattern
IN -- to specify multiple possible values for a column
IS NULLL -- contains no data

-----------------------------------------------------------------------------------
-- functions:

AVG() -- returns the average value
COUNT() -- returns the number of rows
FIRST() -- returns the first value
LAST() -- returns the last value
MAX() -- returns the largest value
MIN() -- returns the smallest value
SUM() -- returns the sum

UPPER() -- converts a field to upper case; UCASE()
LOWER() -- converts a field to lower case; LCASE()
MID() -- extract characters FROM a text field
LENGTH() -- returns the length of a text field; LEN()
ROUND() -- rounds a numeric field to the number of decimals specified
NOW() -- returns the current system date and time
FORMAT() -- formats how a field is to be 3splayed

-- strings
LEFT(string, nchar) -- pull certain number of characters FROM the left
RIGHT(string, nchar) -- pull certain number of characters FROM the right
TRIM(both '()' FROM column) -- 1st arg: 'leading', 'trailing'; 2nd, 'char to rm'
POSITION('A' IN column) as a_position -- position from the left
STRPOS(column, 'A') as a_position -- same as above
SUBSTR(column, 4, 2) as new_column -- 2nd arg: starting; 3rd arg: nchar
CONCAT(column_1, ', ', column_2) as column_1_2 -- combine
column_1 || ', ' || column_2) as column_1_2 -- same as above; "||" is piping'; "+"
COALESCE(descript, 0) -- put some value to null ones

-- extracting specific durations from dates
SELECT
	cleaned_date,
	EXTRACT('year'   FROM cleaned_date) AS year,
	EXTRACT('month'  FROM cleaned_date) AS month,
	EXTRACT('day'    FROM cleaned_date) AS day,
	EXTRACT('hour'   FROM cleaned_date) AS hour,
	EXTRACT('minute' FROM cleaned_date) AS minute,
	EXTRACT('second' FROM cleaned_date) AS second,
	EXTRACT('decade' FROM cleaned_date) AS decade,
	EXTRACT('dow'    FROM cleaned_date) AS day_of_week
FROM db.table_with_date
-- round dates to whatever precision specified
SELECT 
	cleaned_date,
	DATE_TRUNC('year'   , cleaned_date) AS year,
	DATE_TRUNC('month'  , cleaned_date) AS month,
	DATE_TRUNC('week'   , cleaned_date) AS week,
	DATE_TRUNC('day'    , cleaned_date) AS day,
	DATE_TRUNC('hour'   , cleaned_date) AS hour,
	DATE_TRUNC('minute' , cleaned_date) AS minute,
	DATE_TRUNC('second' , cleaned_date) AS second,
	DATE_TRUNC('decade' , cleaned_date) AS decade
FROM db.table_with_date
-- today's date and time
SELECT 
	CURRENT_DATE AS date,
	CURRENT_TIME AT TIME ZONE 'PST' AS time_pst,
	CURRENT_TIME AS time,
	CURRENT_TIMESTAMP AS timestamp,
	LOCALTIME AS localtime,
	LOCALTIMESTAMP AS localtimestamp,
	NOW() AS now
	
-----------------------------------------------------------------------------------
-- joins:

INNER JOIN -- returns all rows when there is at least one match in BOTH tables (AND)
LEFT JOIN -- return all rows FROM the left table, and the matched rows FROM the right table (Left AND)
RIGHT JOIN -- return all rows FROM the right table, and the matched rows FROM the left table (Right AND)
FULL Outer JOIN -- return all rows when there is a match in ONE of the tables (OR)

-----------------------------------------------------------------------------------
-- WITH alias creation:

-- create an alias
WITH 
alias_name_1 AS sub_querry_1,
alias_name_2 AS sub_querry_2

-- select
SELECT 
	* 
FROM alias_name_1 as a
LEFT JOIN alias_name_2 as b
ON a.id = b.id

-----------------------------------------------------------------------------------
-- window functions
-- - performs a calculation across a set of table rows related to the current row
-- - like aggregate, but does not cause rows to be grouped into a single output
-- - CANNOT include window functions in a GROUP BY clause
-- - but CAN apply the same aggregates (SUM, COUNT, AVG)

-- sum(duration_seconds) over ascending order of start_time
SELECT
	start_time,
	duration_seconds,
	SUM(duration_seconds) 
		OVER (ORDER BY start_time) AS running_total
FROM tutorial.dc_bikeshare_q1_2012

-- do the same thing, but group by ("PARTITION BY") start_terminal
SELECT
	start_time,
	start_terminal,
    duration_seconds,
    SUM(duration_seconds) 
    	OVER (PARTITION BY start_terminal ORDER BY start_time) AS running_total
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'

-- ROW_NUMBER()
-- alternatively: 
-- - RANK() = same value same rank, but next would be +X, for X number of repeats
-- - DENSE_RANK() = same value same rank
-- - NTILE(nBuckets) = nth percentile given number of buckets
-- - LAG(column, n) = get rows preceeding by n
-- - LEAD(column, n) = get rows proceeding by n
SELECT
	start_terminal,
    start_time,
    duration_seconds,
    ROW_NUMBER() 
    	OVER (PARTITION BY start_terminal ORDER BY start_time) AS row_number
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'

-- window alias:
SELECT
	start_terminal,
    duration_seconds,
    NTILE(4) OVER ntile_window AS quartile,
	NTILE(5) OVER ntile_window AS quintile,
	NTILE(100) OVER ntile_window AS percentile
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
WINDOW ntile_window AS (PARTITION BY start_terminal ORDER BY duration_seconds)
ORDER BY start_terminal, duration_seconds
-- same as:
SELECT
	start_terminal,
    duration_seconds,
    NTILE(4) 
    	OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS quartile,
	NTILE(5) 
		OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS quintile,
	NTILE(100)
		OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS percentile
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
ORDER BY start_terminal, duration_seconds

-----------------------------------------------------------------------------------
-- pivot table: need to do this with case
-- - https://community.modeanalytics.com/sql/tutorial/sql-pivot-table/

-----------------------------------------------------------------------------------
-- data Types:

CHARACTER(n) -- character string. Fixed-length n
VARCHAR(n) or CHARACTER VARYING(n) -- character string. Variable length. Maximum length n
BINARY(n) -- binary string. Fixed-length n
BOOLEAN	-- stores TRUE or FALSE values
VARBINARY(n) or BINARY VARYING(n) -- binary string. Variable length. Maximum length n
INTEGER(p) -- integer numerical (no decimal). Precision p
SMALLINT -- integer numerical (no decimal). Precision 5
INTEGER -- integer numerical (no decimal). Precision 10
BIGINT -- integer numerical (no decimal). Precision 19
DECIMAL(p,s) -- exact numerical, precision p, scale s. 
-- e.g. decimal(5,2) has 3 digits before the decimal; 2, after
NUMERIC(p,s) -- exact numerical, precision p, scale s. (Same as DECIMAL)
FLOAT(p) -- approximate numerical, mantissa precision p. 
-- a floating number in base 10 exponential notation
-- the size argument for this type consists of a single number specifying the minimum precision
REAL -- approximate numerical, mantissa precision 7
FLOAT -- approximate numerical, mantissa precision 16
DOUBLE PRECISION -- approximate numerical, mantissa precision 16
DATE -- stores year, month, and day values
TIME -- stores hour, minute, and second values
TIMESTAMP -- stores year, month, day, hour, minute, and second values
INTERVAL -- composed of a number of integer fields, representing a period of time, depending on the type of interval
ARRAY -- a set-length and ordered collection of elements
MULTISET -- a variable-length and unordered collection of elements
XML -- stores XML data

-- casting
SELECT
	CAST(int_column AS float)
FROM table
-- alternative way from int to float
SELECT
	int_column + 0.0
FROM table

-----------------------------------------------------------------------------------
-- performance, affected by
-- - table size: querying >millions
-- - joins: substantially increasing row counts
-- - aggregation: combining is more computationally heavy than retrieving
-- ways to reduce computation 
-- - filter out with WHERE, subqueries, LIMIT for exploratory analysis
EXPLAIN -- added to the beginning of any (working) query to get a sense of timing

-----------------------------------------------------------------------------------
-- others

go -- signals the end of a batch, and send the current batch to an instance of SQL server

-- variables:
declare @local_variable variable_type
set @local_variable = value
print @local_variable

-- exporting: (command line)
http://msdn.microsoft.com/en-us/library/ms162802.aspx

-----------------------------------------------------------------------------------
-- examples:
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- selection
-- order:
-- - select
-- - from
-- - where
-- - group by
-- - having
-- - order by

-- SELECT all columns in the database
SELECT * FROM table_name
-- SELECT all columns in the database's particlar table
SELECT * FROM table_name.table
-- SELECT particular columns
SELECT column_name1, column_name2 FROM table_name.table

-- SELECTs distinct values in particular columns
SELECT DISTINCT column_name1, column_name2 FROM table_name.table 

-- adding operations
SELECT * FROM table_name WHERE column_name = value 
SELECT * FROM table_name WHERE column_name = value1 AND column_name = value2
SELECT * FROM table_name WHERE column_name = value1 OR column_name = value2

-- order by that column in ascending/descending order
SELECT * FROM table_name ORDER BY column_name ASC
SELECT * FROM table_name ORDER BY column_name DESC

-- SELECT top rows - SQL Server
SELECT top number_of_rows * FROM table_name
SELECT top number_of_percentages percent * FROM table_name
-- SELECT top rows - MySQL
SELECT * FROM table_name limit number_of_rows

-- SELECT types of columns
SELECT * FROM table_name WHERE column_name LIKE ''
SELECT * FROM table_name WHERE column_name IN ('value1', 'value2')

-- change column names
SELECT column_name AS alias_name FROM table_name;
-- change table names
SELECT column_name(s) FROM table_name AS alias_name;

-----------------------------------------------------------------------------------
-- modificaitons

-- insert new columns with new values 
INSERT INTO table_name (column_name1, column_name2) VALUES (value1, value2)

-- update columns columns based on existing values
UPDATE table_name SET column1_name = value1 WHERE column2_name = value2;

-- new database
CREATE DATABASE dbname;

-- new table
CREATE TABLE table_name (
	column_name1 data_type(size) constraint_name, -- optional constraint
	column_name2 data_type(size),
	column_name3 data_type(size)
);

-- example
CREATE TABLE Orders (
	O_Id INT NOT NULL PRIMARY KEY,
	OrderNo INT NOT NULL,
	P_Id INT FOREIGN KEY REFERENCES Persons(P_Id)
); 

-- the primary key field to be created automatically every time a new record is inserted
CREATE TABLE Persons (
	ID INT IDENTITY(1,1) PRIMARY KEY, 
	LastName VARCHAR(255) NOT NULL,
	FirstName VARCHAR(255),
	Address VARCHAR(255),
	City VARCHAR(255)
);

-- list of constraints
NOT NULL -- indicates that a column cannot store NULL value
UNIQUE -- ensures that each row for a column must have a unique value
PRIMARY KEY -- a combination of a NOT NULL and UNIQUE. Ensures that a column (or combination of two or more columns) 
-- have an unique identity which helps to find a particular record in a table more easily and quickly
FOREIGN KEY -- ensure the referential integrity of the data in one table to match values in another table
CHECK -- ensures that the value in a column meets a specific condition
DEFAULT -- specifies a default value when specified none for this column

DELETE FROM table_name WHERE some_column = some_value;

DROP TABLE table_name -- deletes table
TRUNCATE TABLE table_name -- deletes all the data in the table, and not the table itself
DROP DATABASE database_name -- deletes database

ALTER TABLE table_name ADD column_name datatype
ALTER TABLE table_name DROP COLUMN column_name
ALTER TABLE table_name ALTER COLUMN column_name datatype

-----------------------------------------------------------------------------------
-- joining

SELECT column_name(s)
FROM table1 -- left / original table
TYPE JOIN table2 -- right table
	ON table1.column_name = table2.column_name
ORDER BY column_name -- optional ordering argument

-- appending values two different tables (like R's rbind()/bind_rows())
-- can add WHERE statement to be more specific with the joining
SELECT column_name(s) FROM table1
UNION ALL -- UNION, if to exclude dublicate values as well
SELECT column_name(s) FROM table2;

-- insert selective columns into a NEW table (in a new external database: optional)
SELECT column_name(s) INTO newtable [IN externaldb] FROM table1;

-- insert selective columns into a EXISTING table (in a new external database: optional)
INSERT INTO table2 (column_name(s)) SELECT column_name(s) FROM table1;

-----------------------------------------------------------------------------------
-- aggregation

-- group 
SELECT column_name, aggregate_function(column_name)
FROM table_name
WHERE column_name operator value
GROUP BY column_name;

-- having: the where keyword could not be used with aggregate functions
SELECT column_name, aggregate_function(column_name)
FROM table_name
WHERE column_name operator value
GROUP BY column_name
HAVING aggregate_function(column_name) operator value;

-----------------------------------------------------------------------------------
-- functions

SELECT AVG(column_name) AS [new field name] FROM table_name -- optional new field name
SELECT COUNT(column_name) FROM table_name;

SELECT MID(column_name,start[,length]) AS some_name FROM table_name;

-----------------------------------------------------------------------------------
-- virtural table: based on the result-set of an SQL statement
-- just like a real table, but query is called 

CREATE VIEW view_name AS
SELECT column_name(s)
FROM table_name
WHERE condition

-----------------------------------------------------------------------------------
-- index: created to find data more quickly and efficiently
-- users cannot see the indexes, they are just used to speed up searches/queries

-- create
CREATE INDEX index_name
ON table_name (column_name)

-- drop
DROP INDEX index_name ON table_name
