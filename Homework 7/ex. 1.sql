DROP TABLE q_bucket;
CREATE TABLE q_bucket(ID NUMBER(10,0), CHAPTER_ID NUMBER(10,0), USER_ID NUMBER(10,0), QUESTION CLOB, ANSWER CLOB, ASKED NUMBER(10,0), SOLVED NUMBER(10,0), REPORTED NUMBER(10,0),
REPORT_RESOLVED NUMBER(10,0), CREATED_AT TIMESTAMP(6), UPDATED_AT TIMESTAMP(6));
  
CREATE OR REPLACE PACKAGE mostenire_intrebari is
  PROCEDURE test(p_q_id questions.id%type);
  PROCEDURE testare_intrebari(p_q_id questions.id%type);
END mostenire_intrebari;

CREATE OR REPLACE PACKAGE BODY mostenire_intrebari IS
  
  v_relevanta INTEGER;
  v_it questions.id%type;
  v_id questions.id%type;
  PROCEDURE test(p_q_id questions.id%type)
    IS BEGIN
      v_it := -1;
      select relevanta(p_q_id) into v_relevanta from dual;
      IF(v_relevanta = 0) THEN
        raise_application_error(-20024, 'Intrebarea nu e suficient de buna.');
      ELSE
        SELECT count(id) into v_it from q_bucket where id = p_q_id;
        IF(v_it = 0) THEN
          INSERT INTO q_bucket SELECT id, chapter_id, user_id, question, answer, asked, solved, reported, report_resolved, created_at, updated_at from questions where id = p_q_id;
          commit;
        ELSE
          DBMS_OUTPUT.PUT_LINE('Intrebarea exista deja in tabel.');
        END IF;
      END IF;
  END test;
   
  PROCEDURE testare_intrebari(p_q_id questions.id%type) AS
    v_relevanta INTEGER;
    null_relevance EXCEPTION;
    v_id INTEGER;
    v_count INTEGER := 0;
    PRAGMA EXCEPTION_INIT(null_relevance, -20024);
  BEGIN
    LOOP
     BEGIN
        v_id := dbms_random.value(17,6416);
        test(v_id);
        EXCEPTION
          WHEN null_relevance THEN
            DBMS_OUTPUT.PUT_LINE('Intrebarea ' || v_id || ' nu e suficient de buna.');
      END;
      select count(id) into v_count from q_bucket;
      EXIT WHEN v_count = p_q_id;
    END LOOP;
  END testare_intrebari;
END mostenire_intrebari;


set serveroutput on;
BEGIN
  mostenire_intrebari.testare_intrebari(1000);
END;

