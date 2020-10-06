/*
NOTE: this query is to be submitted in a series of steps.
Marketing wants to analyze repair costs relative to the average cost for all repairs.
List slSupplier.SupplierName, slRepair.RepairDate, slRepair.RepairCost, and AvgCost for all repairs for which iboats.com was the supplier (Supplier ID 1509).
AvgCost is the AVG() of slRepair.RepairCost for all repairs in slRepair.
Use LEFT() to show only the first 25 characters of the description.
Use the ROUND() function to round the average repair cost to two decimal places.
Write this query as an uncorrelated subquery in the SELECT clause.
Order the result by RepairDate ASC.
*/

SELECT slSupplier.SupplierName,
       slRepair.RepairDate,
       slRepair.RepairCost,
       LEFT(Description, 25) AS Description,
       (SELECT ROUND(Avg(RepairCost), 2) As AvgCost 
       FROM slRepair) AS AvgCost
FROM slRepair 
INNER JOIN slSupplier ON slRepair.SupplierID = slSupplier.SupplierID
WHERE slSupplier.SupplierID = 1509
ORDER BY RepairDate ASC;