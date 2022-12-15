/* Indizes/Indexes

Grundsätzlich 2 bzw. 3 Typen von Indizes
1. Clustered-Index / Gruppierte Index
2. Non-Clustered-Index
3. COLUMN Store Index

*/

SELECT * FROM t2

/*

1. 
CIX = genau einer pro Tabelle
Sortiert die Datensätze anhand der angegebenen Spalte physikalisch
Organisiert in so genannten B-Trees

Ohne CIX, also wenn ein HEAP vorliegt, wird automatisch der ganze TAble gescannt
*/
SET STATISTICS IO, TIME ON

SELECT * FROM t2
WHERE ID = 500

SELECT TOP 1 * FROM t2
WHERE ID = 500

--CIX auf t2 erstellen:

CREATE CLUSTERED INDEX CIX_ID
ON t2 (ID)

SELECT * FROM t2
WHERE ID = 7500

SELECT * FROM t2
WHERE ID = 7500 OR ID = 50

SELECT * FROM t2
WHERE ID > 7500

SELECT * FROM t2
WHERE ID > 50

SELECT * FROM t2
WHERE String LIKE '%'


--Primary Key CONSTRAINT erstellt automatisch einen Clustered INDEX

ALTER TABLE t2
ADD PRIMARY KEY (ID)

--Table SCAN = Durchsucht die gesamte Tabelle
--Index SCAN = Durschucht den gesamten INDEX
--SEEK = "Findet" direkt den richtigen Datensatz (= "am besten")

/*

2. NON Clustered INDEX (NCIX)
Können bis zu 1000 Stück pro Tabelle angelegt werden
Referenzieren den Speicherort (Page) wo der Datensatz zu finden ist
Benötigen physikalischen Speicher


"Index Strategie":
- CIX meistens auf Primary Key sinnvoll; sind besonders gut, wenn spezielle Werte gesucht werden
(WHERE ID = 5)
- NCIX machen auf Foreign Keys fast immer Sinn. Sind besonders nützlich bei JOINs (daher gut auf Foreign Keys)
- Werden Spalten oft Selected oder in Where gefiltert, sind Indizes grundsätzlich gut auf diesen Spalten
- Indizes wenn möglich vermeiden, bei Tabellen mit vielen Writes (müssen sich ständig aktualisieren)
(UPDATE = DELETE + INSERT)


Für jeden Index wird eine Statistik erstellt --> diese sampled die Datenmenge und optimiert anhand
der Auswertung den Index


*/

USE TUNING

SELECT * FROM query

/*

COLUMN Store Index:
- Ordnet die Datensätze einer Tabelle spaltenweise an (Erst alle Daten aus Spalte 1, dann aus Spalte 2 usw.) (CIX und NCIX sind reihenweise (rowstore))
- Ebenfalls, wie Clustered Index, eine physikalische Anordnung der Daten in den Pages
--> Entweder CIX oder Column Store Index auf einer Tabelle, beides geht nicht
- Nimmt Datensätze in 1 Mio Schritten, und ordnet diese
- Ideal für SEHR große Tabellen, bei denen vor Allem spaltenweise abgefragt wird (WHERE Produktionsjahr = 2021 bspw.)
