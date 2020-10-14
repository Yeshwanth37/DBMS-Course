/*
Were most repairs done on the weekend?
List WeekDay and DayCnt for all repairs in slRepair for all days of the week.
WeekDay is the day of the week the repair was performed (actually not, some repairs took mulitple days or weeks).
DayCnt is the count of the number of repairs performend on a given WeekDay.
Use DATEPART() to extract the WEEKDAY. Sunday = 1, Monday = 2, Tuesday = 3,... Saturday = 7.
Order the result by WeekDay ASC.
*/
SELECT DATEPART(Weekday, slRepair.RepairDate) AS Weekday,
       COUNT(*) AS Daycnt
FROM slRepair

GROUP BY DATEPART(Weekday, slRepair.RepairDate)
ORDER BY Weekday ASC;