CREATE OR REPLACE PROCEDURE Student_info(p_id users.id%type)  IS
v_cursor1 INTEGER;  
v_nume VARCHAR2(50);
v_intrebari_puse INTEGER;
v_lenes INTEGER;
v_intrebari_relevante INTEGER;
v_reporturi_total INTEGER;
v_reporturi_gresite INTEGER;
row_num INTEGER;
BEGIN
    execute immediate 'select name, puturos, intrebari_puse, intrebari_relevante, reporturi_total, reporturi_gresite from u'||p_id into v_nume, v_lenes, v_intrebari_puse, v_intrebari_relevante, v_reporturi_total, v_reporturi_gresite;
    
    DBMS_OUTPUT.PUT_LINE(v_nume);
    DBMS_OUTPUT.PUT_LINE('Student lenes: ' || v_lenes);
    DBMS_OUTPUT.PUT_LINE('Intrebari puse: ' || v_intrebari_puse || ' dintre care relevante: ' || v_intrebari_relevante);
    DBMS_OUTPUT.PUT_LINE('Reporturi date: ' || v_reporturi_total || ' dintre care gresite: ' || v_reporturi_gresite);
    EXCEPTION
      WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE('Nu exista un tabel pentru studentul cu id-ul ' || p_id);
END;

set serveroutput on;
BEGIN
  Student_info(318);
END;
