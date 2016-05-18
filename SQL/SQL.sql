--=================================================================================
-- SQL = structured query language
--=================================================================================

-----------------------------------------------------------------------------------
-- General Overview:
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
-- Helpful hints:
-- - capitalize the commands for visual purposes
-- - look for "from" clauses, to see where the data (table) comes from
-- - you can nest multiple layers of derived results
-- - break statements into clauses and stagger them, like in normal programming
-- - analyzing complicated queries is important, as you would have to read other people's queries to get a sense of what's the DB
-- - analytics should be part of the whole analysis process

-----------------------------------------------------------------------------------
-- helpful commands on terminal:

-- Starting / Stopping Server:
sudo /usr/local/mysql/support-files/mysql.server start
sudo /usr/local/mysql/support-files/mysql.server stop

-- delete files from tmp folder: 
cd /tmp
sudo rm -r *
-----------------------------------------------------------------------------------
-- Keyboard Shortcut:
http://msdn.microsoft.com/en-us/library/ms174205(v=sql.110).aspx

-----------------------------------------------------------------------------------
-- Important Commands:

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
-- Important Operators:

=	-- Equal
<>	-- Not equal. Note: In some versions of SQL this operator may be written as !=
>	-- Greater than
<	-- Less than
>=	-- Greater than or equal
<=	-- Less than or equal
BETWEEN	-- Between an inclusive range: between lower AND upper
LIKE -- Search for a pattern
IN -- To specify multiple possible values for a column

-----------------------------------------------------------------------------------
-- Important Functions:

AVG() -- Returns the average value
COUNT() -- Returns the number of rows
FIRST() -- Returns the first value
LAST() -- Returns the last value
MAX() -- Returns the largest value
MIN() -- Returns the smallest value
SUM() -- Returns the sum

UCASE() -- Converts a field to upper case
LCASE() -- Converts a field to lower case
MID() -- Extract characters from a text field
LEN() -- Returns the length of a text field
ROUND() -- Rounds a numeric field to the number of decimals specified
NOW() -- Returns the current system date and time
FORMAT() -- Formats how a field is to be 3splayed

-----------------------------------------------------------------------------------
-- Joins:

INNER JOIN -- Returns all rows when there is at least one match in BOTH tables (AND)
LEFT JOIN -- Return all rows from the left table, and the matched rows from the right table (Left AND)
RIGHT JOIN -- Return all rows from the right table, and the matched rows from the left table (Right AND)
FULL Outer JOIN -- Return all rows when there is a match in ONE of the tables (OR)

-----------------------------------------------------------------------------------
-- Data Types:

CHARACTER(n) -- Character string. Fixed-length n
VARCHAR(n) or CHARACTER VARYING(n) -- Character string. Variable length. Maximum length n
BINARY(n) -- Binary string. Fixed-length n
BOOLEAN	-- Stores TRUE or FALSE values
VARBINARY(n) or BINARY VARYING(n) -- Binary string. Variable length. Maximum length n
INTEGER(p) -- Integer numerical (no decimal). Precision p
SMALLINT -- Integer numerical (no decimal). Precision 5
INTEGER -- Integer numerical (no decimal). Precision 10
BIGINT -- Integer numerical (no decimal). Precision 19
DECIMAL(p,s) -- Exact numerical, precision p, scale s. Example: decimal(5,2) is a number that has 3 digits before the decimal and 2 digits after the decimal
NUMERIC(p,s) -- Exact numerical, precision p, scale s. (Same as DECIMAL)
FLOAT(p) -- Approximate numerical, mantissa precision p. A floating number in base 10 exponential notation. The size argument for this type consists of a single number specifying the minimum precision
REAL -- Approximate numerical, mantissa precision 7
FLOAT -- Approximate numerical, mantissa precision 16
DOUBLE PRECISION -- Approximate numerical, mantissa precision 16
DATE -- Stores year, month, and day values
TIME -- Stores hour, minute, and second values
TIMESTAMP -- Stores year, month, day, hour, minute, and second values
INTERVAL -- Composed of a number of integer fields, representing a period of time, depending on the type of interval
ARRAY -- A set-length and ordered collection of elements
MULTISET -- A variable-length and unordered collection of elements
XML -- Stores XML data

-----------------------------------------------------------------------------------
-- Syntax:
go -- signals the end of a batch, and send the current batch to an instance of SQL server



-----------------------------------------------------------------------------------
-- Conventions (in MS SQL):



-----------------------------------------------------------------------------------
-- variables:
declare @local_variable variable_type
set @local_variable = value
print @local_variable

-----------------------------------------------------------------------------------
-- exporting: (command line)
http://msdn.microsoft.com/en-us/library/ms162802.aspx

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- examples:
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-----------------------------------------------------------------------------------
-- selections

select * from table_name -- selects all columns in the database
select * from table_name.table -- selects all columns in the database's particlar table
select column_name1, column_name2 from table_name.table -- selects particular columns

select distinct column_name1, column_name2 from table_name.table -- selects distinct values in particular columns

select * from table_name where column_name = value -- adding an operation

select * from table_name where column_name = value1 and column_name = value2 -- adding more operations
select * from table_name where column_name = value1 or column_name = value2 -- adding more operations

select * from table_name order by column_name ASC -- order by that column in ascending order
select * from table_name order by column_name DESC -- order by that column in descending order

select top number_of_rows * from table_name
select top number_of_percentages percent * from table_name

select * from table_name where column_name like ''

select * from table_name where column_name in ('value1', 'value2', etc) -- selects all rows with these values in that column

SELECT column_name AS alias_name FROM table_name;
SELECT column_name(s) FROM table_name AS alias_name;

-----------------------------------------------------------------------------------
-- modificaitons

insert into table_name (column_name1, column_name2, ...) values (value1, value2, ...)

UPDATE table_name SET column1_name = value1 WHERE column2_name = value2;

-- new database
CREATE DATABASE dbname;

-- new table
CREATE TABLE table_name (
column_name1 data_type(size) constraint_name, -- optional constraint
column_name2 data_type(size),
column_name3 data_type(size), ...
);

REATE TABLE Orders (
O_Id int NOT NULL PRIMARY KEY,
OrderNo int NOT NULL,
P_Id int FOREIGN KEY REFERENCES Persons(P_Id)
); 

CREATE TABLE Persons (
ID int IDENTITY(1,1) PRIMARY KEY, -- the primary key field to be created automatically every time a new record is inserted.
LastName varchar(255) NOT NULL,
FirstName varchar(255),
Address varchar(255),
City varchar(255)
)

-- list of constraints
NOT NULL -- Indicates that a column cannot store NULL value
UNIQUE -- Ensures that each row for a column must have a unique value
PRIMARY KEY -- A combination of a NOT NULL and UNIQUE. Ensures that a column (or combination of two or more columns) 
-- have an unique identity which helps to find a particular record in a table more easily and quickly
FOREIGN KEY -- Ensure the referential integrity of the data in one table to match values in another table
CHECK -- Ensures that the value in a column meets a specific condition
DEFAULT -- Specifies a default value when specified none for this column

DELETE FROM table_name WHERE some_column=some_value;

DROP TABLE table_name -- deletes table
TRUNCATE TABLE table_name -- deletes all the data in the table, and not the table itself
DROP DATABASE database_name -- deletes database

ALTER TABLE table_name ADD column_name datatype
ALTER TABLE table_name DROP COLUMN column_name
ALTER TABLE table_name ALTER COLUMN column_name datatype

-----------------------------------------------------------------------------------
-- joining

SELECT column_name(s)
FROM table1 -- left, the
TYPE JOIN table2 -- right
ON table1.column_name = table2.column_name
ORDER BY column_name -- optional ordering argument

-- adding up the column values in two different tables
SELECT column_name(s) FROM table1
UNION -- UNION ALL includes dublicate values as well
SELECT column_name(s) FROM table2;
-- can add WHERE statement to be more specific with the joining

-- insert selective columns into a NEW table (in a new external database: optional)
SELECT column_name(s) INTO newtable [IN externaldb] FROM table1;

-- insert selective columns into a EXISTING table (in a new external database: optional)
INSERT INTO table2 (column_name(s)) SELECT column_name(s) FROM table1;

-- group 
SELECT column_name, aggregate_function(column_name)
FROM table_name
WHERE column_name operator value
GROUP BY column_name;

-- having: the WHERE keyword could not be used with aggregate functions.
SELECT column_name, aggregate_function(column_name)
FROM table_name
WHERE column_name operator value
GROUP BY column_name
HAVING aggregate_function(column_name) operator value;

-----------------------------------------------------------------------------------
-- functions (selective examples)

SELECT AVG(column_name) as [new field name] FROM table_name -- optional new field name
SELECT COUNT(column_name) FROM table_name;

SELECT MID(column_name,start[,length]) AS some_name FROM table_name;

-----------------------------------------------------------------------------------
-- virtural table
-- In SQL, a view is a virtual table based on the result-set of an SQL statement.
-- A view contains rows and columns, just like a real table. The fields in a view 
-- are fields from one or more real tables in the database.

CREATE VIEW view_name AS -- example of view_name is [Current Product List]
SELECT column_name(s)
FROM table_name
WHERE condition

-----------------------------------------------------------------------------------
-- index
-- An index can be created in a table to find data more quickly and efficiently.
-- The users cannot see the indexes, they are just used to speed up searches/queries.

-- create
CREATE INDEX index_name
ON table_name (column_name)

-- drop
DROP INDEX index_name ON table_name

-----------------------------------------------------------------------------------
-- pivot table

