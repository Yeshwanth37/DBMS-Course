/*
List WayPointCnt and AvgTripMinute for WayPointCnt having an average greater than the average TripMinute for all trips in the database.
WayPointCnt is the number of waypoints on a trip.
AvgTripMinute is the average number of minutes for trips for a certain WayPointCnt.
One question to ask is if trips with more waypoints have, on average, a longer duration.
Only show WayPointCnt if the AvgTripMinute is greater than the average TripMinute for all trips in the table.
This query requires that you derive two separate results with TripID as the joining key. You must derive the waypoint count from flFloatPlan and the TripMinutes from slTrip. The common attribute accross these two results is TripID.
Order the result by WayPointCnt ASC.
*/
SELECT vwWayPointCnt.WayPointCnt,
       AVG(vwTripMinute.TripMinute) AVGTripMinute
FROM (SELECT TripID,
             COUNT(*) AS WayPointCnt
      FROM slFloatPlan
      GROUP BY TripID) AS vwWayPointCnt
      INNER JOIN (SELECT TripID,
                         DATEDIFF(Minute, TripStart, TripEnd) AS TripMinute
                  FROM slTrip) AS vwTripMinute
              ON vwWayPointCnt. TripID = vwTripMinute.TripID
GROUP BY vwWayPointCnt.WayPointCnt
HAVING AVG(vwTripMinute.TripMinute) > (SELECT  AVG(DATEDIFF(Minute, TripStart, TripEnd)) AS TripMinuteTotal
                                       FROM slTrip)
ORDER BY vwWayPointCnt.WayPointCnt