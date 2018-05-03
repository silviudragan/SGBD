DROP INDEX index_1;
CREATE INDEX index_1
ON ANSWERS (user_id, solved, id);

set serveroutput on;
DECLARE
    v_relevanta INTEGER;
    v_user_relevanta_maxima answers.user_id%type;
    TYPE q_id_value IS TABLE of answers.question_id%type;
    v_id_intrebare q_id_value;
    v_iterator INTEGER;
    v_relevanta_maxima INTEGER := 0;
    v_id_relevanta_maxima users.id%type;
    v_role users.user_role%type;
    v_nume users.name%type;
BEGIN
    v_relevanta := -1;
    select id BULK COLLECT into v_id_intrebare from questions;
    FOR v_iterator in 1..v_id_intrebare.COUNT LOOP
      select relevanta(v_id_intrebare(v_iterator)) into v_relevanta from dual;
      select user_role into v_role from users u
      join questions q on q.user_id = u.id
      where q.id = v_id_intrebare(v_iterator);
      DBMS_OUTPUT.PUT_LINE('Intrebarea cu id-ul ' || v_id_intrebare(v_iterator) || ' are relevanta ' || v_relevanta);
      IF(v_relevanta > v_relevanta_maxima and v_role != 'admin')
        THEN
          v_relevanta_maxima := v_relevanta;
          select user_id into v_id_relevanta_maxima from questions where id = v_id_intrebare(v_iterator);
      END IF;    
      END LOOP;
    select name into v_nume from users where id = v_id_relevanta_maxima;
    DBMS_OUTPUT.PUT_LINE(v_nume || ' are intrebarea cu relevanta maxima ' || v_relevanta_maxima);
END;