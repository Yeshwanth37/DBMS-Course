/*
The sales department wants to know the percentage of repairs that had parts supplied by iboats.com.
List the slSupplier.SupplierName, SuppCnt, TotalCnt, and SuppPct for supplier iboats.com (SupplierID 1509).
SuppCnt is number (count) of repairs (slRepair) for which iboats.com was the supplier.
TotalCnt is the number (count) of repairs in slRepair.
SuppPct is the percentage of repairs (SuppCnt/TotalCnt). Use CONVERT() to cast COUNT(*) as FLOAT for division operator.
Write this query as an uncorrelated subquery in the SELECT clause.
*/
SELECT SupplierName,
       (SELECT CONVERT(Float,Count(*)) as suppcnt --this as is not needed 
        FROM slRepair 
        WHERE supplierID = 1509) as suppcnt,
       (SELECT CONVERT(Float,Count(*)) as totalcnt 
        FROM slRepair) as totalcnt,
       ((SELECT CONVERT(Float,Count(*)) as suppcnt 
        FROM slRepair 
        WHERE supplierID = 1509)
        /
        (SELECT CONVERT(Float,Count(*)) as totalcnt 
        FROM slRepair)) as supppct
FROM Slsupplier 
WHERE supplierID = 1509;