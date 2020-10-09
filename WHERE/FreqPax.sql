/*
Who is the most frequent passenger? We could get the answer with TOP 1 in this particular case, but that solution isn't generalizable. The TOP n approach only works if we know there isn't a tie. If there are multiple passengers with the same number of trips, we don't know what "n" should be. If we know there is only one MAX(), then we can order by COUNT(*) DESC and take the first row from the result.
A more generalized solution is to compute the MAX() dynamically and use it as a condition in either the WHERE or HAVING clause.
List vwPaxCnt.PaxID, PassengerName, and vwPaxCnt.PaxCnt where the COUNT is equal to the MAX() number of trips.
vwPaxCnt.PaxID is the PaxID returned by the inner query.
vwPaxCnt.PaxCnt is the COUNT(*) returned by the inner query.
vwPaxCnt is the alias name for the inner query.
*/
SELECT vwPaxcnt.PaxID,
       (slPax.PaxFirstName + ' ' + slPax.PaxLastName) AS PassengerName,
       vwPaxcnt.Paxcnt
FROM (SELECT slCensus.PaxID,
             COUNT(*) AS Paxcnt
      FROM slCensus
      GROUP BY slCensus.PaxID) AS vwPaxcnt
      INNER JOIN slPax
              ON vwPaxcnt.PaxID = slPax.PaxID
WHERE vwPaxcnt.Paxcnt = (SELECT MAX(vwPaxcnt.Paxcnt)
                         FROM (SELECT slCensus.PaxID,
                                COUNT(*) AS Paxcnt
                                FROM slCensus
                                GROUP BY slCensus.PaxID) AS vwPaxcnt)