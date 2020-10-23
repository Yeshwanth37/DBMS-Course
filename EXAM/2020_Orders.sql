/*
The new owners of Dr. Pardue’s boat would like to know the number of orders that have been placed for maintenance on the boat. We are not interested in gear or repairs. The assumption here is that each line in the database is a separate order.

List SupplierID, SupplierName, and Orders.
Orders is based on the number of lines ordered for maintenance.
The output should be displayed with Orders in descending order.
This query needs to be completed with a FROM subquery.
*/
/*Hi Yeshwanth, 95%  Nicely done on the set up*/
SELECT slSupplier.SupplierID,
       slSupplier.SupplierName,
       Orders
FROM slSupplier INNER JOIN (SELECT COUNT(*) Orders
                                   -- here you should be counting the rows (*) and not the PK
                                   -- -5 points
                            FROM slMaintenance) AS vwOrders
                        ON slSupplier.SupplierID = vwOrders.SupplierID
ORDER BY Orders DESC