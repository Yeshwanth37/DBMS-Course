/*
List all the passengers who have sailed with "Suzanne Pardue".
Note, this query will be written as nested WHERE IN() queries. We will write it this way to avoid using DISTINCT.
There is a 1:M relationship between slPax and slCensus. If the outer query is an INNER JOIN of these two tables, we will have to use DISTINCT to remove duplicates.
It is best practice to avoid DISTINCT as it requires a sort. If we can get the same result by restructuring the query, that is better. In addition, if the many table is relatively large, a nested WHERE IN() will have a huge performance impact.
The basic structure for this query will be:
outerquery WHERE PK IN(First subquery WHERE fk IN(innermost subquery WHERE condition))
The innermost query gets the trips Suzanne has been on.
The middle query gets the passenger list (those who sailed with her)
The outer query prints passenger information excluding Suzanne.

The subqueries could be formulated as a self-join as well. We essentially have to query slCensus twice, once to get the list of TripIDs for Suzanne Pardue and once to find the PaxIDs for her co-passengers. We could write a subquery for each list and INNER JOIN them.

Provide a list of slPax.PaxID, slPax.PaxFirstName, slPax.PaxLastName for all passengers who sailed with (were passengers with) Suzanne Pardue (PaxID=180).
Do not include Suzanne Pardue in the resulting list.
This query can be solved without a subquery. Prove it to youself; try to get the result without a subquery. The innermost subquery is uncorrelated and must be derived separately.
Order the result by slPax.PaxLastName, slPax.PaxFirstName ASC.
*/
SELECT slPax.PaxID, 
       slPax.PaxFirstName,
       slPax.PaxLastName
FROM slPax
WHERE slPax.PaxID <> 180 AND
      slPax.PaxID IN (SELECT slCensus.PaxID
                      FROM slCensus
                      WHERE TripID IN(SELECT slCensus.TripID
                                      FROM slCensus
                                      WHERE PaxID = 180))
ORDER BY slPax.PaxLastName,
         slPax.PaxFirstName ASC