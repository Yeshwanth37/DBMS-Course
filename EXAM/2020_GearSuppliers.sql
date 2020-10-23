/*
Lots of gear has been purchased over the years but I can’t for the life of me remember all of the suppliers that have been used in the past. It is your job to find out.
LIST SupplierID and SupplierName for suppliers that have supplied Gear. In other words, list suppliers for which there is a slGearPurchase.SupplierID.
Order the results by SupplerID ASC.
Solve this using a WHERE IN() subquery.
*/
SELECT slSupplier.SupplierID,
       slSupplier.SupplierName
FROM slSupplier
WHERE SupplierID IN (SELECT slGearPurchase.SupplierID
                     FROM slGearPurchase)
ORDER BY slSupplier.SupplierID ASC