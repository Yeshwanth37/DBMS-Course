/*
List slSupplier.SupplierName, WestMarineCnt, and TotalCnt for SupplierID=1518.

WestMarineCnt is the number of times West Marine (SupplierID=1518) has been used for gear.

TotalCnt is the total number of gear records

There is no need to CONVERT() WestMarineCnt or TotalCnt.

Solve using an uncorrelated SELECT subquery.
*/
/*Nicely done Yeshwanth!  100 */
SELECT slSupplier.SupplierName,
       (SELECT COUNT(*)
        FROM slGearPurchase
        WHERE slGearPurchase.SupplierID = 1518) WestMarineCnt,
       (SELECT COUNT(*)
        FROM slGearPurchase) TotalCnt
FROM slSupplier
WHERE slSupplier.SupplierID = 1518
