/*
List slTrip.TripID, slTrip.TripStart, WayPoint1, WayPoint2, and WayPoint3 for trips that have at least three waypoints (WayPointOrder = 3).
WayPoint1, 2, and 3 are the names of the WayPoints for each point on the float plan.
Test your inner queries with TripID=22. The Float Plan for TripID 22 is WP1="Delta", WP2="Bay", WP3="Dog River Bridge".
Write this as a correlated subquery in the SELECT statement.
You will have to use an alias for your outer query for the table slFloatPlan (or for your subqueries... either way). You will be referencing slFloatPlan twice.
*/

SELECT A.tripid,
       MAX(sltrip.tripstart) AS tripstart, -- should only have one tripstart per trip
       -- unneccessary MAX function
       MAX(CASE WHEN slFloatPlan.WayPointOrder = 1 then slwaypoint.WayPoint end) AS WayPoint1,
       MAX(CASE WHEN slFloatPlan.WayPointOrder = 2 then slwaypoint.WayPoint end) AS WayPoint2,
       MAX(CASE WHEN slFloatPlan.WayPointOrder = 3 then slwaypoint.WayPoint end) AS WayPoint3
FROM slFloatPlan
     JOIN (SELECT slTrip.tripId
           FROM slTrip
           JOIN slFloatPlan ON sltrip.tripId = slFloatPlan.tripId
GROUP BY sltrip.tripId having count(WayPointOrder) >= 3)A -- improper naming of a subquery
ON slFloatPlan.tripId = a.tripId
JOIN sltrip ON sltrip.tripId = slFloatPlan.tripId -- doing a 4 table join???  WHY!!!!!
JOIN slwaypoint ON slwaypoint.WayPointID = slFloatPlan.WayPointID
GROUP BY A.tripid