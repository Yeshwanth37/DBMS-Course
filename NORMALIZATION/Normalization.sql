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
/*********************************************************************
2. Identify minimal candidate key - Establish keys
*********************************************************************/

/*
ASSUMPTION: Assume there could be multiple ships in the ShipsLog data.
            Assume that two different ships can start at the same time. In our database we only have one ship but
            if there were two or more ships, two or more trips could start and end at the same TripStart. 
	        You may assume that a ship cannot set sail on two different trips at the same time.
	        So... the minimal candidate key is (TripStart, ShipVIN).
*/

/*
2a. Write a query to determine if a single attribute candidate key exists in your table.  Provide an alias for each column. 
    Include the total number of rows in the table as the first attribute in the SELECT statement of the query (uncorrelated). 
	TotalCnt, TripStart, and TripEnd should be 170. The others are something less than 170. MfgYear = 1.

	Provide a brief explanation of your query and the results.

TotalCnt TripStart TripEnd TripHour TripEngineStart (and so on...)
170      170        170    19       165

*/
SELECT COUNT(*) TotalCnt, COUNT(DISTINCT TripStart) TripStart, COUNT(DISTINCT TripEnd) TripEnd, COUNT(DISTINCT TripHour) TripHour, COUNT(DISTINCT TripEngineStart) TripEngineStart,
	   COUNT(DISTINCT TripEngineEnd) TripEngineEnd, COUNT(DISTINCT WaterTemp) WaterTemp, COUNT(DISTINCT MfgYear) MfgYear, COUNT(DISTINCT Make) Make, COUNT(DISTINCT Model) Model, 
	   COUNT(DISTINCT ShipVIN) ShipVIN, COUNT(DISTINCT CaptainName) CaptainName, COUNT(DISTINCT Pax1) Pax1, COUNT(DISTINCT Pax2) Pax2, COUNT(DISTINCT Pax3) Pax3, 
	   COUNT(DISTINCT Pax4) Pax4, COUNT(DISTINCT Pax5) Pax5,COUNT(DISTINCT Pax6) Pax6,COUNT(DISTINCT Pax7) Pax7, COUNT(DISTINCT Launch) Launch
FROM Trips1;

--This query is to built to find out how many single attribute candidate keys exists i.e. if any same coloumn exists. 
/*
TripStart and TripEnd are unique but given the assumptions above, they cannot be candidate keys 
and therefore there are no single attribute candidate keys. They are unique in the given set of
data, but are not universally so.
*/
SELECT COUNT(*) TripStart,TripEnd
FROM Trips1
GROUP BY TripStart,TripEnd
HAVING COUNT(*) > 1;
/*
2c. Write a query that confirms (TripStart,ShipVIN) is a candidate key. 
    Write a query that disconfirms a pair of attributes as a candidate key (just pick a pair).

Provide a brief explanation.
*/
SELECT COUNT(*)AS TotalCnt, TripStart,ShipVIN
FROM Trips1
GROUP BY TripStart,ShipVIN
HAVING COUNT(*) > 1;
-- It is confirmed that these are candidate keys for the given data and since it has unique values when grouping by both.

SELECT COUNT(*)AS TripHour, CaptainName
FROM Trips1
GROUP BY TripHour, CaptainName
HAVING COUNT(*) > 1;
-- It confirms that these two attributes are not candidate keys as it has same values when grouping by.

/*
2d. Add surrogate key to the Trip table (I called mine TripID)
    Make TripID an IDENTITY field that starts at 1 and is the PRIMARY KEY.
*/
ALTER Table Trips1
ADD TripID INT IDENTITY(1,1) PRIMARY KEY;

/*
2.e INSERT anamoly and UNIQUE constraint.
Write an INSERT statement that adds a trip with a duplicate TripStart and ShipVIN. Because, by default,
all attributes allow NULLs, only insert TripStart and ShipVIN in the INSERT statement (as a test).

Run a query to confirm a duplicate Trip can be inserted.

TripStart               TripEnd                 TripHour TripEngineStart  (and so on...)
2010-06-26 08:30:00.000 2010-06-26 15:30:00.000 7        0
2010-06-26 08:30:00.000 NULL                    NULL     NULL
*/
INSERT INTO Trips1(TripStart, ShipVIN)
	SELECT Tripstart, ShipVIN
	FROM Trips1
	WHERE TripID = 17;

--Write a query that returns the two duplicate rows using the surrogate key. The last primary key value should be TripID=171.
SELECT Tripstart, ShipVIN
FROM Trips1
WHERE TripID IN (17,171);

--Delete the newly created row using the surrogate primary key.
DELETE Trips1
WHERE TripID = 171;

/*
2.f ALTER TABLE slTrip to set both attributes of the composite key to be NOT NULL.
*/
ALTER TABLE Trips1
ALTER COLUMN TripStart DATETIME Not Null;

ALTER TABLE Trips1
ALTER COLUMN ShipVIN nVARChar(255) NOT NULL;

/*
2.g Add a UNIQUE constraint on the candidate key (TripStart,ShipVIN).
    Give the constraint a meaninful name. I called mine: Unique_TripStartShipVIN
*/
ALTER TABLE Trips1
ADD CONSTRAINT TripStart_ShipVIN
	UNIQUE(TripStart,ShipVIN)

/*
Rerun the INSERT statement to test the constraint.

Msg 2627, Level 14, State 1, Line 1
Violation of UNIQUE KEY constraint 'Unique_TripStartShipVIN'.
*/
INSERT into Trips1(TripStart,ShipVIN)
  SELECT TripStart,ShipVIN
  FROM Trips1
  WHERE TripID =17;

  /*********************************************************************
3. Functional dependencies
*********************************************************************/

/*
Because you already are familar with the normalized version of this
database, these queries are confirmatory in nature.
Confirmation of a design implementation is an important step prior
to deployment and production. In large datasets, visual inspection is 
impossible.
In an exploratory project, you would identify and test combinations
based on your knowledge of the content and attribute names.
*/

--3a. Identify functional dependencies
/*

Confirm these functional dependencies: 
[TripID] --> CaptainName
[TripID] --> ShipVIN
[TripID] --> Launch
[TripID] --> ShipVIN --> MfgYear
[TripID] --> ShipVIN --> Make
[TripID] --> ShipVIN --> Model

Disconfirm this functional dependency
Launch --> WaterTemp

On the exam, be prepared to draw tokenized diagrams if given 
a set of functional dependencies and/or SQL statements.

Provide a brief explanation for each query that includes the type of Normal Form violated.

*/
--Write the query to confirm
--[TripID] --> CaptainName

SELECT TripID,
	   COUNT(DISTINCT CaptainName) AS CaptCNT
FROM Trips1
GROUP BY TripID
HAVING COUNT(DISTINCT CaptainName) > 1;


--Write the query to confirm
--[TripID] --> ShipVIN

SELECT TripID,
	   COUNT(DISTINCT ShipVIN) AS ShipCNT
FROM Trips1
GROUP BY TripID
HAVING COUNT(DISTINCT ShipVIN) > 1;


--Write the query to confirm
--[TripID] --> Launch

SELECT TripID,
	   COUNT(DISTINCT Launch) AS LaunchCNT
FROM Trips1
GROUP BY TripID
HAVING COUNT(DISTINCT Launch) > 1;


--Write the query to confirm
--[TripID] --> ShipVIN --> MfgYear

SELECT TripID,
	   COUNT(DISTINCT MfgYear) AS MfgCNT
FROM Trips1
GROUP BY TripID
HAVING COUNT(DISTINCT MfgYear) > 1;

SELECT ShipVIN,
	   COUNT(DISTINCT MfgYear) AS MfgCNT
FROM Trips1
GROUP BY ShipVIN
HAVING COUNT(DISTINCT MfgYear) > 1;
-- in this case shipvin is FD on Mfgyear and it voilates the 2NF
--Write the query to confirm
--[TripID] --> ShipVIN --> Make

SELECT TripID,
	   COUNT(DISTINCT ShipVIN) AS ShipCNT
FROM Trips1
GROUP BY TripID
HAVING COUNT(DISTINCT ShipVIN) > 1;

SELECT ShipVIN,
	   COUNT(DISTINCT Make) AS MakeCNT
FROM Trips1
GROUP BY ShipVIN
HAVING COUNT(DISTINCT Make) > 1;
--even here shipvin is candiadate key and 2NF violates

--Write the query to confirm
--[TripID] --> ShipVIN --> Model

SELECT TripID,
	   COUNT(DISTINCT ShipVIN) AS ShipCNT
FROM Trips1
GROUP BY TripID
HAVING COUNT(DISTINCT ShipVIN) > 1;

SELECT ShipVIN,
	   COUNT(DISTINCT Model) AS ModelCNT
FROM Trips1
GROUP BY ShipVIN
HAVING COUNT(DISTINCT Model) > 1;
--shipVIN is candidate key and this FD on Model ,so it violates 2NF


--Write the query to disconfirm
--Launch --> WaterTemp
SELECT Launch,
	   COUNT(DISTINCT WaterTemp) AS ShipCNT
FROM Trips1
GROUP BY Launch
HAVING COUNT(DISTINCT WaterTemp) > 1;
--it disconfirms FD, because launch is not determining same in all the watertemp, so it is not FD.

--Explain why this disconfirms the functional dependency

--Because it has more than one value and both are not dependent!
/*********************************************************************
4. Data Redundancy and modification anomalies
*********************************************************************/

/*
4a. Provide and comment on an example of data redundancy in the Trip table.
*/
SELECT TripID,TripStart, TripEnd, TripHour, TripEngineStart, TripEngineEnd, WaterTemp,MfgYear, Make,Model, ShipVIN,CaptainName, Pax1, Pax2, Pax3, Pax4, Pax5, Pax6, Pax7, Launch
FROM Trips1;

-- Observe the MfgYear in the table where all the values are same

/*
4b. Write a DELETE statement that demonstrates a delete anomaly for the Trip table.
    The DELETE statement should delete a row based on a TripID value (Primary key).
    Provide a brief explanation.
*/
DELETE FROM Trips1
WHERE TripID = 4;
-- Through this query row 4 will be deleted and recheck with below query.

SELECT * FROM Trips1
WHERE TripID = 4;
-- There is no row with TripID 4 i.e the 4th row.

/*
4c. Write an INSERT statement that demonstrates an insert anomaly for the Trip table. 
    The INSERT statement should insert values for only part of the candidate key.
    Provide a brief explanation.
*/
INSERT INTO Trips1(TripStart,ShipVIN)
SELECT TripStart,ShipVIN
FROM Trips1
WHERE TripID = 15;
-- This query is not working because we have specified about unique constraint value above #2.g So we should drop these constraint values
ALTER TABLE Trips1
DROP CONSTRAINT Tripstart_ShipVIN

-- Now exceute the above INSERT query by inserting only to Candidate Key.

INSERT INTO Trips1(TripStart,ShipVIN)
SELECT TripStart,ShipVIN
FROM Trips1
WHERE TripID = 15;

SELECT * from Trips1
-- We have inserted a new row and data only for the candidate keys which are tripstart and ShipVINand also we have mentioned a tripid value in the where clause ,then it gets added otherwise it wont get added or inserted .

/*
4d. Write an UPDATE statement that demonstrates an update anomaly for Trip table.
    The UPDATE statement should update a row based on a TripID value.
    Provide a brief explanation.
*/
UPDATE Trips1
SET CaptainName = 'Madd'
WHERE TripID =2;

--Verify through below query

SELECT * FROM Trips1;

-- If we do a change in capitanName at TripID 2 from Harold Pardue to Madd and to make like this changes in more than one place, the database will be inconsistent.
-- Let's set back into the old one

UPDATE Trips1
SET CaptainName = 'Harold Pardue'
WHERE TripID=2;

/*
Explanation
If the passenger assignment for Pax2 in Trip where TripID =3 is changed to Jessica Brown, there are three possible
interpretations:
1. Jessica Futural changed her name and there for all occurrences should be changed
2. Jessica Brown is a new passenger being added to the database
3. This was an error and the transaction should not be allowed
*/

--Set it back to previous value.
/*********************************************************************
5. Normalizing the tables
*********************************************************************/

/*
Process for putting a relation into BCNF Figure

1. Identify every functional dependency
2. Identify every candidate key
3. If there is a functional dependency that has a 
   determinant that is not a candidate key:
   A. Move the columns of that functional dependency to a new relation
   B. Make the determinant of that functional dependency the
      primary key of the new relation
   C. Leave a copy of the determinant as a foreign key in the 
      original relation
   D. Create a referential integrity constraint between the 
      original relation and the new relation
4. Repeat step 3 until every determinant of every relation is a 
   candidate key
We have already done steps 1 and 2 (confirmation).

DROP the constraint on the candidate key (2f.)

Repeat step 3 until every determinant of every relation is a candidate key.
Identify each step in a comment: 
--Step 3.A. Determinant --> Dependent

Create IDENTITY surrogate keys for all newly created normalized tables.

*/
USE ShipLogPax

SELECT * FROM Trips1;

--[TripID] --> CaptainName
/*
In this case we will not make a separate table for Captain. In our ERD we did draw an entity
for the Captain, but we decided to implement all persons as one table slPax with two
relationships, one for Captain and one for passenger.
We will return to this dependancy when we deal with passengers.
*/

/*
[TripID] --> Launch
Retrieve [project] distinct rows for attributes involved in partial dependency with Launch
There should be 12 DISTINCT launch names.

Launch
Causeway
Causeway TJ
Fort Gaines
Fowl River
  :
  :

*/
SELECT DISTINCT Launch
FROM Trips1
WHERE Launch IS NOT NULL;
