DECLARE
  CURSOR stuff is SELECT object_type, object_name FROM ALL_OBJECTS WHERE OBJECT_TYPE IN ('PROCEDURE', 'TABLE', 'PROCEDURE', 'FUNCTION', 'VIEW', 'TRIGGER') and OWNER='STUDENT';
  v_nume VARCHAR2(80);
  v_tip VARCHAR2(30);
BEGIN
  OPEN stuff;
  LOOP
    EXIT WHEN stuff%NOTFOUND;
    FETCH stuff into v_tip, v_nume;
    DBMS_OUTPUT.PUT_LINE(v_tip || ' -> ' || v_nume);
  END LOOP;
END;