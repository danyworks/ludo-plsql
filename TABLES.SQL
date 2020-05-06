/**
    ------AUFGABE B3 - MENSCH ÄRGER DICH NICHT---------
    @author Daniyal
    @version 1.0

    Alle tabelle sind in der dritte Normale Form

  1NF := A relation is in first normal form if and only if the domain of each attribute contains only atomic
         (indivisible) values, and the value of each attribute contains only a single value from that domain
  2NF := It does not have any non-prime attribute that is functionally dependent on any proper subset of any
         candidate key of the relation.
  3NF :=  if all the attributes (e.g. database columns) are functionally dependent on solely the primary key.
 */


    DROP TABLE Punkte;

    DROP TABLE Spieler;
    DROP TABLE Spielstein CASCADE CONSTRAINTS;
    DROP TABLE Spielablauf CASCADE CONSTRAINTS;
    DROP SEQUENCE Spielablauf_seq_id;
    DROP SEQUENCE Spieler_seq_id;
    DROP SEQUENCE Spielstein_seq_id;


/*
    diese Tabelle enthält die Werte für Punkte und ihre Beschreibung
 */
CREATE TABLE Punkte(
    Punkte_Id   NUMBER(10),
    Punkte_Value NUMBER(10),
    Punkte_Beschreibung VARCHAR2(200)
 );
ALTER TABLE Punkte ADD CONSTRAINT Punkte_Id_pk PRIMARY KEY (Punkte_Id);

/**
    Diese Tabelle enthält die Daten der Spieler
 */
 CREATE TABLE Spieler(
    Spieler_Id   NUMBER(10),
    Spieler_Name VARCHAR(75)
 );
ALTER TABLE Spieler ADD CONSTRAINT Spieler_id_pk PRIMARY KEY (Spieler_Id);


/**
    Diese Tabelle enthält die Daten der Spielsteine
 */
 CREATE TABLE Spielstein(
    Stein_Id   NUMBER(10),
    Stein_Position NUMBER(10),
    Stein_Farbe VARCHAR(25),
    Spielstein_Spieler_Id NUMBER(10)
 );
/*
    Diese ALTER-Anweisungen fügen Constraints zur Tabelle der Steine hinzu
 */
ALTER TABLE Spielstein ADD CONSTRAINT Spielstein_Id_pk PRIMARY KEY (Stein_Id);
ALTER TABLE Spielstein ADD CONSTRAINT Spielstein_Spieler_id_fk FOREIGN KEY (Spielstein_Spieler_id) REFERENCES Spieler(Spieler_id);
ALTER TABLE Spielstein ADD CONSTRAINT Stein_Farbe_Name UNIQUE (Stein_Farbe);


/**
    In dieser Tabelle ist der Spielablauf dargestellt, und die Zeilen in dieser Tabelle geben den Spielverlauf jedes Spielers wieder.
 */
CREATE TABLE Spielablauf(
    Spielablauf_id NUMBER(10),
    Spiel_Time          TIMESTAMP,
    Steine_Position NUMBER(10),
    Spielablauf_Spieler_id   NUMBER(10),
    Spielablauf_Stein_id   NUMBER(10),
    Spielablauf_Punkte NUMBER(10)
 );
ALTER TABLE Spielablauf ADD CONSTRAINT Spielablauf_id_pk PRIMARY KEY (Spielablauf_id);
ALTER TABLE Spielablauf ADD CONSTRAINT Spielablauf_Spieler_id_fk FOREIGN KEY (Spielablauf_Spieler_id) REFERENCES Spieler(Spieler_id);
ALTER TABLE Spielablauf ADD CONSTRAINT Spielablauf_Spielstein_id_fk FOREIGN KEY (Spielablauf_Stein_id) REFERENCES Spielstein(Stein_Id);



/**
    Die Werte werden in die Tabelle der Spieler eingefügt
 */
CREATE SEQUENCE Spieler_seq_id minvalue 1 start with 1;

INSERT INTO SPIELER(spieler_id, spieler_name) VALUES (Spieler_seq_id.nextval, 'CaptainAmerica');
INSERT INTO SPIELER(spieler_id, spieler_name) VALUES (Spieler_seq_id.nextval, 'Ironman');
INSERT INTO SPIELER(spieler_id, spieler_name) VALUES (Spieler_seq_id.nextval, 'Arrow');
INSERT INTO SPIELER(spieler_id, spieler_name) VALUES (Spieler_seq_id.nextval, 'Flash');

/**
    Die Werte werden in die Tabelle der Punkte eingefügt
 */
INSERT INTO PUNKTE(PUNKTE_ID, PUNKTE_VALUE, PUNKTE_BESCHREIBUNG) VALUES (01,-1,'Ihr Stein wurde geschlagen');
INSERT INTO PUNKTE(PUNKTE_ID, PUNKTE_VALUE, PUNKTE_BESCHREIBUNG) VALUES (02,1,'Sie haben den Stein des gegnerischen Spielers geschlagen');
INSERT INTO PUNKTE(PUNKTE_ID, PUNKTE_VALUE, PUNKTE_BESCHREIBUNG) VALUES (03,-2,'Sie sind auf eine Barriere gestoßen');
INSERT INTO PUNKTE(PUNKTE_ID, PUNKTE_VALUE, PUNKTE_BESCHREIBUNG) VALUES (04,2,'Sie haben die Barriere gebildet');
INSERT INTO PUNKTE(PUNKTE_ID, PUNKTE_VALUE, PUNKTE_BESCHREIBUNG) VALUES (05,10,'Sie haben das Spiel gewonnen');

/**
    Die Werte werden in die Tabelle der Spielsteine eingefügt
 */
CREATE SEQUENCE Spielstein_seq_id minvalue 1 start with 1;

INSERT INTO Spielstein(Stein_Id,STEIN_POSITION, Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'GELB_1',1);
INSERT INTO Spielstein(Stein_Id,STEIN_POSITION, Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'GELB_2',1);
INSERT INTO Spielstein(Stein_Id,STEIN_POSITION, Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'GELB_3',1);
INSERT INTO Spielstein(Stein_Id,STEIN_POSITION, Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'GELB_4',1);
INSERT INTO Spielstein(Stein_Id,STEIN_POSITION, Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'Rott_1',2);
INSERT INTO Spielstein(Stein_Id,STEIN_POSITION, Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'Rott_2',2);
INSERT INTO Spielstein(Stein_Id,STEIN_POSITION, Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'Rott_3',2);
INSERT INTO Spielstein(Stein_Id,STEIN_POSITION, Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'Rott_4',2);
INSERT INTO Spielstein(Stein_Id,STEIN_POSITION,Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'Blau_1',3);
INSERT INTO Spielstein(Stein_Id,STEIN_POSITION, Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'Blau_2',3);
INSERT INTO Spielstein(Stein_Id,STEIN_POSITION, Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'Blau_3',3);
INSERT INTO Spielstein(Stein_Id,STEIN_POSITION, Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'Blau_4',3);
INSERT INTO Spielstein(Stein_Id, STEIN_POSITION,Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'Gruen_1',4);
INSERT INTO Spielstein(Stein_Id, STEIN_POSITION,Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'Gruen_2',4);
INSERT INTO Spielstein(Stein_Id, STEIN_POSITION,Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'Gruen_3',4);
INSERT INTO Spielstein(Stein_Id,STEIN_POSITION, Stein_Farbe,Spielstein_Spieler_Id) VALUES (Spielstein_seq_id.nextval,0,'Gruen_4',4);




/**
    Es wird eine Sequenz erstellt, um die IDs für die Tabelle automatisch zu erhöhen und zu speichern
 */
CREATE SEQUENCE Spielablauf_seq_id minvalue 1 start with 1;


/**
    Anfangswerte werden in die Spielablauftabelle eingefügt
 */
INSERT INTO Spielablauf(Spielablauf_id,Spiel_Time, Steine_Position  ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,01,01);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,01,02);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP,0,01,03);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,01,04);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,02,05);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,02,06);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,02,07);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,02,08);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,03,09);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,03,10);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,03,11);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,03,12);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,04,13);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,04,14);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,04,15);
INSERT INTO Spielablauf(Spielablauf_id, Spiel_Time, Steine_Position ,Spielablauf_Spieler_id, Spielablauf_Stein_id) VALUES
                       (Spielablauf_seq_id.nextval,CURRENT_TIMESTAMP, 0,04,16);


COMMIT;

