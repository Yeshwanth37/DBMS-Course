/*
List slGearPurchase.SupplierID and PurchaseAvg for all purchases in slGearPurchase.
PurchaseAvg is the average purchase price for a given supplier. ROUND() to two decimal places.
Only show Suppliers having PurchaseAvg greater than the average purchase price for all purchases in the table.
Order the result by SupplierID ASC.
*/
SELECT slGearPurchase.SupplierID,
       (ROUND(AVG(slGearPurchase.PurchaseAmount), 2)) AS PurchaseAVG
FROM slGearPurchase
GROUP BY slGearPurchase.SupplierID
HAVING ROUND(AVG(slGearPurchase.PurchaseAmount), 2) > (SELECT ROUND(AVG(slGearPurchase.PurchaseAmount), 2) AS Purchaseavgtotal
                                                       FROM slGearPurchase)
ORDER BY SupplierID