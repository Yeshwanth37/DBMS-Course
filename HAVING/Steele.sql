/*
List slLaunch.LaunchID, slLaunch.Launch, and MaxWaterTemp for launches for which the maximum water temperature for all trips from that launch is greater than the max water temperature for trips from Steele Creek (LaunchID=15).
MaxWaterTemp is the maximum water temperature for slTrip.WaterTemp for each LaunchID in slTrip.
Order the result by MaxWaterTemp ascending.

No steps are given.

NOTE: DO NOT solve this query by including slLaunch.Launch in the GROUP BY. That is, do not write:
GROUP BY slLaunch.LaunchID, slLaunch.Launch
No credit will be given for this formulation in the homework or the exam.
This is poor practice for at least 5 reasons:
1. If you include a non-indexed string attribute in the GROUP BY list, performance can be very bad. GROUP BY requires a sort.
2. If the tables have many attibutes, say 350 or more, your GROUP BY list must have 350 attributes. Try debugging that... This approach is only workable in relatively simple examples In complex queries, this is unmanagable.
3. The GROUP BY portion of your query will be hard coded for a specific set of attributes in the SELECT statement and therefore not reusable. it is much better practice to save the GROUP BY portion as a VIEW and reuse it. Hard coding is almost always bad practice.
4. This is not the appropriate use of GROUP BY. The purpose of GROUP BY is grouping. We are not grouping by slLaunch.Launch. This approach is a cludge technique to avoid the error "attribute not included in the aggregate..."
*/
/*Nicely Done!   100  */
SELECT slLaunch.LaunchID, 
       slLaunch.Launch,
       vwMaxWaterTemp.MaxWaterTemp
FROM slLaunch INNER JOIN (SELECT LaunchID,
                                 MAX(WaterTemp) AS MaxWaterTemp
                          FROM slTrip
                          GROUP BY LaunchID
                          HAVING MAX(WaterTemp) > (SELECT MAX(WaterTemp) AS MaxWaterTemp
                                                   FROM slTrip
                                                   WHERE LaunchID = 15)) vwMaxWaterTemp
                      ON slLaunch.LaunchID = vwMaxWaterTemp.LaunchID
ORDER BY MaxWaterTemp ASC