-- Kreiranje Baze

CREATE DATABASE SoundSpaceDB
GO

USE SoundSpaceDB
GO

-- Kreiranje Tabela

CREATE TABLE Uloge(
	id_uloge INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	ime_uloge NVARCHAR(45) NOT NULL,
);

CREATE TABLE Korisnici(
	id_korisnika INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	id_uloge INT DEFAULT 1 NOT NULL,
	ime_korisnika NVARCHAR(45) NOT NULL,
	prezime_korisnika NVARCHAR(45) NOT NULL,
	prikazno_ime_korisnika NVARCHAR(45) NOT NULL,
	email_korisnika NVARCHAR(45) NOT NULL,
	lozinka_korisnika NVARCHAR(45) NOT NULL,
	slika_korisnika NVARCHAR(255),
	FOREIGN KEY (id_uloge) REFERENCES Uloge(id_uloge)
);

CREATE TABLE Umetnici(
	id_umetnika INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	id_korisnika INT NOT NULL,
	ime_umetnika NVARCHAR(45) NOT NULL,
	FOREIGN KEY (id_korisnika) REFERENCES Korisnici (id_korisnika),
);

CREATE TABLE Zanrovi(
	id_zanra INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	naziv_zanra NVARCHAR(45) NOT NULL,
);

CREATE TABLE Albumi(
	id_albuma INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	id_umetnika INT NOT NULL,
	naziv_albuma NVARCHAR(45) NOT NULL,
	datum_kreiranja_albuma DATETIME2(0) DEFAULT GETDATE(),
	slika_albuma NVARCHAR(255) NOT NULL,
	trajanje_albuma TIME(0),
	obrisan_album TINYINT DEFAULT 0,
	vidljivost_albuma TINYINT DEFAULT 1,

	FOREIGN KEY (id_umetnika) REFERENCES Umetnici (id_umetnika)
);

CREATE TABLE Numere(
	id_numere INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	id_umetnika INT NOT NULL,
	id_zanra INT NOT NULL,
	id_albuma INT NOT NULL,
	naziv_numere NVARCHAR(45) NOT NULL,
	trajanje_numere TIME(0) NOT NULL,
	datum_kreiranja_numere DATETIME2(0) DEFAULT GETDATE(),
	obrisana_numera TINYINT DEFAULT 0,
	vidljivost_numere TINYINT DEFAULT 1,
    lokacija_numere NVARCHAR(255) NOT NULL,

	FOREIGN KEY (id_zanra) REFERENCES Zanrovi(id_zanra),
	FOREIGN KEY (id_albuma) REFERENCES Albumi(id_albuma),
);

CREATE TABLE Plejliste(
	id_plejliste INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	id_korisnika INT NOT NULL,
	naziv_plejliste NVARCHAR(45) NOT NULL,
	trajanje_plejliste TIME(0),
	obrisana_plejlista TINYINT DEFAULT 0,
	vidljivost_plejliste TINYINT DEFAULT 1

	FOREIGN KEY (id_korisnika) REFERENCES Korisnici (id_korisnika)
);

CREATE TABLE Istorija(
	id_istorije INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	id_korisnika INT NOT NULL,
	id_numere INT NOT NULL,
	datum_slusanja DATETIME2(0) DEFAULT GETDATE(),

	FOREIGN KEY (id_korisnika) REFERENCES Korisnici (id_korisnika),
	FOREIGN KEY (id_numere) REFERENCES Numere (id_numere)

);

CREATE TABLE Tekst(
	id_teksta INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	id_numere INT NOT NULL,
	vreme_prikazivanja_teksta TIME(0) NOT NULL,
	linija_teksta NVARCHAR(255) NOT NULL,

	FOREIGN KEY (id_numere) REFERENCES Numere (id_numere)
);

CREATE TABLE Interakcije_Korisnika(
	id_interakcije INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	id_korisnika INT NOT NULL,
	id_numere INT NOT NULL,
	broj_slusanja INT,
	broj_pustanja INT NOT NULL,
	provedeno_vreme_slusanja TIME(0),
	dodato_u_omiljeno TINYINT DEFAULT 0,
    zaustavljeno_vreme TIME(0),

	FOREIGN KEY (id_korisnika) REFERENCES Korisnici (id_korisnika),
	FOREIGN KEY (id_numere) REFERENCES Numere (id_numere)
);

CREATE TABLE Numera_Plejlista(
	id_plejliste INT NOT NULL,
	id_numere INT NOT NULL,
    id_albuma INT NOT NULL,
	vreme_dodavanja DATETIME2(0) DEFAULT GETDATE(),

	FOREIGN KEY (id_numere) REFERENCES Numere (id_numere),
	FOREIGN KEY (id_plejliste) REFERENCES Plejliste (id_plejliste),
    FOREIGN KEY (id_albuma) REFERENCES Albumi (id_albuma)
);

-- Insertovanje potrebnih tabela

INSERT INTO Uloge (ime_uloge) VALUES('Korisnik');
INSERT INTO Uloge (ime_uloge) VALUES('Umetnik');
INSERT INTO Uloge (ime_uloge) VALUES('Administrator');

INSERT INTO Korisnici (id_uloge, ime_korisnika, prezime_korisnika, prikazno_ime_korisnika, email_korisnika, lozinka_korisnika)
VALUES (3, 'Momcilo', 'Nikolic', 'MOMA', 'momcilonikolic@gmail.com', 'moma123');

-- Insertovanje tabela za laksi razvoj aplikacije

INSERT INTO Zanrovi(naziv_zanra) VALUES ('LoFi');
INSERT INTO Zanrovi(naziv_zanra) VALUES ('HipHop');
INSERT INTO Zanrovi(naziv_zanra) VALUES ('Pop');
INSERT INTO Zanrovi(naziv_zanra) VALUES ('Jazz');

INSERT INTO Umetnici(id_korisnika, ime_umetnika) 
VALUES (1, 'MOMA');

INSERT INTO Albumi(id_umetnika, naziv_albuma, slika_albuma)
VALUES (1, 'Novi Album', 'Slike/Slika1.png');

INSERT INTO Numere (id_umetnika, id_albuma, id_zanra, naziv_numere, trajanje_numere, lokacija_numere)
VALUES (1, 1, 3, 'Nova Numera', '00:02:35', 'Numere/NovaNumera.mp3');

INSERT INTO Tekst (id_numere, vreme_prikazivanja_teksta, linija_teksta) VALUES (1, '00:00:02', 'Linija teksta 1');
INSERT INTO Tekst (id_numere, vreme_prikazivanja_teksta, linija_teksta) VALUES (1, '00:00:04', 'Linija teksta 2');
INSERT INTO Tekst (id_numere, vreme_prikazivanja_teksta, linija_teksta) VALUES (1, '00:00:06', 'Linija teksta 3');
INSERT INTO Tekst (id_numere, vreme_prikazivanja_teksta, linija_teksta) VALUES (1, '00:00:08', 'instrumental');
INSERT INTO Tekst (id_numere, vreme_prikazivanja_teksta, linija_teksta) VALUES (1, '00:00:15', 'Linija teksta 4');
INSERT INTO Tekst (id_numere, vreme_prikazivanja_teksta, linija_teksta) VALUES (1, '00:00:20', 'Linija teksta 5');
INSERT INTO Tekst (id_numere, vreme_prikazivanja_teksta, linija_teksta) VALUES (1, '00:01:02', 'instrumental');
INSERT INTO Tekst (id_numere, vreme_prikazivanja_teksta, linija_teksta) VALUES (1, '00:02:15', 'Linija teksta 6');
INSERT INTO Tekst (id_numere, vreme_prikazivanja_teksta, linija_teksta) VALUES (1, '00:02:25', 'Linija teksta 7');

INSERT INTO Istorija (id_korisnika, id_numere) VALUES (1, 1);

INSERT INTO Interakcije_Korisnika (id_korisnika, id_numere, broj_slusanja, broj_pustanja, provedeno_vreme_slusanja, dodato_u_omiljeno, zaustavljeno_vreme)
VALUES (1, 1, 50, 25, '01:35:28', 1, '00:01:20');

INSERT INTO Plejliste (id_korisnika, naziv_plejliste)
VALUES (1, 'Nova Plejlista');

INSERT INTO Numera_Plejlista (id_plejliste, id_numere, id_albuma) VALUES (1,1,1);

GO

-- Keiranje Pogleda

CREATE VIEW pogled_Uloge AS
SELECT * FROM Uloge
GO

CREATE VIEW pogled_Korisnici AS
SELECT * FROM Korisnici
GO

CREATE VIEW pogled_Umetnici AS
SELECT Umetnici.id_umetnika, Umetnici.id_korisnika, Korisnici.prikazno_ime_korisnika, Umetnici.ime_umetnika, Korisnici.slika_korisnika
FROM Umetnici JOIN Korisnici ON Umetnici.id_umetnika = Korisnici.id_korisnika
GO

CREATE VIEW pogled_Zanrovi AS
SELECT * FROM Zanrovi
GO

CREATE VIEW pogled_Albumi AS
SELECT Albumi.id_albuma, Albumi.id_umetnika, Albumi.naziv_albuma, Albumi.datum_kreiranja_albuma, Albumi.slika_albuma, Albumi.trajanje_albuma, Albumi.vidljivost_albuma, Albumi.obrisan_album, Umetnici.ime_umetnika
FROM Albumi JOIN Umetnici ON Albumi.id_umetnika = Umetnici.id_umetnika
GO

CREATE VIEW pogled_Numere AS
SELECT Numere.id_numere, Albumi.id_albuma, Umetnici.id_umetnika, Zanrovi.id_zanra, Numere.naziv_numere, Numere.trajanje_numere, Numere.datum_kreiranja_numere, Numere.vidljivost_numere, Numere.lokacija_numere, Zanrovi.naziv_zanra, Umetnici.ime_umetnika
FROM Numere JOIN Albumi ON Numere.id_albuma = Albumi.id_albuma JOIN Umetnici ON Numere.id_umetnika = Umetnici.id_umetnika JOIN Zanrovi ON Numere.id_zanra = Zanrovi.id_zanra
GO

CREATE VIEW pogled_Plejliste AS
SELECT Plejliste.id_plejliste, Plejliste.id_korisnika, Plejliste.naziv_plejliste, Plejliste.obrisana_plejlista, Plejliste.vidljivost_plejliste, Korisnici.prikazno_ime_korisnika
FROM Plejliste JOIN Korisnici ON Plejliste.id_korisnika = Korisnici.id_korisnika
GO

CREATE VIEW pogled_Istorija AS
SELECT Istorija.id_istorije, Istorija.id_korisnika, Istorija.id_numere, Istorija.datum_slusanja, Korisnici.prikazno_ime_korisnika, Numere.naziv_numere
FROM Istorija JOIN Korisnici ON Istorija.id_korisnika = Korisnici.id_korisnika JOIN Numere ON Istorija.id_numere = Numere.id_numere
GO

CREATE VIEW pogled_Tekst AS
SELECT * FROM Tekst
GO

CREATE VIEW pogled_Interakcije_Korisnika AS
SELECT Interakcije_Korisnika.id_interakcije, Interakcije_Korisnika.id_korisnika, Interakcije_Korisnika.id_numere, 
Interakcije_Korisnika.broj_slusanja, Interakcije_Korisnika.provedeno_vreme_slusanja, Interakcije_Korisnika.dodato_u_omiljeno, 
Interakcije_Korisnika.zaustavljeno_vreme, Korisnici.prikazno_ime_korisnika, Numere.naziv_numere
FROM Interakcije_Korisnika JOIN Korisnici ON Interakcije_Korisnika.id_korisnika = Korisnici.id_korisnika JOIN Numere ON Interakcije_Korisnika.id_numere = Numere.id_numere
GO

CREATE VIEW pogled_Numera_Plejlista AS
SELECT Numera_Plejlista.id_numere, Numera_Plejlista.id_plejliste, Numera_Plejlista.vreme_dodavanja, Numere.naziv_numere, Plejliste.naziv_plejliste,
Numere.trajanje_numere, Numere.datum_kreiranja_numere, Numere.lokacija_numere, Albumi.slika_albuma  
FROM Numera_Plejlista JOIN Numere ON Numera_Plejlista.id_numere = Numere.id_numere JOIN Albumi ON Numera_Plejlista.id_albuma = Albumi.id_albuma JOIN Plejliste ON Numera_Plejlista.id_plejliste = Plejliste.id_plejliste
GO




