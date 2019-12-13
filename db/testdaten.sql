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
   )
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
   )
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