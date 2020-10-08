/*
Provide a report that lists the number of trips per launch.
List LaunchName, vwLaunchCnt.LaunchID, and LaunchCnt.
LaunchName is the alias for slLaunch.Launch.
vwLaunchCnt.LaunchID is the Id returned by the inner subquery. "vwLaunchCnt" is the alias given to the subquery in the FROM clause. If this subquery were saved as a view, this is the name I would use for the view.
LaunchCnt is the COUNT of trips for a given launch.

Order the result by LaunchCnt in DESC order.
*/
SELECT slLaunch.Launch AS LaunchName,
	   vwLaunchCnt.LaunchID,
	   LaunchCnt  
FROM (SELECT LaunchID,
            COUNT(*) AS LaunchCnt
      FROM slTrip
      GROUP BY launchID) AS vwLaunchCnt 
      INNER JOIN slLaunch ON vwLaunchCnt.launchID = slLaunch.LaunchID
ORDER BY LaunchCnt DESC;