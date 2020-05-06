
/**
  _______________________________AUFGABE-B3___________________________________________
  Dieses Skript ist die Umsetzung des Spiels "Mensch Ärgere dich nicht".
  Dieses Sql-Skript hat ein Paket mit Funktionen, Prozeduren, Varrays und Triggers.
  Dieses Skript wurde von daniyal ibrahim erstellt.
 */
 /*
    @author Daniyal Ibrahim
    @version 1.0
    @since 05.05.2020
  */
/*
 Dies ist der Paketkopf, der die Paketspezifikationen und die öffentlichen Procedure oder Funktionen enthält.
 */
CREATE OR REPLACE PACKAGE Brettspiel_pkg AUTHID CURRENT_USER IS

    FUNCTION  wuerfeln RETURN NUMBER;
    PROCEDURE amZug (Spieler_Id Spieler.Spieler_ID%TYPE);
    PROCEDURE zieheSpielstein (Spieler_Id Spieler.Spieler_ID%TYPE);

    FUNCTION show_Spielbrett RETURN NUMBER;


END Brettspiel_pkg;
/
/*
    Dies ist der Hauptteil des Pakets und dies ist die eigentliche pl/sql-Implementierung des Spiels
 */
CREATE OR REPLACE PACKAGE BODY Brettspiel_pkg IS

    -- WUERFELN FUNCTION WIRD IMPLEMENTIERT
    FUNCTION wuerfeln RETURN NUMBER
        IS
            DICE NUMBER(1) := DBMS_RANDOM.VALUE(1,6);
        BEGIN
            RETURN (DICE);
        END wuerfeln;


    -- Spiel_zuege ist ein VARRAY, der die Stein_ID speichert
    TYPE Spiel_zuege IS VARRAY (20) OF NUMBER;
    -- Zug_Stein ist ein VARRAY, der die Stein_Position speichert
    TYPE Zug_Stein IS VARRAY (20) OF NUMBER;
    --
    TYPE CHAMP IS VARRAY (20) OF NUMBER;

    TYPE Spieler_1 IS VARRAY (4) OF NUMBER;
    TYPE Spieler_2 IS VARRAY (4) OF NUMBER;
    TYPE Spieler_3 IS VARRAY (4) OF NUMBER;
    TYPE Spieler_4 IS VARRAY (4) OF NUMBER;

     /*
        Kann ein Spielstein aus dem Startbereich gezogen werden?- (Siehe Anlage_1 Punkt_1)
     */
     FUNCTION regel_1 (Augenzahl NUMBER,Spieler_arg_Id Spieler.Spieler_ID%TYPE) RETURN NUMBER
        IS
             var_spieler NUMBER(10);
             var_stein NUMBER(10);
        BEGIN
            SELECT Spieler_Id  INTO var_spieler FROM SPIELER WHERE SPIELER_ID = Spieler_arg_Id;

            IF Augenzahl=6 THEN
                SELECT STEIN_ID INTO var_stein FROM SPIELSTEIN WHERE SPIELSTEIN_SPIELER_ID = Spieler_arg_Id AND STEIN_POSITION =0 AND ROWNUM =1;
                      IF var_stein != NULL THEN
                             DBMS_OUTPUT.PUT_LINE('Das Stein '||var_stein||' kann aus dem B-FELD gezogen werden');
                            RETURN var_stein;
                        ELSE
                            DBMS_OUTPUT.PUT_LINE('Es darf kein Stein aus dem B-FELD rauskommen '||var_stein);
                            RETURN NULL;
                        END IF;

            ELSE
                DBMS_OUTPUT.PUT_LINE('Augenzahl ist ungleich 6, deshalb Spielsteine darf nicht aus dem Startbereich gezogen werden');
                RETURN NULL;
            END IF;
     END regel_1;

        /*
         Ist das Schlagen eines gegnerischen Spielsteins möglich? Falls mehrere Spielsteine
         geschlagen werden können, ist eine Rangfolge entspr. der zu erzielenden Punkte festzulegen. - (Siehe Anlage_1 Punkt_2)
         */
     FUNCTION regel_2 (Augenzahl NUMBER, Spieler_arg_Id Spieler.Spieler_ID%TYPE) RETURN NUMBER
        IS
            -- GELB SPIELER
            var_spieler_1 Spieler_1;
            -- ROTT SPIELER
            var_spieler_2 Spieler_2;
            -- BLAU SPIELER
            var_spieler_3 Spieler_3;
            -- GRUEN SPIELER
            var_spieler_4 Spieler_4;

            var_spieler NUMBER(10);
            var_spieler_name VARCHAR(75);

            v_counter NUMBER(10);
            x_counter NUMBER(10);

            sql_query_1 VARCHAR2(200);
            temp_Stein_ID NUMBER(10);

        BEGIN

            SELECT Spieler_Id  INTO var_spieler FROM SPIELER WHERE SPIELER_ID = Spieler_arg_Id;
            SELECT SPIELER_NAME  INTO var_spieler_name FROM SPIELER WHERE SPIELER_ID = var_spieler;
            SELECT STEIN_POSITION BULK COLLECT INTO var_spieler_1 FROM SPIELSTEIN WHERE STEIN_ID <5;
            SELECT STEIN_POSITION BULK COLLECT INTO var_spieler_2 FROM SPIELSTEIN WHERE STEIN_ID >4  AND  STEIN_ID <9;
            SELECT STEIN_POSITION BULK COLLECT INTO var_spieler_3 FROM SPIELSTEIN WHERE STEIN_ID >8  AND  STEIN_ID <13;
            SELECT STEIN_POSITION BULK COLLECT INTO var_spieler_4 FROM SPIELSTEIN WHERE STEIN_ID >12 AND  STEIN_ID <17;

            IF var_spieler=1 THEN
                DBMS_OUTPUT.PUT_LINE('Spieler'||var_spieler_name||'IST DRAN!' );
                    FOR v_counter IN 1 .. 4 LOOP
                        IF var_spieler_1(v_counter) != 0 THEN
                            FOR x_counter IN 1 ..4 LOOP
                                IF var_spieler_2(x_counter) !=0 THEN
                                            IF var_spieler_1(v_counter) + Augenzahl = var_spieler_2(x_counter)- 30 THEN
                                                    sql_query_1 := 'SELECT STEIN_ID FROM SPIELSTEIN WHERE STEIN_ID = x_counter + 4 ';
                                                    EXECUTE IMMEDIATE sql_query_1 INTO temp_Stein_ID;
                                                    RETURN temp_Stein_ID;
                                            END IF;
                                ELSIF var_spieler_3(x_counter) !=0 THEN
                                            IF var_spieler_1(v_counter) + Augenzahl = var_spieler_3(x_counter)- 20 THEN
                                                    sql_query_1 := 'SELECT STEIN_ID FROM SPIELSTEIN WHERE STEIN_ID = x_counter + 8';
                                                    EXECUTE IMMEDIATE sql_query_1 INTO temp_Stein_ID;
                                                    RETURN temp_Stein_ID;
                                            END IF;
                                ELSIF var_spieler_4(x_counter) !=0 THEN
                                            IF var_spieler_1(v_counter) + Augenzahl = var_spieler_4(x_counter)- 10 THEN
                                                    sql_query_1 := 'SELECT STEIN_ID FROM SPIELSTEIN WHERE STEIN_ID = x_counter + 12';
                                                    EXECUTE IMMEDIATE sql_query_1 INTO temp_Stein_ID;
                                                    RETURN temp_Stein_ID;
                                            END IF;

                                END IF;
                             END LOOP;
                        END IF;
                    END LOOP;
                RETURN NULL;
            END IF;

            IF var_spieler=2 THEN
                    DBMS_OUTPUT.PUT_LINE('Spieler'||var_spieler_name||'IST DRAN!' );
                    FOR v_counter IN 1 .. 4 LOOP
                        IF var_spieler_2(v_counter) != 0 THEN
                            FOR x_counter IN 1 ..4 LOOP
                                IF var_spieler_1(x_counter) !=0 THEN
                                            IF var_spieler_2(v_counter) + Augenzahl = var_spieler_1(x_counter)- 10 THEN
                                                    sql_query_1 := 'SELECT STEIN_ID FROM SPIELSTEIN WHERE STEIN_ID = x_counter ';
                                                    EXECUTE IMMEDIATE sql_query_1 INTO temp_Stein_ID;
                                                    RETURN temp_Stein_ID;
                                            END IF;
                                ELSIF var_spieler_3(x_counter) !=0 THEN
                                            IF var_spieler_2(v_counter) + Augenzahl = var_spieler_3(x_counter)- 30 THEN
                                                    sql_query_1 := 'SELECT STEIN_ID FROM SPIELSTEIN WHERE STEIN_ID = x_counter + 8 ';
                                                    EXECUTE IMMEDIATE sql_query_1 INTO temp_Stein_ID;
                                                    RETURN temp_Stein_ID;
                                            END IF;
                                ELSIF var_spieler_4(x_counter) !=0 THEN
                                            IF var_spieler_2(v_counter) + Augenzahl = var_spieler_4(x_counter)- 20 THEN
                                                    sql_query_1 := 'SELECT STEIN_ID FROM SPIELSTEIN WHERE STEIN_ID = x_counter + 12';
                                                    EXECUTE IMMEDIATE sql_query_1 INTO temp_Stein_ID;
                                                    RETURN temp_Stein_ID;
                                            END IF;

                                END IF;
                             END LOOP;
                        END IF;
                    END LOOP;
                RETURN NULL;
            END IF;

            IF var_spieler=3 THEN
                    DBMS_OUTPUT.PUT_LINE('Spieler'||var_spieler_name||'IST DRAN!' );
                    FOR v_counter IN 1 .. 4 LOOP
                        IF var_spieler_3(v_counter) != 0 THEN
                            FOR x_counter IN 1 ..4 LOOP
                                IF var_spieler_1(x_counter) !=0 THEN
                                            IF var_spieler_3(v_counter) + Augenzahl = var_spieler_1(x_counter)- 20 THEN
                                                    sql_query_1 := 'SELECT STEIN_ID FROM SPIELSTEIN WHERE STEIN_ID = x_counter ';
                                                    EXECUTE IMMEDIATE sql_query_1 INTO temp_Stein_ID;
                                                    RETURN temp_Stein_ID;
                                            END IF;
                                ELSIF var_spieler_2(x_counter) !=0 THEN
                                            IF var_spieler_3(v_counter) + Augenzahl = var_spieler_2(x_counter)- 10 THEN
                                                    sql_query_1 := 'SELECT STEIN_ID FROM SPIELSTEIN WHERE STEIN_ID = x_counter + 4 ';
                                                    EXECUTE IMMEDIATE sql_query_1 INTO temp_Stein_ID;
                                                    RETURN temp_Stein_ID;
                                            END IF;
                                ELSIF var_spieler_4(x_counter) !=0 THEN
                                            IF var_spieler_3(v_counter) + Augenzahl = var_spieler_4(x_counter)- 30 THEN
                                                    sql_query_1 := 'SELECT STEIN_ID FROM SPIELSTEIN WHERE STEIN_ID = x_counter + 12';
                                                    EXECUTE IMMEDIATE sql_query_1 INTO temp_Stein_ID;
                                                    RETURN temp_Stein_ID;
                                            END IF;

                                END IF;
                             END LOOP;
                        END IF;
                    END LOOP;
                RETURN NULL;
            END IF;
            IF var_spieler=4 THEN
                    DBMS_OUTPUT.PUT_LINE('Spieler'||var_spieler_name||'IST DRAN!' );
                    FOR v_counter IN 1 .. 4 LOOP
                        IF var_spieler_4(v_counter) != 0 THEN
                            FOR x_counter IN 1 ..4 LOOP
                                IF var_spieler_1(x_counter) !=0 THEN
                                            IF var_spieler_4(v_counter) + Augenzahl = var_spieler_1(x_counter)- 30 THEN
                                                    sql_query_1 := 'SELECT STEIN_ID FROM SPIELSTEIN WHERE STEIN_ID = x_counter ';
                                                    EXECUTE IMMEDIATE sql_query_1 INTO temp_Stein_ID;
                                                    RETURN temp_Stein_ID;
                                            END IF;
                                ELSIF var_spieler_2(x_counter) !=0 THEN
                                            IF var_spieler_4(v_counter) + Augenzahl = var_spieler_2(x_counter)- 20 THEN
                                                    sql_query_1 := 'SELECT STEIN_ID FROM SPIELSTEIN WHERE STEIN_ID = x_counter + 4 ';
                                                    EXECUTE IMMEDIATE sql_query_1 INTO temp_Stein_ID;
                                                    RETURN temp_Stein_ID;
                                            END IF;
                                ELSIF var_spieler_3(x_counter) !=0 THEN
                                            IF var_spieler_4(v_counter) + Augenzahl = var_spieler_3(x_counter)- 10 THEN
                                                    sql_query_1 := 'SELECT STEIN_ID FROM SPIELSTEIN WHERE STEIN_ID = x_counter + 8 ';
                                                    EXECUTE IMMEDIATE sql_query_1 INTO temp_Stein_ID;
                                                    RETURN temp_Stein_ID;
                                            END IF;

                                END IF;
                             END LOOP;
                        END IF;
                    END LOOP;
                RETURN NULL;
            END IF;
    END regel_2;

    /*
    Ist das Bilden einer Barriere möglich? Falls mehrere Barrieren gebildet werden können,
    ist die Rangfolge entspr. der Stärke der Barriere zu ermitteln. - (Siehe Anlage_1 Punkt_3)
    */
    FUNCTION regel_3 (Augenzahl NUMBER, Spieler_arg_Id Spieler.Spieler_ID%TYPE) RETURN NUMBER
        IS

        BEGIN

    END regel_3;

    /*
     Ist nochmaliges Würfeln möglich? Das nochmalige Würfeln wird zum folgenden Spielzug gerechnet. - (Siehe Anlage_1 Punkt_4)
    */
    FUNCTION regel_4 (Augenzahl NUMBER) RETURN BOOLEAN
        IS

        BEGIN
              IF Augenzahl=6 THEN
                  RETURN  TRUE;
              ELSE
                  RETURN FALSE;
            END IF;
    END regel_4;

    /*
        Wurde das Spiel gewonnen? In dem Fall dürfen keine weiteren Züge zum aktuellen Spiel möglich sein.- (Siehe Anlage_1 Punkt_5)
    */
    FUNCTION regel_5 RETURN BOOLEAN
        IS
            -- GELB SPIELER
            var_spieler_1 Spieler_1;
            -- ROTT SPIELER
            var_spieler_2 Spieler_2;
            -- BLAU SPIELER
            var_spieler_3 Spieler_3;
            -- GRUEN SPIELER
            var_spieler_4 Spieler_4;

            var_champion VARCHAR(75);
        BEGIN

            SELECT STEIN_POSITION BULK COLLECT INTO var_spieler_1 FROM SPIELSTEIN WHERE STEIN_ID <5;
            SELECT STEIN_POSITION BULK COLLECT INTO var_spieler_2 FROM SPIELSTEIN WHERE STEIN_ID >4  AND  STEIN_ID <9;
            SELECT STEIN_POSITION BULK COLLECT INTO var_spieler_3 FROM SPIELSTEIN WHERE STEIN_ID >8  AND  STEIN_ID <13;
            SELECT STEIN_POSITION BULK COLLECT INTO var_spieler_4 FROM SPIELSTEIN WHERE STEIN_ID >12 AND  STEIN_ID <17;

            IF var_spieler_1(1)>40 AND var_spieler_1(2)> 40 AND var_spieler_1(3)>40 AND var_spieler_1(4)>40 THEN
                SELECT Spieler_Id  INTO var_champion FROM SPIELER WHERE SPIELER_ID = 1;
                DBMS_OUTPUT.PUT_LINE(var_champion||' hat das Spiel Gewonnen!' );
                RETURN TRUE;
            ELSIF  var_spieler_2(1)>40 AND var_spieler_2(2)> 40 AND var_spieler_2(3)>40 AND var_spieler_2(4)>40 THEN
                SELECT Spieler_Id  INTO var_champion FROM SPIELER WHERE SPIELER_ID = 2;
                DBMS_OUTPUT.PUT_LINE(var_champion||' hat das Spiel Gewonnen!' );
                RETURN TRUE;
            ELSIF var_spieler_3(1)>40 AND var_spieler_3(2)> 40 AND var_spieler_3(3)>40 AND var_spieler_3(4)>40 THEN
                SELECT Spieler_Id  INTO var_champion FROM SPIELER WHERE SPIELER_ID = 3;
                DBMS_OUTPUT.PUT_LINE(var_champion||' hat das Spiel Gewonnen!' );
                RETURN TRUE;
            ELSIF var_spieler_4(1)>40 AND var_spieler_4(2)> 40 AND var_spieler_4(3)>40 AND var_spieler_4(4)>40 THEN
                SELECT Spieler_Id  INTO var_champion FROM SPIELER WHERE SPIELER_ID = 4;
                DBMS_OUTPUT.PUT_LINE(var_champion||' hat das Spiel Gewonnen!' );
                RETURN TRUE;
            END IF;
    END regel_5;

    /*
        Dieser PROCEDURE liefert uns die möglichen Züge, die vom Benutzer gespielt werden können.
        @param  Augenzahl IN NUMBER,
        @param  Spieler_arg_Id IN Spieler.Spieler_ID%TYPE
     */
    PROCEDURE ermittleSpielzuege(Augenzahl IN NUMBER, Spieler_arg_Id IN NUMBER)
        IS
            -- GELB SPIELER
            var_spieler_1 Spieler_1;
            -- ROTT SPIELER
            var_spieler_2 Spieler_2;
            -- BLAU SPIELER
            var_spieler_3 Spieler_3;
            -- GRUEN SPIELER
            var_spieler_4 Spieler_4;

            -- AKTIV Spieler
            var_spieler NUMBER(10);
            var_spieler_name VARCHAR(75);

            var_stein  NUMBER(10);
            var_stein_ID_gegner   NUMBER(10);

            v_counter   NUMBER(10);

            var_zuege Spiel_zuege;
            var_stein_position Zug_Stein;
        BEGIN
            SELECT Spieler_Id  INTO var_spieler FROM SPIELER WHERE SPIELER_ID = Spieler_arg_Id;
            SELECT SPIELER_NAME  INTO var_spieler_name FROM SPIELER WHERE SPIELER_ID = Spieler_arg_Id;

            SELECT STEIN_POSITION BULK COLLECT INTO var_spieler_1 FROM SPIELSTEIN WHERE STEIN_ID <5;
            SELECT STEIN_POSITION BULK COLLECT INTO var_spieler_2 FROM SPIELSTEIN WHERE STEIN_ID >4  AND  STEIN_ID <9;
            SELECT STEIN_POSITION BULK COLLECT INTO var_spieler_3 FROM SPIELSTEIN WHERE STEIN_ID >8  AND  STEIN_ID <13;
            SELECT STEIN_POSITION BULK COLLECT INTO var_spieler_4 FROM SPIELSTEIN WHERE STEIN_ID >12 AND  STEIN_ID <17;

            IF var_spieler=1 THEN
                        FOR v_counter IN 1..4 LOOP
                                        IF var_spieler_1(v_counter) != 0 THEN
                                                var_stein_ID_gegner = regel_2(Augenzahl,var_spieler);
                                                IF var_stein_ID_gegner !=0 THEN
                                                    var_stein_position(19) := 0;
                                                    CHAMP(1):= 1;
                                                    var_zuege(19) := var_stein_ID_gegner;
                                                ELSE
                                                    var_stein_position(v_counter) := var_spieler_1(v_counter) + Augenzahl;
                                                    var_zuege(v_counter) := v_counter;

                                                END IF;
                                        ELSE
                                                var_stein = regel_1(Augenzahl,var_spieler);
                                                IF var_stein != NULL THEN
                                                    var_stein_position(v_counter) :=1;
                                                    var_zuege(v_counter) := var_stein;
                                                    DBMS_OUTPUT.PUT_LINE('Spieler'||var_spieler_name||' bekommt noch ein Zug!' );
                                                end if;
                                                DBMS_OUTPUT.PUT_LINE('Sorry!'||var_spieler_name||' Du hast dies mal 6 nicht bekommen!' );
                                                DBMS_OUTPUT.PUT_LINE('Jetzt ist der nächste Spieler dran!' );
                                        end if;
                        END LOOP;
            ELSIF var_spieler=2 THEN
                        FOR v_counter IN 1..4 LOOP
                                        IF var_spieler_2(v_counter) != 0 THEN
                                                var_stein_ID_gegner = regel_2(Augenzahl,var_spieler);
                                                IF var_stein_ID_gegner !=0 THEN
                                                    DBMS_OUTPUT.PUT_LINE('Spieler '||var_spieler_name||' kann eine gegner schalgen!' );
                                                    var_stein_position(19) := 0;
                                                    CHAMP(1):= 2;
                                                    var_zuege(19) := var_stein_ID_gegner;
                                                ELSE
                                                    DBMS_OUTPUT.PUT_LINE('Spieler '||var_spieler_name||' kann '||Augenzahl||' Schritte weiter gehen' );
                                                    var_stein_position(v_counter) := var_spieler_2(v_counter) + Augenzahl;
                                                    var_zuege(v_counter) := v_counter+4;

                                                END IF;
                                        ELSE
                                                var_stein = regel_1(Augenzahl,var_spieler);
                                                IF var_stein != NULL THEN
                                                    DBMS_OUTPUT.PUT_LINE('Spieler '||var_spieler_name||' kann ein Stein aus dem B-EFLD raus ziehen!' );
                                                    var_stein_position(v_counter) :=1;
                                                    var_zuege(v_counter) := var_stein;
                                                    DBMS_OUTPUT.PUT_LINE('Spieler '||var_spieler_name||' bekommt noch ein Zug!' );
                                                end if;
                                                DBMS_OUTPUT.PUT_LINE('Sorry! '||var_spieler_name||' Du hast dies mal 6 nicht bekommen!' );
                                                DBMS_OUTPUT.PUT_LINE('Jetzt ist der nächste Spieler dran!' );
                                        end if;
                        END LOOP;
            ELSIF var_spieler =3 THEN
                        FOR v_counter IN 1..4 LOOP
                                        IF var_spieler_3(v_counter) != 0 THEN
                                                var_stein_ID_gegner = regel_2(Augenzahl,var_spieler);
                                                IF var_stein_ID_gegner !=0 THEN
                                                    var_stein_position(19) := 0;
                                                    CHAMP(1):= 3;
                                                    var_zuege(19) := var_stein_ID_gegner;
                                                ELSE
                                                    var_stein_position(v_counter) := var_spieler_1(v_counter) + Augenzahl;
                                                    var_zuege(v_counter) := v_counter+8;

                                                END IF;
                                        ELSE
                                                var_stein = regel_1(Augenzahl,var_spieler);
                                                IF var_stein != NULL THEN
                                                    var_stein_position(v_counter) :=1;
                                                    var_zuege(v_counter) := var_stein;
                                                    DBMS_OUTPUT.PUT_LINE('Spieler'||var_spieler_name||' bekommt noch ein Zug!' );
                                                end if;
                                                DBMS_OUTPUT.PUT_LINE('Sorry!'||var_spieler_name||' Du hast dies mal 6 nicht bekommen!' );
                                                DBMS_OUTPUT.PUT_LINE('Jetzt ist der nächste Spieler dran!' );
                                        end if;
                        END LOOP;
            ELSIF var_spieler=4 THEN
                        FOR v_counter IN 1..4 LOOP
                                        IF var_spieler_4(v_counter) != 0 THEN
                                                var_stein_ID_gegner = regel_2(Augenzahl,var_spieler);
                                                IF var_stein_ID_gegner !=0 THEN
                                                    var_stein_position(19) := 0;
                                                    CHAMP(1):= 4;
                                                    var_zuege(19) := var_stein_ID_gegner;
                                                ELSE
                                                    var_stein_position(v_counter) := var_spieler_1(v_counter) + Augenzahl;
                                                    var_zuege(v_counter) := v_counter+12;

                                                END IF;
                                        ELSE
                                                var_stein = regel_1(Augenzahl,var_spieler);
                                                IF var_stein != NULL THEN
                                                    var_stein_position(v_counter)=1;
                                                    var_zuege(v_counter) := var_stein;
                                                    DBMS_OUTPUT.PUT_LINE('Spieler'||var_spieler_name||' bekommt noch ein Zug!' );
                                                end if;
                                                DBMS_OUTPUT.PUT_LINE('Sorry!'||var_spieler_name||' Du hast dies mal 6 nicht bekommen!' );
                                                DBMS_OUTPUT.PUT_LINE('Jetzt ist der nächste Spieler dran!' );
                                        end if;
                        END LOOP;
            end if;
        END ermittleSpielzuege;
    /*
        Diese Prozedur setzt die Werte des neu gewählten Zuges durch den Spieler
        @param Spieler_Id Spieler.Spieler_ID%TYPE,
        @param Zug IN NUMBER
     */
    PROCEDURE zieheSpielstein (Spieler_Id NUMBER,Zug IN NUMBER)
        IS
            var_spieler NUMBER(10);
            sql_query_1 VARCHAR2(200);
            sql_query_2 VARCHAR2(200);
            Stein_ID Spiel_zuege;
            Stein_position Zug_Stein;

        BEGIN
                sql_query_1 := 'UPDATE SPIELSTEIN'||' SET STEIN_POSITION = :pos WHERE STEIN_ID = :id';
                EXECUTE IMMEDIATE sql_query_1 USING Stein_position(Zug), Stein_ID(Zug);
                COMMIT;
                sql_query_2 := 'INSERT INTO SPIELABLAUF(spielablauf_id, spiel_time, steine_position, spielablauf_spieler_id, spielablauf_stein_id) VALUES(:string)';
                EXECUTE IMMEDIATE sql_query_2 USING SPIELABLAUF_SEQ_ID.nextval,CURRENT_TIMESTAMP,Stein_position(Zug),Spieler_Id, Stein_ID(Zug) ;
                COMMIT;
        EXCEPTION
                WHEN others THEN
                    DBMS_OUTPUT.PUT_LINE(sqlerrm);
                ROLLBACK;
        END zieheSpielstein;
    /**
        Diese Funktion zeigt die aktuelle Situation des Spiels auf der Konsole
        @return NUMBER
    */
/*
    FUNCTION show_Spielbrett RETURN NUMBER
        IS
            CURSOR brett_cursor IS
        SELECT STEIN_POSITION,STEIN_FARBE FROM SPIELSTEIN ;
            brett_record SPIELSTEIN%ROWTYPE;
    BEGIN

           FOR brett_record IN brett_cursor LOOP

            DBMS_OUTPUT.PUT_LINE('Stein FARBE' || brett_record.STEIN_FARBE ||
                 ' Position  '|| brett_record.STEIN_POSITION);
           END LOOP;
        RETURN NULL;
    END show_Spielbrett;*/

    /*
        Diese Prozedur steuert den Spielablauf, jeder Spieler ruft diese Prozedur abwechselnd auf.
        @param Spieler_arg_Id IN Spieler.Spieler_ID%TYPE
     */

    PROCEDURE amZug (Spieler_arg_Id IN Spieler.Spieler_ID%TYPE)
        IS
            var_spieler NUMBER(10);
            Zug Zug_Stein;
            stein_id Spiel_zuege;

            position NUMBER(10);
            dice NUMBER(1);
        BEGIN
            SELECT SPIELER_ID  INTO var_spieler FROM SPIELER WHERE SPIELER_ID =Spieler_arg_Id;

            if regel_5()= FALSE THEN
                    DBMS_OUTPUT.PUT_LINE('SPIELER mit Spieler ID'||var_spieler||'ist dran');
                    dice := wuerfeln();
                    DBMS_OUTPUT.PUT_LINE('DIE ERGEBNISS DER WÜRFELN IST:'||dice);
                    ermittleSpielzuege(dice,var_spieler);
                    DBMS_OUTPUT.PUT_LINE('Der Spieler hat folgende möglichkeiten.');
                    DBMS_OUTPUT.PUT_LINE('Der Spieler kann sein Stein A '||stein_id(1)||'  '||Zug(1)||' Schritte weiter bewegen');
                    DBMS_OUTPUT.PUT_LINE('Der Spieler kann sein Stein B '||stein_id(2)||'  '||Zug(2)||' Schritte weiter bewegen');
                    DBMS_OUTPUT.PUT_LINE('Der Spieler kann sein Stein C '||stein_id(3)||'  '||Zug(3)||' Schritte weiter bewegen');
                    DBMS_OUTPUT.PUT_LINE('Der Spieler kann sein Stein D '||stein_id(4)||'  '||Zug(4)||' Schritte weiter bewegen');

                    DBMS_OUTPUT.PUT_LINE('Der Spieler hat entschieden für : '||stein_id(4)||'  weiter zu bewegen');


                    zieheSpielstein(var_spieler,4);

                    DBMS_OUTPUT.PUT_LINE('Der Spielbrett sieht jetzt so aus ');
                    show_Spielbrett();

                ELSE
                    regel_5();
                end if;

        END amZug;




END Brettspiel_pkg;
/

