/*
List PurchasePrice and PurchaseCnt for all purchases in slGasPurchase. Exclude purchases with a zero cost per gallon.
PurchasePrice is computed as (gallons * CostPerGallon) rounded to zero decimal places (only the dollar amount).
PurchaseCnt is the count of the number of gas purchases at a given PurchasePrice.
Order the result by PurchaseCnt and PurchasePrice DESC.
*/
SELECT ROUND((gallons * CostPerGallon),0) AS PurchasePrice,
        COUNT(*) AS PurchaseCnt
FROM slGasPurchase
WHERE CostPerGallon <> 0
GROUP BY ROUND((gallons * CostPerGallon),0)
ORDER BY PurchaseCnt DESC, 
         PurchasePrice DESC