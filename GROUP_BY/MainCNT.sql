/*
I was wondering if there are any seasonal patterns in maintenance.
List Month and MonthCnt for all maintenance items in slMaintenance.
Derive Month using MONTH() or DATEPART().
MonthCnt is the count of maintenance items for each month.
This is a subquery in the sense that we are grouping by a value derived by a function (a subquery can be saved as a function).
Order the result by Month ASC.
*/
SELECT DATEPART(month, slMaintenance.MaintenanceDate) MONTH,
       COUNT(MaintenanceID) MonthCnt
FROM slMaintenance
GROUP BY DATEPART(month, slMaintenance.MaintenanceDate)
ORDER BY MONTH ASC;