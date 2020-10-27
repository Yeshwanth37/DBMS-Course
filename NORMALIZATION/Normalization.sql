/*
Script to normalize the Ships Log Excel file.
Fall 2020, ISC 561 Section
<Yeshwanth Nellikanti || J00626456>

Instructions:
  1. Change the name of this file to include your name. For example, I would rename the file:
     DavidBourrieNormalization.sql
  2. Complete each of the enumerated sections 1, 1.a, 1.b... 
     writing your SQL and explanation below each section heading between comments.
  3. Upload this script file to the assignment in Sakai.

This script does not need to run as a single transaction.

*/


/*
Import the Excel file ShipsLogPax.xlsx using SQL Server's Data Transformation Service (DTS).

1. Right mouseclick on an existing database and select "Tasks".
2. Select "Import Data..."
3. Click "Next" at Welcome screen
4. DataSource will be "Microsoft Excel".
5. Browse to the xlsx file (change the Excel Version if necessary) and click "Next"
6. Leave the Destination "SQL Server Native Client"
7. Click "New", provide a name for your DataBase, click "OK", and then "Next" (I named my database ShipLogPax).
8. If "Copy data from one or more tables or views" is selected, click "Next".
9. If not checked, check the Excel WorkSheet to include as Source Table. 
   I recommend you remove the "$" from the table name (click into the cell).
10. You should have to "Edit Mappings" because I cleaned the data up.... Data type mappings can be a major time sink for such projects.
11. Click "Next".
12. Click "Finish>>|" ("Run immediately" should be selected) and "Finish". The DTS should have transferred 171 rows. Click "Close".

*/

--Set your database the context database (https://msdn.microsoft.com/en-us/library/ms188366.aspx)
--USE YourDatabaseName;


/*
The data for this assignment is from the ShipsLog database in the SQL Exercise system.

Use the syntax from the Pubs example videos and script for the appropriate syntax.
You do NOT need to write the SQL from scratch. Start with the SQL given in the script.

In cases where you are asked to provide an explanation, be prepared to provide such explanations
on the exam.

By the way, this is the same process that was used to import the actual Ships Log Excel spreadsheet into
a relational database so it could be used in SQL Exercise System. 

Because the database has already been designed and implemented, the use of normalization in this
assignment is confirmatory. These techniques can be used to explore and propose a database design (bottom up) or
they can be use to test a design (top down).

Outline of this assignment
  1. Create a RELATION
  2. Identify minimal candidate key - Establish keys
  3. Functional dependencies
  4. Data Redundancy and modification anomalies
  5. Normalizing the tables
  6. JOIN new tables.
  7. Produce Relationship Diagram. Should look like schema in SQL Exercise System.
  8. Produce a set of Tokenized diagrams that illustrate the normalization process.
*/
/*********************************************************************
1. Create a RELATION
**********************************************************************/

/*
1a. Write the queries to demonstrate if your trip relation has duplicate rows.
*/

--Write your queries between the comments...
--SELECT * FROM myTable WHERE predicate;

/*
Write the query to return the total number of rows imported.
RowCnt
171
*/
SELECT * FROM Trips 

SELECT COUNT(*)AS NumberofRows
FROM Trips;
/*
Write the query to return the total number of DISTINCT rows (should be 170)

DistinctRowCnt
170
*/
SELECT COUNT(*) DistinctRowCount
FROM (SELECT DISTINCT * FROM Trips) AS DistinctRowCount;
/*
1b. Explain why your Trip relation is not a relation. Include the definition of a relation.
*/
-- Relation : Relation refers to a set of data in the Table.
-- Trip relation is not a Relation because it has duplicate values. So it is not a relation.

/*
1c. Write a query to identify the duplicate row.

TripStart               TripEnd                 TripHour TripEngineStart (and so on...)
2010-08-08 12:00:00.000  2010-08-08 17:00:00.000  5        20.8

*/
SELECT COUNT(*) As RowsCnt, TripStart, TripEnd, TripHour, TripEngineStart, TripEngineEnd, WaterTemp,MfgYear, Make,Model, ShipVIN,CaptainName, Pax1, Pax2, Pax3, Pax4, Pax5, Pax6, Pax7, Launch
FROM Trips
GROUP BY TripStart, TripEnd, TripHour, TripEngineStart, TripEngineEnd, WaterTemp,MfgYear, Make,Model, ShipVIN,CaptainName, Pax1, Pax2, Pax3, Pax4, Pax5, Pax6, Pax7, Launch
HAVING COUNT(*) > 1;

--1d.
--Create new table without duplicate rows using INTO clause
--Order the new table by TripStart ASC.
SELECT TripStart, TripEnd, TripHour, TripEngineStart, TripEngineEnd, WaterTemp,MfgYear, Make,Model, ShipVIN,CaptainName, Pax1, Pax2, Pax3, Pax4, Pax5, Pax6, Pax7, Launch
INTO Trips1
FROM Trips
GROUP BY TripStart, TripEnd, TripHour, TripEngineStart, TripEngineEnd, WaterTemp,MfgYear, Make,Model, ShipVIN,CaptainName, Pax1, Pax2, Pax3, Pax4, Pax5, Pax6, Pax7, Launch
ORDER BY TripStart ASC;
--Run a query to confirm the duplicate transaction has been removed (should only have 170 rows)
SELECT * FROM Trips1;

--1e. Write a comment that explains the query written for 1d. This should not simply restate the SQL syntax.

-- In the above query we are creating a new table so that we can eliminate duplicate rows by removing COUNT function and HAVING function. In this way the duplicate gets deleted. 
-- By adding into function GROUP BY the duplicate gets one.