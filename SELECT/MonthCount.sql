/*
Sales wants a report that shows the number of repairs for each supplier for the months of January and June.
List slSupplier.SupplierName, JanuaryCnt, and JuneCnt.
JanuaryCnt is the count of the number of repairs for a given supplier for January.
JuneCnt is the count of the number of repairs for a given supplier for June.

Order the result by slSupplier.SupplierName ASC.
*/
SELECT SupplierName, 
	   (SELECT count(*) 
	   FROM slRepair 
	   WHERE slRepair.SupplierID = slSupplier.SupplierID AND MONTH(RepairDate) = 1) AS Januarycnt,
	   (SELECT count(*)  
	   FROM slRepair 
	   WHERE slRepair.SupplierID = slSupplier.SupplierID AND MONTH(RepairDate) = 6) AS Junecnt
FROM slSupplier 
Order By SupplierName;