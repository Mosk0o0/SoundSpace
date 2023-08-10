CREATE DATABASE SoundSpaceDB
GO

USE SoundSpaceDB
GO

CREATE TABLE Uloge(
	id_uloge INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	ime_uloge NVARCHAR(45) NOT NULL,
);


INSERT INTO Uloge (ime_uloge) VALUES('Korisnik');
INSERT INTO Uloge (ime_uloge) VALUES('Umetnik');
INSERT INTO Uloge (ime_uloge) VALUES('Administrator');


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

INSERT INTO Korisnici (id_uloge, ime_korisnika, prezime_korisnika, prikazno_ime_korisnika, email_korisnika, lozinka_korisnika)
VALUES (3, 'Momcilo', 'Nikolic', 'MOMA', 'momcilonikolic@gmail.com', 'moma123');


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

INSERT INTO Zanrovi(naziv_zanra) VALUES ('LoFi');
INSERT INTO Zanrovi(naziv_zanra) VALUES ('HipHop');
INSERT INTO Zanrovi(naziv_zanra) VALUES ('Pop');
INSERT INTO Zanrovi(naziv_zanra) VALUES ('Jazz');

CREATE TABLE Albumi(
	id_albuma INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	id_umetnika INT NOT NULL,
	naziv_albuma NVARCHAR(45) NOT NULL,
	datum_kreiranja_albuma DATETIME DEFAULT GETDATE(),
	slika_albuma NVARCHAR(255) NOT NULL,
	trajanje_albuma TIME,
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
	trajanje_numere TIME NOT NULL,
	datum_kreiranja_numere DATETIME DEFAULT GETDATE(),
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
	trajanje_plejliste TIME,
	obrisana_plejlista TINYINT DEFAULT 0,
	vidljivost_plejliste TINYINT DEFAULT 1

	FOREIGN KEY (id_korisnika) REFERENCES Korisnici (id_korisnika)
);

CREATE TABLE Istorija(
	id_istorije INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	id_korisnika INT NOT NULL,
	id_numere INT NOT NULL,
	datum_slusanja DATETIME DEFAULT GETDATE(),

	FOREIGN KEY (id_korisnika) REFERENCES Korisnici (id_korisnika),
	FOREIGN KEY (id_numere) REFERENCES NUmere (id_numere)

);

CREATE TABLE Tekst(
	id_teksta INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	id_numere INT NOT NULL,
	vreme_prikazivanja_teksta TIME NOT NULL,
	linija_teksta TEXT NOT NULL,

	FOREIGN KEY (id_numere) REFERENCES NUmere (id_numere)
);

CREATE TABLE Interakcije_Korisnika(
	id_interakcije INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	id_korisnika INT NOT NULL,
	id_numere INT NOT NULL,
	broj_slusanja INT,
	broj_pustanja INT NOT NULL,
	provedeno_vreme_slusanja TIME,
	dodato_u_omiljeno TINYINT DEFAULT 0,
    zaustavljeno_vreme TIME,

	FOREIGN KEY (id_korisnika) REFERENCES Korisnici (id_korisnika),
	FOREIGN KEY (id_numere) REFERENCES NUmere (id_numere)
);

CREATE TABLE Numera_Plejlista(
	id_plejliste INT NOT NULL IDENTITY(1,1),
	id_numere INT NOT NULL,
    id_albuma INT NOT NULL,
	vreme_dodavanja DATETIME DEFAULT GETDATE(),

	FOREIGN KEY (id_numere) REFERENCES Numere (id_numere),
	FOREIGN KEY (id_plejliste) REFERENCES Plejliste (id_plejliste),
    FOREIGN KEY (id_albuma) REFERENCES Albumi (id_albuma)
)
GO

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
SELECT Numera_Plejlista.id_numere, Numera_Plejlista.id_plejliste, Numera_Plejlista.vreme_dodavanja, Numere.naziv_numere,
Numere.trajanje_numere, Numere.datum_kreiranja_numere, Numere.lokacija_numere, Albumi.slika_albuma  
FROM Numera_Plejlista JOIN Numere ON Numera_Plejlista.id_numere = Numere.id_numere JOIN Albumi ON Numera_Plejlista.id_albuma = Albumi.id_albuma
GO




