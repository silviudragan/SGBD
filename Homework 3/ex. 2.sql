set serveroutput on;
declare 
    CURSOR lucky_week IS select id from questions where updated_at >= '15-JAN-17';
    CURSOR statistica IS 
      select 'Userul ' || user_id || ' a avut ' || count(user_id) || ' intrebari norocoase. ' from questions
      where report_resolved = 2
      group by user_id
      order by user_id;
    v_numar_reporturi INTEGER := 0;
    v_numar_inregistrari INTEGER := 0;
    v_iterator INTEGER;
    v_id questions.id%type;
    v_nr_reporturi INTEGER;
    v_count_per_id INTEGER;
    v_check_update INTEGER;
    v_output varchar2(150);
    
begin
    --aflam numarul de intrebari ce au fost puse dupa 15 ianuarie 2017.
    select count(id) into v_numar_inregistrari from questions where updated_at >= '15-JAN-17';
    
    --DBMS_OUTPUT.PUT_LINE(v_numar_inregistrari);
    OPEN lucky_week;
    FOR v_iterator in 1..v_numar_inregistrari LOOP
      FETCH lucky_week into v_id;
      select count(QUESTION_ID) into v_nr_reporturi from reports where QUESTION_ID = v_id;
      --DBMS_OUTPUT.PUT_LINE(v_id || '    ' || v_nr_reporturi);
      IF(v_nr_reporturi >= 5) 
        THEN
          update questions set report_resolved = 2 where id = v_id;
      END IF;
    END LOOP;
    CLOSE lucky_week;
    
    --aflam numarul de intrebari puse.
    select count(id) into v_numar_inregistrari from questions;
    
    OPEN statistica;
    LOOP
      FETCH statistica into v_output;
      DBMS_OUTPUT.PUT_LINE(v_output);
      EXIT WHEN statistica%NOTFOUND;
    END LOOP;
    CLOSE statistica;
end;