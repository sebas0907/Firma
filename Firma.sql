--------------------------------------------------------------------------------
-----------------------------Company database-----------------------------------

CREATE DATABASE Firma;
USE Firma;
CREATE TABLE mitarbeiter (
  Mitarb_id INT PRIMARY KEY,
  Vorname VARCHAR(40),
  Nachname VARCHAR(40),
  Geburstag DATE,
  Geschlecht VARCHAR(1),
  Gehalt INT,
  Branche_nr INT
);
CREATE TABLE branche (
  Branche_nr INT PRIMARY KEY,
  Branche_name VARCHAR(40),
  Mgm_id INT,
  Mgm_anfangsdatum DATE,
  FOREIGN KEY(Mgm_id) REFERENCES mitarbeiter(Mitarb_id) ON DELETE SET NULL
);
ALTER TABLE mitarbeiter
ADD FOREIGN KEY(Branche_nr)
REFERENCES branche(Branche_nr)
ON DELETE SET NULL;

CREATE TABLE kunde (
  Kunde_nr INT PRIMARY KEY,
  Kundename VARCHAR(40),
  Branche_nr INT,
  FOREIGN KEY(Branche_nr) REFERENCES branche(Branche_nr) ON DELETE SET NULL
);
CREATE TABLE umsatz (
  Mitarb_id INT,
  Kunde_nr INT,
  Nettoumsatz INT,
  PRIMARY KEY(Mitarb_id, Kunde_nr),
  FOREIGN KEY(Mitarb_id) REFERENCES mitarbeiter(Mitarb_id) ON DELETE CASCADE,
  FOREIGN KEY(Kunde_nr) REFERENCES kunde(Kunde_nr) ON DELETE CASCADE
);

-- -----------------------------------------------------------------------------
------------------------------Branches------------------------------------------
-- Berlin
INSERT INTO mitarbeiter VALUES(100, 'Daniel', 'Mueller', '1967-11-17', 'M', 250000, NULL);
INSERT INTO branche VALUES(1, 'Berlin', 100, '2006-02-09');
UPDATE mitarbeiter SET Branche_nr = 1 WHERE Mitarb_id = 100;
INSERT INTO mitarbeiter VALUES(101, 'Dennis', 'Meier', '1961-05-11', 'M', 110000, 1);

-- Koeln
INSERT INTO mitarbeiter VALUES(102, 'Holger', 'Schulze', '1964-03-15', 'M', 75000, NULL);
INSERT INTO branche VALUES(2, 'Koeln', 102, '1992-04-06');
UPDATE mitarbeiter SET Branche_nr = 2 WHERE Mitarb_id = 102;
INSERT INTO mitarbeiter VALUES(103, 'Julia', 'Richter', '1971-06-25', 'F', 63000, 2);
INSERT INTO mitarbeiter VALUES(104, 'Petra', 'Neubauer', '1980-02-05', 'F', 55000, 2);
INSERT INTO mitarbeiter VALUES(105, 'Michael', 'Niebaum', '1958-02-19', 'M', 69000, 2);

-- Muenchen
INSERT INTO mitarbeiter VALUES(106, 'Karmen', 'Voncina', '1987-11-05', 'F', 300000, NULL);
INSERT INTO branche VALUES(3, 'Muenchen', 106, '2017-02-13');
UPDATE mitarbeiter SET Branche_nr = 3 WHERE Mitarb_id = 106;
INSERT INTO mitarbeiter VALUES(107, 'Sebastian', 'Bulla', '1973-07-22', 'M', 65000, 3);
INSERT INTO mitarbeiter VALUES(108, 'Bianca', 'Bromeier', '1978-10-01', 'F', 71000, 3);
INSERT INTO mitarbeiter VALUES(109, 'Tim', 'Eschman', '1969-09-05', 'M', 78000, 3);


-- Kunden
INSERT INTO kunde VALUES(400, 'Geda Labels GmbH', 2);
INSERT INTO kunde VALUES(401, 'Krueger GmbH', 2);
INSERT INTO kunde VALUES(402, 'DHL', 3);
INSERT INTO kunde VALUES(403, 'Lime', 3);
INSERT INTO kunde VALUES(404, 'Bild', 2);
INSERT INTO kunde VALUES(405, 'Powerservice GmbH', 3);
INSERT INTO kunde VALUES(406, 'DHL', 2);

-- Umsatz
INSERT INTO umsatz VALUES(105, 400, 55000);
INSERT INTO umsatz VALUES(102, 401, 267000);
INSERT INTO umsatz VALUES(108, 402, 22500);
INSERT INTO umsatz VALUES(107, 403, 5000);
INSERT INTO umsatz VALUES(108, 403, 12000);
INSERT INTO umsatz VALUES(105, 404, 33000);
INSERT INTO umsatz VALUES(107, 405, 26000);
INSERT INTO umsatz VALUES(102, 406, 15000);
INSERT INTO umsatz VALUES(105, 406, 130000);
-----------------------------------------------------------------------------------------
-------------------------------- Some queries--------------------------------------------

-- Displays the names of the managers and their corresponding branches:

SELECT Vorname, Nachname, Branche_name FROM mitarbeiter JOIN branche ON mitarbeiter.Mitarb_id = branche.Mgm_id;

-- Displays the employee with the highest income:

SELECT * FROM mitarbeiter WHERE Gehalt IN (SELECT max(salary) FROM mitarbeiter);

-- Displays the employee with the third highest income:

SELECT * FROM mitarbeiter ORDER BY Gehalt DESC LIMIT 1 offset 2;

--Displays the names of the employees with highest income in their corresponding department:

SELECT DISTINCT Vorname, Nachname, Gehalt, Branche_name FROM
mitarbeiter JOIN branche ON mitarbeiter.Branche_nr = branche.Branche_nr
WHERE Gehalt = (SELECT max(Gehalt) FROM mitarbeiter JOIN branche ON
mitarbeiter.Branche_nr = branche.Branche_nr WHERE branche.Branche_name = 'Berlin')
UNION
SELECT DISTINCT Vorname, Nachname, Gehalt, Branche_name FROM
mitarbeiter JOIN branche ON mitarbeiter.Branche_nr = branche.Branche_nr
WHERE Gehalt = (SELECT max(Gehalt) FROM mitarbeiter JOIN branche ON
mitarbeiter.Branche_nr = branche.Branche_nr WHERE branche.Branche_name = 'Koeln')
UNION
SELECT DISTINCT Vorname, Nachname, Gehalt, Branche_name FROM
mitarbeiter JOIN branche ON mitarbeiter.Branche_nr = branche.Branche_nr
WHERE Gehalt = (SELECT max(Gehalt) FROM mitarbeiter JOIN branche ON
mitarbeiter.Branche_nr = branche.Branche_nr WHERE branche.Branche_name = 'Muenchen');

--Shows the name of the employees whose birthday is in febraury:

SELECT Vorname, Nachname, Geburstag FROM mitarbeiter WHERE Geburstag LIKE '____-02%';
