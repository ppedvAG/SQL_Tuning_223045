--OVER (ORDER/PARTITION BY)
--Mit OVER(PARTITION BY Spaltenname) können "Fenster" definiert werden, für die ein Aggregat angewendet werden soll
USE Northwind
SELECT 
c.CustomerID,
Freight,
SUM(Freight) OVER(PARTITION BY c.CustomerID) as SumFreightPerCustomer, --OVER(PARTITION BY CustomerID) = "Aggregat über die Gruppen CustomerID"
SUM(Freight) OVER() as SumFreightAllCustomer, --OVER() = "Aggregat über alle Datensätze"
AVG(Freight) OVER(PARTITION BY c.CustomerID) as AvgFreightPerCustomer,
AVG(Freight) OVER() as AvgFreightAllCustomer
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, o.Freight


--LEAD() & LAG()

SELECT OrderID, Freight,
LAG(Freight, 1, 0) OVER(ORDER BY ORDERID)
FROM Orders

SELECT OrderID, Freight,
LEAD(Freight, 1, 0) OVER(ORDER BY ORDERID)
FROM Orders

--Laufender kumulierter Wert
SELECT OrderID, Freight,
SUM(Freight) OVER(ORDER BY ORDERID) as SumKumulativ
FROM Orders

--Alle bei denen der nächste Wert 0 sein wird:
SELECT OrderID, Freight,
LEAD(Freight, 1, 0) OVER(ORDER BY ORDERID) as NextWert
INTO #t
FROM Orders

SELECT * FROM #t
WHERE NextWert = 0

--NTILE() "Teilt" eine Datenmenge in NTILE(X) X Buckets und gibt die Nummer des Buckets aus, in dem der Datensatz vorliegt

USE Tuning

SELECT Land, NTILE(5) OVER(ORDER BY Land) as Gruppe INTO #t2 FROM query

SELECT * FROM #t2
WHERE Gruppe = 3

