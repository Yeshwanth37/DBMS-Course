/*
List slPax.PaxLastName and slPax.PaxFirstName for passengers who have sailed on a trip with exactly 3 passengers.
Write this query as two nested WHERE IN() subqueries.
This query requires a subquery because the list of TripIDs with 3 passengers must be computed separately.
*/
/*Hi Yeshwanth, Nicley done!  100%*/
SELECT slPax.PaxLastName,
       slPax.PaxFirstName
FROM slPax
WHERE slPax.PaxID IN (SELECT slCensus.PaxID
                      FROM slCensus 
                      WHERE slCensus.TripID IN (SELECT slCensus.TripID
                                                FROM slCensus
                                                GROUP BY slCensus.TripID
                                                HAVING COUNT(*) = 3))
ORDER BY slPax.PaxLastName,
         slPax.PaxFirstName ASC