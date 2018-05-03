set serveroutput on;
<<bloc1>>
declare 
    v_bloc1 VARCHAR2(10) := 'Dragan';
begin
    DBMS_OUTPUT.PUT_LINE('In blocul 1: ' || v_bloc1); --va afisa "Dragan"
    <<bloc2>>
    declare 
        v_bloc1 VARCHAR2(15) := 'Silviu';
    begin
        DBMS_OUTPUT.PUT_LINE('In blocul 2: ' || v_bloc1); --va afisa "Silviu" deoarece se ia in considerare valoarea lui v_bloc1 din <<bloc2>>
        DBMS_OUTPUT.PUT_LINE('In blocul 2 variabila din blocul 1: ' || bloc1.v_bloc1); --pentru a afisa valoarea din blocul "principal" trebuie sa utilizam o metoda de marcare
        <<bloc3>>
        declare 
            v_bloc1 int := 20;
        begin 
            DBMS_OUTPUT.PUT_LINE('In blocul 3: ' || v_bloc1); --va afisa "20"
            DBMS_OUTPUT.PUT_LINE('In blocul 3 din blocul 1: ' || bloc1.v_bloc1); -- daca vrem sa afisam valoarea lui v_bloc1 din celelalte blocuri vom utiliza metodele de marcare, bloc1.v_bloc1
            DBMS_OUTPUT.PUT_LINE('In blocul 3 din blocul 2: ' || bloc2.v_bloc1); -- respectiv bloc2.v_bloc1
        end;
    end;
end;