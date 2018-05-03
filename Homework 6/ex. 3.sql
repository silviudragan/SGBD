DROP TABLE colectie;
CREATE TABLE colectie(nume VARCHAR2(20), prenume VARCHAR2(20));
CREATE OR REPLACE PROCEDURE relevanta_student(v_colectie colectie%rowtype) AS
  v_id INTEGER;
  CURSOR intrebari_user IS select id from questions where user_id = v_id;
  v_question INTEGER;
  v_count_relevanta_nenula INTEGER := 0;
  v_relevanta INTEGER;
BEGIN
  select id INTO v_id from users where username like lower(v_colectie.prenume)|| '.'||lower(v_colectie.nume);
  OPEN intrebari_user;
  LOOP
    FETCH intrebari_user into v_question;
    v_relevanta := relevanta(v_question);
    IF(v_relevanta > 0)
      THEN
        v_count_relevanta_nenula := v_count_relevanta_nenula + 1;
    END IF;
    EXIT WHEN intrebari_user%NOTFOUND;
  END LOOP;
  CLOSE intrebari_user;
  IF v_count_relevanta_nenula = 0
    THEN
      DBMS_OUTPUT.PUT_LINE(v_colectie.nume || ' ' || v_colectie.prenume || ' nu are intrebari relevante.');
    ELSE IF v_count_relevanta_nenula = 1
        THEN
          DBMS_OUTPUT.PUT_LINE(v_colectie.nume || ' ' || v_colectie.prenume || ' are o singura intrebare relevanta.');
          ELSE
            DBMS_OUTPUT.PUT_LINE(v_colectie.nume || ' ' || v_colectie.prenume || ' are ' || v_count_relevanta_nenula || ' intrebari relevante.');
        END IF;
  END IF;      
END;

set serveroutput on;
DECLARE 
  TYPE inregistrare IS RECORD(
  nume VARCHAR2(20),
  prenume VARCHAR2(20)
  );
  colectie_1 inregistrare;
BEGIN
  colectie_1.nume := 'Dragan';
  colectie_1.prenume := 'Silviu';
  relevanta_student(colectie_1);
END;