-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-03-24 11:49:09.561

-- tables
-- Table: grupa
CREATE TABLE grupa (
    kod varchar2(10)  NOT NULL,
    CONSTRAINT grupa_pk PRIMARY KEY (kod)
) ;

-- Table: osoba
CREATE TABLE osoba (
    s_numer integer  NOT NULL,
    imie varchar2(30)  NOT NULL,
    nazwisko varchar2(30)  NOT NULL,
    konto_bankowe char(28)  NOT NULL,
    CONSTRAINT osoba_pk PRIMARY KEY (s_numer)
) ;

-- Table: personel
CREATE TABLE personel (
    osoba_s_numer integer  NOT NULL,
    nip char(10)  NULL,
    wynagrodzenie number(7,2)  NOT NULL,
    CONSTRAINT personel_pk PRIMARY KEY (osoba_s_numer)
) ;

-- Table: plan_jakub_sterczewski_s33164
CREATE TABLE plan_jakub_sterczewski_s33164 (
    data timestamp  NOT NULL,
    sala_nr integer  NOT NULL,
    sala_budynek char(1)  NOT NULL,
    grupa_kod varchar2(10)  NOT NULL,
    personel_osoba_s_numer integer  NOT NULL,
    przedmiot_kod char(3)  NOT NULL,
    typ_przedmiotu_kod char(1)  NOT NULL,
    CONSTRAINT plan_jakub_sterczewski_s331_pk PRIMARY KEY (data,sala_budynek,sala_nr)
) ;

-- Table: przedmiot
CREATE TABLE przedmiot (
    kod char(3)  NOT NULL,
    nazwa varchar2(60)  NOT NULL,
    ects integer  NOT NULL,
    zaliczenie_kod char(2)  NOT NULL,
    CONSTRAINT przedmiot_pk PRIMARY KEY (kod)
) ;

-- Table: przedmiot_typ_przedmiotu
CREATE TABLE przedmiot_typ_przedmiotu (
    przedmiot_kod char(3)  NOT NULL,
    typ_przedmiotu_kod char(1)  NOT NULL,
    liczba_godzin integer  NOT NULL,
    CONSTRAINT przedmiot_typ_przedmiotu_pk PRIMARY KEY (typ_przedmiotu_kod,przedmiot_kod)
) ;

-- Table: sala
CREATE TABLE sala (
    nr integer  NOT NULL,
    budynek char(1)  NOT NULL,
    pojemnosc integer  NOT NULL,
    CONSTRAINT sala_pk PRIMARY KEY (nr,budynek)
) ;

-- Table: student
CREATE TABLE student (
    osoba_s_numer integer  NOT NULL,
    wysokosc_czesnego number(6,2)  NOT NULL,
    naleznosci number(8,2)  NOT NULL,
    CONSTRAINT student_pk PRIMARY KEY (osoba_s_numer)
) ;

-- Table: student_grupa
CREATE TABLE student_grupa (
    student_osoba_s_numer integer  NOT NULL,
    grupa_kod varchar2(10)  NOT NULL,
    CONSTRAINT student_grupa_pk PRIMARY KEY (student_osoba_s_numer,grupa_kod)
) ;

-- Table: transakcja
CREATE TABLE transakcja (
    id integer  NOT NULL,
    tytul varchar2(60)  NOT NULL,
    data date  NOT NULL,
    kwota number(7,2)  NOT NULL,
    osoba_s_numer integer  NOT NULL,
    CONSTRAINT transakcja_pk PRIMARY KEY (id)
) ;

-- Table: typ_przedmiotu
CREATE TABLE typ_przedmiotu (
    kod char(1)  NOT NULL,
    nazwa varchar2(20)  NOT NULL,
    CONSTRAINT typ_przedmiotu_pk PRIMARY KEY (kod)
) ;

-- Table: zaliczenie
CREATE TABLE zaliczenie (
    kod char(2)  NOT NULL,
    zaliczenie varchar2(20)  NOT NULL,
    CONSTRAINT zaliczenie_pk PRIMARY KEY (kod)
) ;

-- foreign keys
-- Reference: personel_osoba (table: personel)
ALTER TABLE personel ADD CONSTRAINT personel_osoba
    FOREIGN KEY (osoba_s_numer)
    REFERENCES osoba (s_numer);

-- Reference: plan_grupa (table: plan_jakub_sterczewski_s33164)
ALTER TABLE plan_jakub_sterczewski_s33164 ADD CONSTRAINT plan_grupa
    FOREIGN KEY (grupa_kod)
    REFERENCES grupa (kod);

-- Reference: plan_personel (table: plan_jakub_sterczewski_s33164)
ALTER TABLE plan_jakub_sterczewski_s33164 ADD CONSTRAINT plan_personel
    FOREIGN KEY (personel_osoba_s_numer)
    REFERENCES personel (osoba_s_numer);

-- Reference: plan_przedmiot_typ_przedmiotu (table: plan_jakub_sterczewski_s33164)
ALTER TABLE plan_jakub_sterczewski_s33164 ADD CONSTRAINT plan_przedmiot_typ_przedmiotu
    FOREIGN KEY (typ_przedmiotu_kod,przedmiot_kod)
    REFERENCES przedmiot_typ_przedmiotu (typ_przedmiotu_kod,przedmiot_kod);

-- Reference: plan_sala (table: plan_jakub_sterczewski_s33164)
ALTER TABLE plan_jakub_sterczewski_s33164 ADD CONSTRAINT plan_sala
    FOREIGN KEY (sala_nr,sala_budynek)
    REFERENCES sala (nr,budynek);

-- Reference: przedmiot_typ_przedmiotu (table: przedmiot_typ_przedmiotu)
ALTER TABLE przedmiot_typ_przedmiotu ADD CONSTRAINT przedmiot_typ_przedmiotu
    FOREIGN KEY (przedmiot_kod)
    REFERENCES przedmiot (kod);

-- Reference: przedmiot_zaliczenie (table: przedmiot)
ALTER TABLE przedmiot ADD CONSTRAINT przedmiot_zaliczenie
    FOREIGN KEY (zaliczenie_kod)
    REFERENCES zaliczenie (kod);

-- Reference: student_grupa_grupa (table: student_grupa)
ALTER TABLE student_grupa ADD CONSTRAINT student_grupa_grupa
    FOREIGN KEY (grupa_kod)
    REFERENCES grupa (kod);

-- Reference: student_grupa_student (table: student_grupa)
ALTER TABLE student_grupa ADD CONSTRAINT student_grupa_student
    FOREIGN KEY (student_osoba_s_numer)
    REFERENCES student (osoba_s_numer);

-- Reference: student_osoba (table: student)
ALTER TABLE student ADD CONSTRAINT student_osoba
    FOREIGN KEY (osoba_s_numer)
    REFERENCES osoba (s_numer);

-- Reference: transakcja_osoba (table: transakcja)
ALTER TABLE transakcja ADD CONSTRAINT transakcja_osoba
    FOREIGN KEY (osoba_s_numer)
    REFERENCES osoba (s_numer);

-- Reference: typ_przedmiotu (table: przedmiot_typ_przedmiotu)
ALTER TABLE przedmiot_typ_przedmiotu ADD CONSTRAINT typ_przedmiotu
    FOREIGN KEY (typ_przedmiotu_kod)
    REFERENCES typ_przedmiotu (kod);