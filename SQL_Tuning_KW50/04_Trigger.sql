--TRIGGER = "Ausl�ser"
--Pr�fen einen Input und k�nnen anhand dessen eine Abfrage "ver�ndern"
--Werden genutzt f�r INSERT/UPDATE/DELETE


--Grundstruktur Trigger:
CREATE TRIGGER TriggerTest --Name
ON query --auf welchem Table
FOR/AFTER bzw. INSTEAD OF --"zu welchem Zeitpunkt"
INSERT / UPDATE / DELETE --welcher Befehl l�st Trigger aus
AS
Anweisung --was soll der Trigger machen

CREATE TRIGGER TriggerTest
ON query INSTEAD OF INSERT
AS 
DECLARE @Land varchar(20), @Zeug varchar(20)
SELECT @Land = Land, @Zeug = Zeug FROM INSERTED
	IF @Land = 'C' SET @Zeug = 'lmo'
INSERT INTO query (land, zeug)
VALUES (@Land, @Zeug)
--Dieser Trigger nimmt die VALUES eines INSERT Statements, pr�ft deren Wert, und ver�ndert unter Umst�nden
--die Werte, bevor er den tats�chlichen INSERT durchf�hrt

INSERT INTO query
VALUES ('A', 'ghj')

INSERT INTO query
VALUES ('C', 'ghj')

SELECT * FROM query
WHERE Land = 'C'


CREATE PROC TestProc @Land varchar(10), @Zeug varchar(10)
AS
INSERT INTO query
VALUES (@Land, @Zeug)


EXEC TestProc C, zzz



Create TRIGGER Nachricht
ON Test INSTEAD OF INSERT
AS 
PRINT 'Nein geht nicht!'


INSERT INTO Test
VALUES ('xy')