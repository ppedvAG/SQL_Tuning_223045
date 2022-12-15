USE Tuning

CREATE Table Produktion
(
ID int identity,
Datum date,
Produktionsmenge smallint
)

INSERT INTO Produktion
SELECT getdate()-365*4 + (365*2*RAND() - 365), --RAND() gibt einen Zufalls float Wert zwischen 0 & 1 aus
CAST(RAND()*20 + 5 as int)
GO 10000

SELECT * FROM Produktion
ORDER BY Datum


SELECT MIN(Datum), MAX(Datum) FROM Produktion

--Partitionen für 2017+2018, 2019, 2020, 2021, 2022, 2023
--Für Partitionierung müssen Indexes (vorläufig) gelöscht werden

--Vorbereitung: Files und Filegroups erstellen über Rechtsklick auf Datenbank - Properties - Files/Filegroups
--(Files sind quasi die Speicherplätze, Filegroups die Zuordnungen zu diesen)

--1. Partitionsfunktion schreiben

CREATE PARTITION FUNCTION f_ProduktionsJahre (Date)
AS RANGE RIGHT FOR VALUES ( --RIGHT or LEFT = wo sind die "Grenzen" meiner Datenmengen (linke/untere oder rechte/obere Grenze)
	'20190101', '20200101', '20210101', '20220101', '20230101','20240101' )

--2. Partitionsschema definieren

CREATE PARTITION SCHEME ps_ProduktionsJahre
AS PARTITION f_ProduktionsJahre
TO (
	'2018', '2019', '2020', '2021', '2022', '2023', [PRIMARY]
	)

--3. (Partitions) Index erstellen
CREATE CLUSTERED INDEX CIX_ID
	ON Produktion (ID)
	ON ps_ProduktionsJahre (Datum)

--Funktion zur Überprüfung --> Gibt zu jedem Datensatz die jeweilige Partitions ID aus, in der er sich befindet
SELECT $PARTITION.f_ProduktionsJahre(Datum), year(Datum) FROM Produktion
ORDER BY Datum


SELECT * FROM Produktion
WHERE YEAR(Datum) = 2023


