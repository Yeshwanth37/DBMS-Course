/*
List slPax.PaxLastName, slPax.PaxFirstName for passengers who have never sailed with a trip start in the afternoon, that is, a time after 12:00.
Use DATEPART() to extract the Hour and Minute portion of TripStart.
Write this is a WHERE NOT IN() query.
Order the result by slPax.PaxLastName, slPax.PaxFirstName in ascending order.
*/
SELECT slPax.PaxLastName,
       slPax.PaxFirstName
FROM slPax
WHERE slPax.PaxID NOT IN (SELECT slCensus.PaxID
                          FROM slCensus
                          WHERE slCensus.TripID IN (SELECT slTrip.TripID
                                                    FROM slTrip
                                                    WHERE
                                                    DATEPART(HOUR, slTrip.TripStart) > 12
                                                    OR
                                                    (DATEPART(HOUR, slTrip.TripStart) = 12
                                                    AND
                                                    DATEPART(MINUTE, slTrip.TripStart) > 0 )))
                                            
                                                   
ORDER BY slPax.PaxLastName, 
         slPax.PaxFirstName ASC;