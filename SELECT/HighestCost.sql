/*
List slSupplier.SupplierName, HighestRepairCost, HighestMaintCost, and HighestOverallCost where supplier is West Marine (SupplierID = 1518).
HighestRepairCost is the max cost of a repair for West Marine.
Highest MaintCost is the max cost of a mainteance item for West Marine.
HighestOverallCost is the highest cost for both repairs and maintenance for any supplier.
Write this query as an uncorrelated subquery in the SELECT clause.
*/
SELECT DISTINCT slSupplier.SupplierName,
       (SELECT ISNULL(MAX(RepairCost),0) AS highestrepaircost 
        FROM slRepair 
        WHERE supplierID = 1518) HighestRepairCost,
       (SELECT MAX(MaintenanceCost) AS highestmaintcost 
        FROM slMaintenance 
        WHERE supplierID = 1518)HighestMaintCost,
       (SELECT ISNULL(MAX(AB.MAXValue),0) AS highestoverallcost
        FROM (SELECT ISNULL(MAX(RepairCost),0) AS MAXValue
        FROM slRepair 
        UNION 
        SELECT MAX(MaintenanceCost) AS MAXValue
        FROM slMaintenance) AS AB) HighestOverallCost
FROM slSupplier
WHERE slSupplier.SupplierID = 1518;