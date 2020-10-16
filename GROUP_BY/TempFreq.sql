/*
Produce a histogram that shows the relative frequency of water temperatures on trips in units of 10.
List WaterTemp10, TempCnt, TempFreq, and TempTotal.
WaterTemp10 is the tens position of the WaterTemp value. Use LEFT() to retrieve the first (leftmost) value from slTrip.WaterTemp.
TempCnt is the count of the number of times a WaterTemp10 appears.
TempFreq is the percentage of times a WaterTemp10 appears. TempFreq is computed as (TempCnt/TotalCnt)*100.
TempTotal is a count of the total number of trips.
Order the result by WaterTemp10 ASC.
*/
SELECT (LEFT(WaterTemp, 1)) AS WaterTemp10,

       CONVERT(FLOAT, COUNT(*)) AS TempCnt,
       
       (ROUND(( CONVERT(FLOAT, COUNT(*)))/ (Select COUNT(*)
                                            FROM slTrip) * 100, 2) ) AS TempFreq,
       
       (Select CONVERT(FLOAT, COUNT(*))
        FROM slTrip) AS TempTotal

FROM slTrip
GROUP BY LEFT(WaterTemp, 1)
ORDER BY WaterTemp10