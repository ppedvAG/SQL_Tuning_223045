/*

Normalisierung einer Datenbank
Relationale Datenbanken sind i.d.R. normalisiert, es existieren 5 sogenannte Normalformen, 
die aufeinander aufbauen

Ausreichend bis 3. Normalform (Standard); 
4. & 5. sind sehr theoretisch/wissenschaftlich und wenig relevant in der Praxis

Stufen:

1. Pro Zelle nur ein Wert (atomar)! Also nicht Vor + Nachname in einer Zelle
Streng genommen auch Adressen --> Stra�e + Hausnummer getrennt!

2. Jeder Datensatz einzigartig/eindeutig/unique --> Primary Keys

3. Keine "Beziehungen" zwischen Tabellen/Datens�tzen au�erhalb von Primary/Foreign Keys

--> Normalform verhindert Redundanzen!
--> Nachteil: Redundanz w�re schneller; Joins sind langsam

**************************************************************************

Datens�tze einer Datenbank werden in sogenannten Seiten(Pages) abgespeichert:
- 8 Seiten ergeben einen "Block"
- Jede Seite kann bis zu 8060 Bytes Datens�tze enthalten (Restlichen 132 Bytes der Seite sind Management Infos)
- Eine Seite kann unabh�ngig vom Speicherplatz nur maximal 700 Datens�tze speichern
- Wenn einzelner Datensatz gr��er als 8kb --> Row Overflow, Infos werden auf n�chster Seite weitergef�hrt

Ben�tigter Speicherplatz unserer Datens�tze ist relevant, weil Daten 1 zu 1 von HDD in Memory geladen werden
--->Pages sollten m�glichst voll sein, um unn�tig viele Reads zu vermeiden
Guter Richtwert: �ber 80% Seitendichte, ab 90% sehr gut

*/


CREATE DATABASE Tuning

USE Tuning

DROP TABLE test
CREATE TABLE Test (
ID int identity,
String char(4200))

INSERT INTO test
SELECT 'abc'
GO 10000

SELECT * FROM Test

dbcc showcontig('test')
--Befehl zeigt Seiteninfos der angegebenen Tabelle 
--Seitendichte nur bei ~52%


CREATE TABLE t2 (
id int identity,
String char(5))

INSERT INTO t2
SELECT 'abc'
GO 10000

dbcc showcontig('t2')


SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED');
--Zeigt umfassende Infos �ber alle Tables/Objects in der Datenbank (Seitendichte, Auslastung, Indizes etc.)
SELECT OBJECT_ID('t2')
SELECT DB_ID('tuning')

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Customers' --Zeigt Spalteninfos einer Tabelle
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'Country' --Zeigt Tabelle(n), in denen die angegbene Spalte gefunden wird
SELECT * FROM INFORMATION_SCHEMA.TABLES --Zeigt alle Tabellen(infos) der Datenbank

SET STATISTICS TIME, IO OFF
--SET STATISTICS ON/OFF; Time = verstrichene Server und CPU Zeit; IO = Input/Output, d.h. wieviele Datens�tze wurden gelesen


