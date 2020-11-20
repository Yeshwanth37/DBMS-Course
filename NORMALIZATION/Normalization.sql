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

--Create a new table for Launch. Make LaunchID an IDENTITY. Start the sequence at 100.
--All attributes should be NOT NULL (except the primary key).

/*
Before we insert data... need to clean up some "dirty data." 
'Causeway', 'CauseWay', and 'Causeway TJ' and 'Lescher' and 'Lescher (Navco)' are actually
the same launches. Over time I typed them into my spreadsheet with slightly different names. 
They should be just 'Causeway' and 'Navco'.
Write the UPDATE statements against the Trip table to correct the data.

Revised data:

Launch
Causeway
Fort Gaines
Fowl River
Harbor Rd. Landing Ocean Springs MS
Navco
  :
  :

*/
--UPDATE the Trip table: set 'Causeway TJ' to 'CauseWay" and 'Lescher (Navco)' to 'Navco'.

UPDATE Trips1
SET Launch ='Causeway'
WHERE Launch = 'Causeway TJ';

UPDATE Trips1
SET Launch = 'Navco'
WHERE Launch ='Lescher (Navco)';

UPDATE Trips1
SET Launch = 'Navco'
WHERE Launch ='Lescher';

SELECT * FROM Trips1;

/*
Insert DISTINCT values for Launch into new table. Write a SELECT * to confirm INSERT.
There should only be 10 Launches.

LaunchID Launch
100      Causeway
101      Fort Gaines
102      Fowl River
103      Harbor Rd. Landing Ocean Springs MS
104      Navco
  :
  :
*/

SELECT DISTINCT Launch
INTO LaunchTables
FROM Trips1
WHERE Launch IS NOT NULL;

ALTER TABLE LaunchTables
ADD LaunchID INT IDENTITY(100,1) PRIMARY KEY;

SELECT LaunchID, Launch
FROM LaunchTables;

--Create a Foreign key for the Launch table in the Trip table. Specify that the FK can be NULL.

ALTER TABLE Trips1
ADD LaunchID INT NULL;

--Link the two tables through PK/FK using an UPDATE statement.

UPDATE Trips1
SET Trips1.LaunchID = LaunchTables.LaunchID
FROM Trips1, LaunchTables
WHERE LaunchTables.Launch = Trips1.Launch;

SELECT * 
FROM Trips1
/*
Confirm update by JOINing Trip and Launch on the new PK/FK relationship. The result should be 170 rows.

TripStart                   LaunchID Launch   LaunchID	Launch
2010-07-03 09:30:00.000	    100      Causeway 100       Causeway
2010-07-05 13:00:00.000	    100      Causeway 100       Causeway
2010-07-10 09:00:00.000	    100      Causeway 100       Causeway
  :
  :
*/

--Create a referential integrity constraint (define the Foreign Key as a constraint).
--ALTER TABLE slTrip DROP CONSTRAINT fk_launchID;

ALTER TABLE Trips1
ADD CONSTRAINT fk_LaunchTables
FOREIGN key (LaunchID)
REFERENCES LaunchTables(LaunchID);

/*
Test by attempting to delete a launch from the launch table. The fk constraint should prohibit this
because it would result in an orphan in the many (child) table.

Msg 547, Level 16, State 0, Line 1
The DELETE statement conflicted with the REFERENCE constraint
*/
DELETE FROM LaunchTables
WHERE Launch = 'Causeway';

--Drop the launch column from the trip table (clean up...)

ALTER TABLE Trips1
DROP COLUMN Launch;

--Write a SELECT * JOINing the two tables to confirm all operations.
--Launch should no longer appear in the Trip table.

SELECT *
FROM Trips1 INNER JOIN Launchtables ON Trips1.LaunchID = LaunchTables.LaunchID;

--I have done this but this does not connect to pk and fk as in the video

--Now work on the Ship attributes.

--[TripID] --> ShipVIN
--[TripID] --> ShipVIN --> MfgYear
--[TripID] --> ShipVIN --> Make
--[TripID] --> ShipVIN --> Model

--All attributes associated with ShipVIN are to be moved to a new One table having a one to many relationship with the Trip table.

/*
Retrieve [project] distinct rows for the four attributes involved in dependency with Ship
There should be 1 DISTINCT row, of course, because there is currently only one ship

ShipVIN     MfgYear Make        Model
VRKS112333	2000	Chaparral	180 LE
*/

SELECT DISTINCT ShipVIN, MfgYear, Make, Model
FROM Trips1;

--Create a new table for Ship. Make ShipID an IDENTITY. Start the sequence at 200.
--All attributes should be NOT NULL (except the primary key).

SELECT DISTINCT ShipVIN, MfgYear, Make, Model
INTO shipTable
FROM Trips1
WHERE MfgYear IS NOT NULL AND 
	  Make IS NOT NULL AND 
	  Model IS NOT NULL;

ALTER TABLE shiptable
ADD ShipID INT IDENTITY (200,1) PRIMARY KEY;

/*
Insert DISTINCT values for Ship into new table. Write a SELECT * to confirm INSERT.
There should only be 1 Ship.

ShipID  ShipVIN    MfgYear Make      Model
200     VRKS112333 2000    Chaparral 180 LE
*/

SELECT *
FROM shipTable;

--Create a Foreign key for the Ship table in the Trip table. Specify that the FK can be NULL.

ALTER TABLE Trips1
ADD ShipID INT NULL;

--Link the two tables through PK/FK (ShipVIN) using an UPDATE statement.

UPDATE Trips1
SET Trips1.ShipID = shiptable.ShipID
FROM Trips1, shipTable
WHERE Trips1.ShipVIN =shiptable.ShipVIN;

--Confirm update by JOINing Trip and Launch on the new PK/FK relationship. The result should be 170 rows.

Select * from Trips1;

SELECT COUNT(*) AS TotalRows
FROM Trips1 INNER JOIN ShipTable 
					ON Trips1.ShipID=Shiptable.ShipID;


--Create a referential integrity constraint (define the Foreign Key as a constraint).
--ALTER TABLE slTrip DROP CONSTRAINT fk_ShipID;

ALTER TABLE Trips1
ADD CONSTRAINT fk_ShipTable
FOREIGN key (ShipID)
REFERENCES ShipTable(ShipID);

--Test by attempting to delete a Ship from the Ship table. The fk constraint should prohibit this
--because it would result in an orphan in the many (child) table.

DELETE FROM Shiptable
WHERE ShipID=200;

--Drop the Ship columns from the trip table (clean up...)
--Before we do, we need to DROP our candidate key constraint and recreate it.

ALTER TABLE Trips1
DROP CONSTRAINT fk_ShipTable;

ALTER TABLE Trips1
DROP COLUMN ShipVIN, MfgYear, Make, Model;

--Re-create the foreign key constraint this time with the foreign key for ShipID.

ALTER TABLE Trips1
ADD CONSTRAINT fk_ShipTable
FOREIGN key (ShipID)
REFERENCES ShipTable(shipID);

--Write a SELECT * JOINing the two tables to confirm all operations.

SELECT * 
FROM Trips1,shipTable
WHERE Trips1.ShipID = shipTable.ShipID;

/*
Pax1, Pax2, Pax3... in the Trip table is a repeating group and therefore violates 1NF.
Before we pivot these names and extract CaptainName, we should create a unique list of passengers
and create the Pax table.

Retrieve [project] distinct passengers names
The easiest way to handle this sort of situation is with a UNION of the form:

SELECT Name
FROM (SELECT DISTINCT Pax1 AS Name
      FROM Trip
      WHERE Pax1 IS NOT NULL
      UNION
      SELECT DISTINCT Pax2 AS Name
      FROM Trip
      WHERE Pax2 IS NOT NULL
      UNION
       :
       :
	   ) AS vwName
ORDER BY Name ASC

Might as well put a SELECT rapper around it from the outset
because we have to extract last and first name separately 
and that is easier to do once the DISTINCT master list has been compiled.

The inner query should return 133 rows.

Name
(MK) Mary Katherine Ladnier
Abbe Adent
Alec Yasinsac
Aline Pardue
  :
  :

*/

SELECT PaxName
FROM (SELECT DISTINCT Pax1 AS PaxName
      FROM Trips1
      WHERE Pax1 IS NOT NULL
      UNION
      SELECT DISTINCT Pax2 AS PaxName
      FROM Trips1
      WHERE Pax2 IS NOT NULL
      UNION
      SELECT DISTINCT Pax3 AS PaxName
      FROM Trips1
      WHERE Pax3 IS NOT NULL
	  UNION 
	  SELECT DISTINCT Pax4 AS PaxName
      FROM Trips1
      WHERE Pax4 IS NOT NULL
      UNION
      SELECT DISTINCT Pax5 AS PaxName
      FROM Trips1
      WHERE Pax5 IS NOT NULL
	  UNION
      SELECT DISTINCT Pax6 AS PaxName
      FROM Trips1
      WHERE Pax6 IS NOT NULL
	  UNION
	  SELECT DISTINCT Pax7 AS PaxName
      FROM Trips1
      WHERE Pax7 IS NOT NULL) AS vwName
ORDER BY PaxName ASC;

/*
Ok. Here is the tricky part, extracting first and last name. String functions in SQL are a little weak.
Probably we should write a script to do this pre-processing.
We are going to make the simplifying assumption that the last set of contiguous characters is
the LastName. This certainly not true. But for example in:

Krishna Priya Tummala

we will assume 'Tummala' is the last name and we assume 'Krishna Priya' is the First Name.

This is always a major issue when importing data from semi-structured and un-structured sources.

For LastName we need to retrieve all the text from the RIGHT till the last space.
For FirstName we need to retrieve all the text from the LEFT until the last space.

I'm going to give you "a" solution, but you should spend some time understanding what this actually does
and how it works. There are other solutions. I encourage you to look around.

Documentation on SQL Server string functions can be found here: https://msdn.microsoft.com/en-us/library/ms181984.aspx

SELECT Name, LEFT(Name, (LEN(Name) - CHARINDEX(' ',REVERSE(Name)))) AS PaxFirstName,
       RIGHT(Name, (CHARINDEX(' ',REVERSE(Name)))) AS PaxLastName 
    :
	:
	
These functions extract first and last name as in below.

Name                            PaxFirstName         PaxLastName
(MK) Mary Katherine Ladnier	    (MK) Mary Katherine  Ladnier'
Abbe Adent                      Abbe                 Adent
Alec Yasinsac                   Alec                 Yasinsac
   :
   :

*/

SELECT PaxName, LEFT(PaxName, (LEN(PaxName) - CHARINDEX(' ',REVERSE(PaxName)))) AS PaxFirstName,
       RIGHT(PaxName, (CHARINDEX(' ',REVERSE(PaxName)))) AS PaxLastName 
FROM (SELECT DISTINCT Pax1 AS PaxName
      FROM Trips1
      WHERE Pax1 IS NOT NULL
      UNION
      SELECT DISTINCT Pax2 AS PaxName
      FROM Trips1
      WHERE Pax2 IS NOT NULL
      UNION
      SELECT DISTINCT Pax3 AS PaxName
      FROM Trips1
      WHERE Pax3 IS NOT NULL
	  UNION 
	  SELECT DISTINCT Pax4 AS PaxName
      FROM Trips1
      WHERE Pax4 IS NOT NULL
      UNION
      SELECT DISTINCT Pax5 AS PaxName
      FROM Trips1
	  WHERE Pax5 IS NOT NULL
	  UNION
      SELECT DISTINCT Pax6 AS PaxName
      FROM Trips1
      WHERE Pax6 IS NOT NULL
	  UNION
	  SELECT DISTINCT Pax7 AS PaxName
      FROM Trips1
      WHERE Pax7 IS NOT NULL) AS vwName
ORDER BY PaxName ASC;


/*
Create a new table for Pax. Make PaxID an IDENTITY. Start the sequence at 500.
All attributes should be NULL (except the primary key).
Include the "Name" column in the new table so we can link the PK/FK data.
We will drop the Name column afterwards.
*/
SELECT DISTINCT PaxName, LEFT(PaxName, (LEN(PaxName) - CHARINDEX(' ',REVERSE(PaxName)))) AS PaxFirstName,
       RIGHT(PaxName, (CHARINDEX(' ',REVERSE(PaxName)))) AS PaxLastName 
INTO tblPax
FROM (SELECT DISTINCT Pax1 AS PaxName
      FROM Trips1
      WHERE Pax1 IS NOT NULL
      UNION
      SELECT DISTINCT Pax2 AS PaxName
      FROM Trips1
      WHERE Pax2 IS NOT NULL
      UNION
      SELECT DISTINCT Pax3 AS PaxName
      FROM Trips1
      WHERE Pax3 IS NOT NULL
	  UNION 
	  SELECT DISTINCT Pax4 AS PaxName
      FROM Trips1
	   WHERE Pax4 IS NOT NULL
      UNION
      SELECT DISTINCT Pax5 AS PaxName
      FROM Trips1
      WHERE Pax5 IS NOT NULL
      UNION
      SELECT DISTINCT Pax6 AS PaxName
      FROM Trips1
      WHERE Pax6 IS NOT NULL
	  UNION
	  SELECT DISTINCT Pax7 AS PaxName
      FROM Trips1
      WHERE Pax7 IS NOT NULL) AS vwName
ORDER BY PaxName ASC;

ALTER TABLE tblPax
ADD PaxID INT IDENTITY (500,1) PRIMARY KEY;

/*
Insert the data from the UNION query above into the new table.
Write a SELECT * to confirm INSERT.

Insert 133 rows.

PaxID Name                        PaxFirstName         PaxLastName
500   (MK) Mary Katherine Ladnier (MK) Mary Katherine  Ladnier'
501   Abbe Adent                  Abbe                 Adent
502   Alec Yasinsac               Alec                 Yasinsac
   :
   :

*/

SELECT PaxID, PaxName, PaxFirstName,PaxLastName
FROM tblPax;

/*
We cannot link the Pax table to the Trip table yet because there is
a many-to-many relationship between Pax and Trip.
We can, however, go ahead and take care of CaptainName since it is a 1:Many relationship.
*/

--[TripID] --> CaptainName
--Create a Foreign key (CaptainID) for the Pax table in the Trip table. Specify that the FK can be NULL.
--We are matching CaptainName with Name in the Trip and Pax tables respectively.

ALTER TABLE Trips1
ADD CaptainID INT NULL;

--Link the two tables through PK/FK (Name) using an UPDATE statement.

UPDATE Trips1
SET Trips1.CaptainID = tblPax.PaxID
FROM Trips1, tblPax
WHERE Trips1.CaptainName = tblPax.PaxName;

--Confirm update by JOINing Trip and Launch on the new PK/FK relationship. The result should be 170 rows.

SELECT COUNT(*)
FROM Trips1
INNER JOIN tblPax  ON Trips1.CaptainName = tblPax.PaxName;

/*
Create a referential integrity constraint (define the Foreign Key as a constraint).
ALTER TABLE slTrip DROP CONSTRAINT fk_CaptainID;
CaptainID maps to slPax(PaxID).
*/
ALTER TABLE Trips1
ADD CONSTRAINT fk_tblPax
FOREIGN key (CaptainID)
REFERENCES tblPax(PaxID);

/*
Test by attempting to delete a captain (in my case, PaxID = 513). The fk constraint should prohibit this
because it would result in an orphan in the many (child) table.

Msg 547, Level 16, State 0, Line 1
The DELETE statement conflicted with the REFERENCE
*/

DELETE FROM tblPax
WHERE PaxID = 513;

--Drop CaptainName from the Trip table.

ALTER TABLE Trips1
DROP CONSTRAINT fk_tblPax;

/*
Ok, now to create the intersection table for Census and remove the repeating attribute
in the Trip table.

As before, we will use a UNION to pivot the column-wise data to row-wise.
We need to create the column PaxOrder.

The basic structure of the query is this:

SELECT DISTINCT TripID, Pax1 AS Name, 1 AS PaxOrder
FROM Trip
WHERE Pax1 IS NOT NULL
UNION
SELECT DISTINCT TripID, Pax2 AS Name, 2 AS PaxOrder
FROM Trip
WHERE Pax2 IS NOT NULL
UNION
  :
  :
ORDER BY TripID ASC, PaxOrder ASC;

Write the query as shown above. It should return 424 rows.

TripID Name           PaxOrder
1      Austin Pardue  1
1      Giles Pardue   2
2      Austin Pardue  1
2      Giles Pardue   2
3      Aline Pardue   1
      :
	  :

We need to include WHERE Pax IS NOT NULL because the Trip table is a 
sparsely filled matrix (the number of passengers can range from 0-7).

*/
SELECT DISTINCT TripID, Pax1 AS PaxName, 1 AS PaxOrder
FROM Trips1
WHERE Pax1 IS NOT NULL
UNION
SELECT DISTINCT TripID, Pax2 AS PaxName, 2 AS PaxOrder
FROM Trips1
WHERE Pax2 IS NOT NULL
UNION
SELECT DISTINCT TripID, Pax3 AS PaxName, 3 AS PaxOrder
FROM Trips1
WHERE Pax3 IS NOT NULL
UNION
SELECT DISTINCT TripID, Pax4 AS PaxName, 4 AS PaxOrder
FROM Trips1
WHERE Pax4 IS NOT NULL
UNION
SELECT DISTINCT TripID, Pax5 AS PaxName, 5 AS PaxOrder
FROM Trips1
WHERE Pax5 IS NOT NULL
UNION
SELECT DISTINCT TripID, Pax6 AS PaxName, 6 AS PaxOrder
FROM Trips1
WHERE Pax6 IS NOT NULL
UNION 
SELECT DISTINCT TripID, Pax7 AS PaxName, 7 AS PaxOrder
FROM Trips1
WHERE Pax7 IS NOT NULL
ORDER BY TripID ASC, PaxOrder ASC;


--Create the intersection table for Census. Make CensusID an IDENTITY and start with 1000.
--Include the two FKs for Trip and Pax, PaxOrder, and Name (to match PK/FKs).

SELECT TripID, PaxName, PaxOrder
INTO TblCensus
FROM(SELECT DISTINCT TripID, Pax1 AS PaxName, 1 AS PaxOrder
FROM Trips1
WHERE Pax1 IS NOT NULL
UNION
SELECT DISTINCT TripID, Pax2 AS PaxName, 2 AS PaxOrder
FROM Trips1
WHERE Pax2 IS NOT NULL
UNION
SELECT DISTINCT TripID, Pax3 AS PaxName, 3 AS PaxOrder
FROM Trips1
WHERE Pax3 IS NOT NULL
UNION
SELECT DISTINCT TripID, Pax4 AS PaxName, 4 AS PaxOrder
FROM Trips1
WHERE Pax4 IS NOT NULL
UNION
SELECT DISTINCT TripID, Pax5 AS PaxName, 5 AS PaxOrder
FROM Trips1
WHERE Pax5 IS NOT NULL
UNION
SELECT DISTINCT TripID, Pax6 AS PaxName, 6 AS PaxOrder
FROM Trips1
WHERE Pax6 IS NOT NULL
UNION 
SELECT DISTINCT TripID, Pax7 AS PaxName, 7 AS PaxOrder
FROM Trips1
WHERE Pax7 IS NOT NULL) AS TripPaxCensus
ORDER BY TripID ASC, PaxOrder ASC;

ALTER TABLE TblCensus
ADD CensusID INT IDENTITY (1000,1) PRIMARY KEY;

ALTER TABLE tblCensus
ADD PaxID INT NULL

ALTER TABLE Trips1
ADD CensusID INT NULL
/*
/*

Using the query written above, populate the Census table and write a query to show the result.

Should insert 424 rows.

CensusID TripID PaxID PaxOrder Name
1000     1       NULL 1       Austin Pardue
1001     1       NULL 2       Giles Pardue
1002     2       NULL 1       Austin Pardue
1003     2       NULL 2       Giles Pardue
1004     3       NULL 1       Aline Pardue
1005     3       NULL 2       Jessica Futral
     :
	 :
*/
select CensusID, TripID, PaxID, PaxOrder, PaxName
from TblCensus

/*
Update the FK for PaxID in the Census table (replace the NULL values).

Should look like this:

CensusID TripID PaxID PaxOrder Name
1000     1      513   1       Austin Pardue
1001     1      540   2       Giles Pardue
1002     2      513   1       Austin Pardue
1003     2      540   2       Giles Pardue
1004     3      503   1       Aline Pardue
1005     3      552   2       Jessica Futral
     :
	 :
*/
--Confirm update by JOINing Trip, Census and Pax tables.The result should be 424 rows.

UPDATE Trips1
SET Trips1.CensusID = tblCensus.CensusID
FROM tblCensus, Trips1
WHERE Trips1.CaptainName = tblCensus.PaxName 

UPDATE tblCensus
SET tblCensus.PaxID = tblPax.PaxID
FROM tblCensus,tblPax
WHERE tblCensus.PaxName = tblPax.PaxName

SELECT COUNT(*)
FROM tblCensus 
     INNER JOIN 
	 tblPax ON tblCensus.PaxID = tblPax.PaxID     
     INNER JOIN 
	 Trips1 ON tblCensus.TripID = Trips1.TripID

--Create a referential integrity constraint for both FKs in the Census table.

ALTER TABLE tblCensus
ADD CONSTRAINT fk_tblPaxCensus
FOREIGN key (PaxID)
REFERENCES tblPax(PaxID);

--ALTER TABLE slCensus DROP CONSTRAINT fk_CensusPaxID;

ALTER TABLE tblCensus
DROP CONSTRAINT fk_tblPaxCensus;

--Test by attempting to delete an appropriate Trip or Pax.

DELETE FROM tblCensus
WHERE PaxID = 546;

--Now to clean up and drop columns.

SELECT * FROM Trips1;

ALTER TABLE Trips1
DROP COLUMN Pax1, Pax2, Pax3, Pax4, Pax5, Pax6, Pax7, CaptainName;

--Drop Name from the Pax table.

ALTER TABLE tblPax
DROP COLUMN PaxName;

--Drop Name from the Census table.

ALTER TABLE tblCensus
DROP COLUMN PaxName

--Drop the repeating attributes Pax1... from the Trip table.


/*********************************************************************
6. JOIN new tables. Should return 424 rows.
*********************************************************************/

SELECT COUNT(*)
FROM tblCensus 
     INNER JOIN 
	 tblPax ON tblCensus.PaxID = tblPax.PaxID     
     INNER JOIN 
	 Trips1 ON tblCensus.TripID = Trips1.TripID
