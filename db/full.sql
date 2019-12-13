SET
   FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS weebay;

CREATE DATABASE weebay;

USE weebay;

/*
 Innerhalb dieser Zeilen werden die Tabellen erstellt und die Relation zwischen
 diesen aufgebaut. Zur Übersicht wird jeder Relationsaufbau zwischen Tabellen
 unterhalb des Befehls strukturiert, welcher die Tabelle erstellt.
 */
CREATE TABLE teilnehmer (
   nummer_teilnehmer SERIAL PRIMARY KEY,
   postleitzahl VARCHAR(100) NOT NULL,
   nachname VARCHAR(100) NOT NULL,
   geburtsort VARCHAR(100) NOT NULL,
   geburtsdatum DATE NOT NULL,
   email_adresse VARCHAR(50) NOT NULL,
   passwort VARCHAR(16) NOT NULL,
   eintrittsdatum DATE NOT NULL,
   vorname VARCHAR(100) NOT NULL,
   strasse VARCHAR(100) NOT NULL,
   wohnort VARCHAR(100) NOT NULL,
   hausnummer VARCHAR(100) NOT NULL
) ENGINE = InnoDB;

/*
 Da jeder Artikel einem Teilnehmer zugewiesen werden muss, wird hier eine
 Verbindung zwischen der Artikel- und Teilnehmertabelle aufgebaut.
 Wichtig ist hierbei aber, dass ein Teilnehmer sowohl Käufer als auch Anbieter
 sein kann. Also wird der Primärschlüssel der Artikeltabelle mit der Verkäufer-ID
 und mit der Käufer-ID verglichen.
 */
CREATE TABLE artikel (
   nummer_artikel SERIAL PRIMARY KEY,
   bennenung VARCHAR(300) NOT NULL,
   beschreibung VARCHAR(5000) NOT NULL,
   nummer_verkaeufer BIGINT UNSIGNED NOT NULL,
   nummer_kaeufer BIGINT UNSIGNED NOT NULL,
   mindestgebot FLOAT(100, 2) NOT NULL DEFAULT 1.0,
   endpreis FLOAT(100, 2) NOT NULL,
   startzeitpunkt DATE NOT NULL,
   endzeitpunkt DATE NOT NULL
) ENGINE = InnoDB;

ALTER TABLE
   artikel
ADD
   FOREIGN KEY (nummer_verkaeufer) REFERENCES teilnehmer(nummer_teilnehmer);

ALTER TABLE
   artikel
ADD
   FOREIGN KEY (nummer_kaeufer) REFERENCES teilnehmer(nummer_teilnehmer);

/*
 Jedem Artikel ist ebenfalls ein Bild zuzuweisen. Demnach wird hier wieder eine
 Relation zwischen der Bild- und der Artikeltabelle aufgebaut. Da ein Bild aber
 mehreren Artikeln zugewiesen werden kann, wird der Primärschlüssel der Bild-Tabelle
 mit dem der Artikeltabelle verglichen.
 */
CREATE TABLE bild (
   nummer_bild SERIAL PRIMARY KEY,
   name_bild VARCHAR(100) NOT NULL,
   nummer_artikel BIGINT UNSIGNED NOT NULL
) ENGINE = InnoDB;

ALTER TABLE
   bild
ADD
   FOREIGN KEY (nummer_artikel) REFERENCES artikel(nummer_artikel);

/*
 Zu jedem Artikel existiert ein Gebot. Demnach muss eine Relation zwischen
 der Gebot- und der Artikeltabelle aufgebaut werden.
 Ein Teilnehmer kann ein Gebot
 */
CREATE TABLE gebot (
   nummer_gebot SERIAL PRIMARY KEY,
   nummer_verkaeufer INTEGER,
   nummer_artikel BIGINT UNSIGNED NOT NULL,
   datum_uhrzeit DATETIME NOT NULL,
   hoechstgebot INTEGER NOT NULL,
   nummer_bieter BIGINT UNSIGNED NOT NULL
) ENGINE = InnoDB;

ALTER TABLE
   gebot
ADD
   FOREIGN KEY (nummer_artikel) REFERENCES artikel(nummer_artikel);

ALTER TABLE
   gebot
ADD
   FOREIGN KEY (nummer_bieter) REFERENCES teilnehmer(nummer_teilnehmer);

CREATE TABLE kategorie (
   nummer_kategorie SERIAL PRIMARY KEY,
   name_kategorie VARCHAR(100),
   beschreibung_kategorie VARCHAR(500) NOT NULL,
   nummer_artikel INTEGER
) ENGINE = InnoDB;

/*
 Ein Artikel kann mehereren Kategorien zugewiesen werden, genau so wie eine
 Kategorie mehrere Artikel beinhaltet. Demnach muss eine Zwischentabelle generiert
 werden, da so theoretisch gesagt werden kann, dass eine Kategorie alle Artikel
 beinhalten kann, und dafür die anderen Kategorien keine.
 */
CREATE TABLE klassifizierung (
   nummer_klassifizierung SERIAL PRIMARY KEY,
   nummer_artikel BIGINT UNSIGNED NOT NULL,
   name_kategorie VARCHAR(100) NOT NULL,
   nummer_kategorie BIGINT UNSIGNED NOT NULL
) ENGINE = InnoDB;

ALTER TABLE
   klassifizierung
ADD
   FOREIGN KEY (nummer_kategorie) REFERENCES kategorie(nummer_kategorie);

ALTER TABLE
   klassifizierung
ADD
   FOREIGN KEY (nummer_artikel) REFERENCES artikel(nummer_artikel);

BEGIN;

INSERT INTO
   teilnehmer (
      nummer_teilnehmer,
      postleitzahl,
      nachname,
      geburtsort,
      geburtsdatum,
      email_adresse,
      passwort,
      eintrittsdatum,
      vorname,
      strasse,
      wohnort,
      hausnummer
   )
VALUES
   (
      DEFAULT,
      31174,
      'Tomaszewski',
      'Bialogard',
      '2000-09-19',
      'folokoi122@gmail.com',
      'foloko122',
      '2019-11-06',
      'Szymon',
      'Königsberger Ring',
      'Dingelbe',
      23
   ),
   (
      DEFAULT,
      31141,
      'Fetrik',
      'Hildesheim',
      '2000-09-20',
      'hay@gmail.com',
      'hayhayhay',
      '2019-11-06',
      'Fetrika',
      'Fetrik Straße',
      'Fetriko',
      69
   ),
   (
      DEFAULT,
      31151,
      'Erdogan',
      'Hildehood',
      '2000-09-11',
      'harambo@gmail.com',
      'hayhayhay',
      '2019-11-05',
      'Merte',
      'Gute Strasse',
      'Baba Döner',
      88
   );

INSERT INTO
   artikel (
      nummer_artikel,
      bennenung,
      beschreibung,
      nummer_verkaeufer,
      nummer_kaeufer,
      mindestgebot,
      endpreis,
      startzeitpunkt,
      endzeitpunkt
   )
VALUES
   (
      DEFAULT,
      'Margonem Gold',
      '1€ : 10 Mil. Margonem Gold',
      1,
      2,
      1.00,
      1.00,
      '2019-11-06',
      '2019-11-06'
   ),
   (
      DEFAULT,
      'Vegan Kuh Milch',
      'Milch von Kuh aber vegan',
      2,
      1,
      1.00,
      1.00,
      '2019-11-20',
      '2019-11-20'
   ),
   (
      DEFAULT,
      "Computer",
      "Ein Computer mit i5, 500gb HDD und so",
      1,
      2,
      100.00,
      200.00,
      "2019-11-20",
      "2019-11-30"
   ),
   (
      DEFAULT,
      "Metes haramburger mit bacon",
      "Metes originaler, nicht ganz so haramer 
      hamburg mit doppelt cheese & bacon.",
      3,
      1,
      5.00,
      10.00,
      "2019-12-6",
      "2019-12-24"
   );

INSERT INTO
   kategorie (
      nummer_kategorie,
      name_kategorie,
      beschreibung_kategorie,
      nummer_artikel
   )
VALUES
   (
      DEFAULT,
      'Nahrungsmittel',
      'ist klar oder? dumm?',
      2
   ),
   (
      DEFAULT,
      'Margonem',
      'komputer spiel für nörts',
      1
   ),
   (
      DEFAULT,
      "Technik",
      "So schnick-schnack mit Strom drauf",
      3
   );

INSERT INTO
   klassifizierung (
      nummer_klassifizierung,
      nummer_artikel,
      name_kategorie,
      nummer_kategorie
   )
VALUES
   (DEFAULT, 1, 'Nahrungsmittel', 2),
   (DEFAULT, 2, 'Margonem', 1);

INSERT INTO
   bild (nummer_bild, name_bild, nummer_artikel)
VALUES
   (1, 'margonem gold overview', 1),
   (2, 'vegan Kuh milch', 2);

INSERT INTO
   gebot (
      nummer_gebot,
      nummer_verkaeufer,
      nummer_artikel,
      datum_uhrzeit,
      hoechstgebot,
      nummer_bieter
   )
VALUES
   (1, 1, 1, '2019-11-20', 1.00, 2),
   (2, 2, 2, '2019-11-20', 1.00, 1);

-- ROLLBACK;
COMMIT;