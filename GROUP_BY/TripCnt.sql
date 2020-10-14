/*
List EngineMinute and TripCnt for all trips for which EngineMinute is greater than zero.
EngineMinute is the number of minutes the engine ran for a trip.
EngineMinute is computed by multiplying the difference between engine start and end by 60. ROUND() to zero decimal places.
TripCnt is the count of the number of trips for a given EngineMinute.
Order the result by TripCnt DESC
*/
SELECT ROUND(((TripEngineEnd - TripEngineStart) * 60),0) AS EngineMinute,
       COUNT(*) AS TripCnt
FROM slTrip
WHERE ROUND(((TripEngineEnd - TripEngineStart) * 60),0)>0
GROUP BY ROUND(((TripEngineEnd - TripEngineStart) * 60),0)
ORDER BY TripCnt DESC
