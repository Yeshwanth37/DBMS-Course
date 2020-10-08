/*
How many engine hours does each captain have?
List vwEngineHours.CaptainID, CaptainName, and vwEngineHours.EngineHours for all trips in the database.
vwEngineHours.CaptainID is the CaptainID returned by the subquery in the FROM clause.
CaptainName is the concatenation of slPax.PaxFirstName and slPax.PaxLastName
vwEngineHours.EngineHours is the sum of all engine hours by CaptainID.
vwEngineHours is the alias name for the subquery in the FROM clause.
Order the result by vwEngineHours.EngineHours DESC.

NOTE: in the schema, tblTrip.CaptainID is the foreign key from tblPax.PaxID. A foreign key in the many table does not have to have the same name as the primary key in the one table. A primary key may appear in a many table multiple times to model multiple relationships/roles.
*/
SELECT vwEngineHours.CaptainID,
       (slPax.PaxFirstName + '' + slPax.PaxLastName) AS CaptainName,
       EngineHours
FROM (SELECT CaptainID, 
             SUM(TripEngineEnd - TripEngineStart) AS EngineHours
       FROM slTrip
       GROUP BY CaptainID) AS vwEngineHours INNER JOIN slPax ON
       vwEngineHours.CaptainID = slPax.PaxID
ORDER BY vwEngineHours.EngineHours DESC;