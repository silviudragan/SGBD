CREATE OR REPLACE PACKAGE exercitiul_1 IS
    FUNCTION studenti_puturosi(p_id INTEGER) return integer;
    FUNCTION relevanta(p_q_id answers.question_id%type) return integer;
    FUNCTION relevanta(p_username users.username%type) return integer;
END exercitiul_1;

CREATE OR REPLACE PACKAGE BODY exercitiul_1 IS
      v_asd integer;
      
   FUNCTION studenti_puturosi(p_id integer)
    RETURN integer AS
        v_return INTEGER;
        v_intrebari_corecte INTEGER;
        v_intrebari_gresite INTEGER;
    BEGIN
        v_return := 1;
        select count(solved) into v_intrebari_corecte from answers where user_id = p_id and solved = 1;
        select count(solved) into v_intrebari_gresite from answers where user_id = p_id and solved = 0;
        IF(v_intrebari_gresite > v_intrebari_corecte)
          THEN
            v_return := 0;
        END IF;
        return v_return;
    END;
    
    
    FUNCTION relevanta(p_username users.username%type)
    RETURN integer AS
        v_relevanta_maxima INTEGER;
        v_id_user INTEGER;
        v_question_id INTEGER;
        v_relevanta INTEGER;
        CURSOR intrebari_user IS select id from questions where user_id = v_id_user;
    BEGIN
        v_relevanta_maxima := 0;
        select id into v_id_user from users where username = p_username;
        OPEN intrebari_user;
        LOOP
          FETCH intrebari_user into v_question_id;
          v_relevanta := relevanta(v_question_id);
          IF(v_relevanta > v_relevanta_maxima)
            THEN
              v_relevanta_maxima := v_relevanta;
          END IF;
          EXIT WHEN intrebari_user%NOTFOUND;
        END LOOP;
        CLOSE intrebari_user;
        return v_relevanta_maxima;
    END;
     
     
    FUNCTION relevanta(p_q_id answers.question_id%type)
    RETURN integer AS
        v_return INTEGER;
        v_rezultat INTEGER;
        v_us_id questions.user_id%type;
        v_puturos INTEGER;
        v_nr_neputurosi INTEGER := 0;
        CURSOR useri IS select user_id from answers where question_id = p_q_id; 
    BEGIN
        v_return := -1;
        select count(question_id) into v_rezultat from answers where question_id = p_q_id;
        IF(v_rezultat < 20)
          THEN
            v_return := 0;
        END IF;    
        OPEN useri;
        LOOP
          FETCH useri into v_us_id;
          select studenti_puturosi(v_us_id) into v_puturos from dual;
          IF(v_puturos = 1)
            THEN
              v_nr_neputurosi := v_nr_neputurosi + 1;
          END IF;
          EXIT WHEN useri%NOTFOUND;
        END LOOP;
        IF(v_rezultat != 0)
          THEN
            IF((100*v_nr_neputurosi)/v_rezultat < 30 or (100*v_nr_neputurosi)/v_rezultat > 90)
              THEN
                v_return := 0;
            END IF;
        END IF;
        IF(v_return = -1)
          THEN
            v_return := v_rezultat;
        END IF;
        CLOSE useri;
        return v_return;
    END;

    
END exercitiul_1;

set serveroutput on;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Relevanta este ' || exercitiul_1.relevanta('silviu.dragan'));
END;