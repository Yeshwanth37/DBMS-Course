/*
List slSupplier.SupplierID and slSupplier.SupplierName for suppliers who have supplied a repair item with a description containing the word "oil".
Use the LIKE '' operator to filter description for the word 'oil'.
Write this as a subquery in the WHERE clause.
Order the results by slSupplier.SupplierName ASC
*/
SELECT slSupplier.SupplierID,
       slSupplier.SupplierName
FROM slSupplier
WHERE slSupplier.SupplierID IN (SELECT slRepair.SupplierID
                                FROM slRepair
                                WHERE Description LIKE '%oil%')
ORDER BY slSupplier.SupplierName ASC;
