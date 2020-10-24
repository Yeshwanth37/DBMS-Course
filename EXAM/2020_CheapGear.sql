/*
We want to find out the suppliers that have lower gear costs than West Marine (SupplierID = 1518).
List SupplierID and the AvgGearCost.
AvgGearCost is the AVG() of PurchaseAmount for all gear items.
Use the ROUND() function to round the average to two decimal places.
Only show AvgGearCost if the AvgGearCost is lower than the average gear purchases at West Marine (SupplierID = 1518).
Order the results in descending order based on the AvgGearCost.
This query needs to be completed with a HAVING subquery!
*/
SELECT slGearPurchase.SupplierID,
       ROUND(AVG(slGearPurchase.PurchaseAmount),2) AS AvgGearCost
FROM slGearPurchase
GROUP BY slGearPurchase.SupplierID
HAVING ROUND(AVG(slGearPurchase.PurchaseAmount),2) < (SELECT ROUND(AVG(slGearPurchase.PurchaseAmount),2) AS AvgGearCost
                                                      FROM slGearPurchase
                                                      WHERE slGearPurchase.SupplierID = 1518)
ORDER BY AvgGearCost DESC