/*
Provide a report that lists trips to Gravine Island that had more than 3 passengers (High passenger count)
List slTrip.TripStart, slTrip.TripHour, slWayPoint.WayPoint, Captain, and vwPaxCnt.PaxCnt for all trips to "Gravine Island" (WayPointID=919) that had more than 3 passengers (Pax).
vwPaxCnt.PaxCnt is the count of the number of passengers on a trip (slCensus).
vwpaxCnt is the alias name of the inner subquery in the FROM clause.
Captain is the concatenation of the slPax.PaxFirstName and slPax.PaxLastName for slTrip.CaptianID.
Order the result by sltrip.TripStart ASC.
*/
SELECT slTrip.TripStart,
       slTrip.TripHour,
       slWayPoint.WayPoint,
       (slPax.PaxFirstName + ' ' + slPax.PaxLastName) AS Captain,
       paxcnt
FROM (SELECT TripID,
             MAX(PaxOrder)As paxcnt
      FROM slCensus
      WHERE PaxOrder > 3
      GROUP BY TripID)AS vwpaxCnt 
      INNER JOIN slTrip 
              ON vwpaxCnt.TripID = slTrip.TripID
      INNER JOIN slFloatPlan 
              ON slTrip.TripID = slFloatPlan.TripID
      INNER JOIN slWayPoint
              ON slFloatPlan.WayPointID = slWayPoint.WayPointID
      INNER JOIN slPax
              ON slTrip.CaptainID = slPax.PaxID
WHERE slWayPoint.WayPointID = 919
ORDER BY TripStart ASC;