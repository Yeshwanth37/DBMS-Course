/*
List slTrip.TripStart, slTrip.TripHour, slTrip.WaterTemp for trips in June 2011 and AvgHour, and AvgTemp for all trips.
AvgHour is the average TripHour for all trips.
AvgTemp is the average WaterTemp for all trips.
Round Averages to two decimal places.
Write this as an uncorrelated subquery in the SELECT clause.
Order the result by slTrip.TripStart ASC.
*/
SELECT slTrip.TripStart,
       slTrip.TripHour,
       slTrip.WaterTemp,
       (SELECT ROUND(AVG(TripHour), 2)
       FROM slTrip) AS AvgHour,
       (SELECT ROUND(AVG(WaterTemp), 2)
       FROM slTrip) AS AvgTemp
FROM slTrip
WHERE Datepart(month, TripStart) = 6 
      AND 
      Datepart(year,TripStart) = 2011
ORDER BY slTrip.TripStart ASC