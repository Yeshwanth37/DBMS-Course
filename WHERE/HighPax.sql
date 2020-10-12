/*
This is the same query from the FROM homework. Rewrite as a WHERE IN() query.
Do NOT list vwPaxCnt.PaxCnt.
Filter for trips with more than 3 passengers in a WHERE IN() clause.
The WHERE IN() formulation ran a little faster than the FROM formulation.

Provide a report that lists trips to Gravine Island that had more than 3 passengers (High passenger count)
List slTrip.TripStart, slTrip.TripHour, slWayPoint.WayPoint, and Captain for all trips to "Gravine Island" (WayPointID=919) that had more than 3 passengers (Pax).
Captain is the concatenation of the slPax.PaxFirstName and slPax.PaxLastName for slTrip.CaptianID.
Order the result by sltrip.TripStart ASC.
*/
SELECT slTrip.TripStart,
       slTrip.TripHour,
       slwaypoint.waypoint,
       (slpax.paxFirstName + ' ' + slpax.paxLastName) AS Captain
FROM slpax  INNER JOIN slTrip
                    ON slpax.PaxID = slTrip.CaptainID
            INNER JOIN slCensus
                    ON slTrip.TripID = slCensus.TripID
            INNER JOIN slFloatPlan
                    ON slTrip.TripID = slFloatPlan.TripID
            INNER JOIN slwaypoint
                    ON slFloatPlan.waypointID = slwaypoint.waypointID
WHERE slCensus.TripID IN (SELECT slCensus.TripID
                          FROM slCensus
                          WHERE slCensus.PaxOrder > 3
                          GROUP By slCensus.TripID) 
                          AND 
                          slwaypoint.waypointID = 919
GROUP By slTrip.TripStart,
         slTrip.TripHour,
         slwaypoint.waypoint,
        (slpax.paxFirstName + ' ' + slpax.paxLastName)
ORDER BY slTrip.TripStart ASC;