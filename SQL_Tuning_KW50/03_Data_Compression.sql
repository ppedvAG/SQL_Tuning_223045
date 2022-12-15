--Durch Compression können Datensätze in Tabellen oder Indizes komprimiert werden, somit weniger Speicherplatz
--> weniger I/O Reads --> bessere Performance
--Es können ROWs oder PAGEs komprimiert werden (nicht beides)

--Eingebaute Procedure, mit der Tabellen nach Komprimierungs Potenzial durchsucht werden können:
EXEC sp_estimate_data_compression_savings dbo, Produktion, NULL, NULL, ROW 
EXEC sp_estimate_data_compression_savings dbo, Test, NULL, NULL, PAGE

CREATE INDEX NCIX_ID ON Test (ID)

--Index Compression:
ALTER INDEX NCIX_ID ON dbo.Test 
REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = ROW)

--Table Compression:
ALTER TABLE t2
REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = ROW)

SET STATISTICS TIME, IO ON

SELECT ID FROM test
--10.000 Lesevorgänge

--Mit Index Compression 17 Lesevorgänge

SELECT * FROM test

--"Nachteil: CPU Zeit verlängert (aber gleichzeitig verkürzt da weniger I/O"
--Compression in 99% der Fälle positiver Einfluss



CREATE Table Komprimierung
(
ID int identity,
Produktionsmenge int,
String char(100)
)

INSERT INTO Komprimierung
SELECT
CAST(RAND()*20 + 5 as int), 'xyz'
GO 100000


SELECT * FROM Komprimierung

EXEC sp_estimate_data_compression_savings dbo, Test, NULL, NULL, ROW
EXEC sp_estimate_data_compression_savings dbo, Komprimierung, NULL, NULL, PAGE

CREATE INDEX NCIX_Komprimierung ON Komprimierung (Produktionsmenge)
SET STATISTICS  IO,TIME ON
SELECT Produktionsmenge FROM Komprimierung
--Lesevorgänge 297, CPU 30ms, Time 918ms

ALTER INDEX NCIX_Komprimierung ON Komprimierung
REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = ROW)

SELECT Produktionsmenge FROM Komprimierung
--Lesevorgänge 212, CPU 30ms, Time 873ms


