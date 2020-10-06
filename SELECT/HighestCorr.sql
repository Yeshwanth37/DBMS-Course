/*
List slSupplier.SupplierName, HighestRepairCost, and HighestMaintCost for all suppliers.
HighestRepairCost is the max cost of a repair for a given supplier.
Highest MaintCost is the max cost of a mainteance item for a given supplier.
Replace NULL values with zero (0) using the ISNULL function.
Write this query as a correlated subquery in the SELECT clause.
Order the result by slSupplier.SupplierName ASC order.
*/
SELECT slSupplier.SupplierName, 
       (SELECT ISNULL(MAX(RepairCost),0) 
        FROM slRepair
        WHERE slRepair.SupplierID = slSupplier.SupplierID) AS HighestRepairCost,
       (SELECT ISNULL(MAX(MaintenanceCost),0) 
        FROM slMaintenance
        WHERE slMaintenance.SupplierID = slSupplier.SupplierID) AS HighestMaintCost
FROM slSupplier
ORDER BY slSupplier.SupplierName ASC;