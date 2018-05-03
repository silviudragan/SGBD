set serveroutput on;
declare
    v_count_2_prenume INTEGER := 0;
    TYPE statistica IS TABLE OF tema3.prenume%type;
    v_prenume statistica;
    v_iterator INTEGER;
begin
    select prenume BULK COLLECT into v_prenume from tema3;
    for v_iterator in 1..50 LOOP
      IF(trim(v_prenume(v_iterator)) like '% %') 
        THEN
          v_count_2_prenume := v_count_2_prenume + 1;
          DBMS_OUTPUT.PUT_LINE(v_prenume(v_iterator));
      END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Procentul persoanelor ce au 2 prenume este de ' || v_count_2_prenume/50*100 ||'%.'); 
end;
