/*
List slWayPoint.WayPoint for waypoints that have appeared on trips having an above average length trip (TripHour).
Write this as a subquery in the WHERE clause.
This could be written as a three table INNER JOIN. However, doing so would require a DISTINCT operation.
*/
SELECT slWayPoint.WayPoint
FROM slWayPoint
WHERE slWayPoint.WayPointID IN (SELECT slFloatPlan.WayPointID
                                FROM slFloatPlan 
                                                INNER JOIN slTrip 
                                                        ON slFloatPlan.TripID = slTrip.TripID
                                WHERE slTrip.TripHour > (SELECT AVG(TripHour)
                                                         FROM slTrip))
ORDER BY slWayPoint.WayPoint ASC;