/*
List slWayPoint.WayPointID, slWayPoint.WayPoint and WayPointCnt where the slTrip.WaterTemp was > 90.
WayPointCnt is the count of the number of trips for a given WayPoint.
Write this query as a subquery in the FROM clause.
Order the result by WayPointCnt DESC, slWayPoint.WayPointID ASC.
*/
SELECT slWayPoint.WayPointID,
       slWayPoint.WayPoint,
       WayPointCnt
FROM (SELECT WayPointID,
             COUNT(*) AS WayPointCnt
      FROM slFloatPlan 
           INNER JOIN slTrip
                   ON slFloatPlan.TripID = slTrip.TripID
      WHERE slTrip.WaterTemp > 90
      GROUP BY WayPointID) AS vwWayPointCnt
      INNER JOIN slWayPoint 
              ON vwWayPointCnt.WayPointID = slWayPoint.WayPointID
ORDER By WayPointCnt DESC,slWayPoint.WayPointID ASC;