DECLARE
  CURSOR c_tabel IS SELECT table_name FROM user_tables;
  CURSOR c_functie IS SELECT object_name FROM ALL_OBJECTS WHERE OBJECT_TYPE IN ('FUNCTION') and OWNER='STUDENT';
  CURSOR c_procedura IS SELECT object_name FROM ALL_OBJECTS WHERE OBJECT_TYPE IN ('PROCEDURE') and OWNER='STUDENT';
  CURSOR c_view IS SELECT object_name FROM ALL_OBJECTS WHERE OBJECT_TYPE IN ('VIEW') and OWNER='STUDENT';
  CURSOR c_trigger IS SELECT object_name FROM ALL_OBJECTS WHERE OBJECT_TYPE IN ('TRIGGER') and OWNER='STUDENT';
  v_cursor INTEGER;
  v_rownum INTEGER;
  v_nume_obiect VARCHAR(100);
BEGIN
  -- Drop tables
  OPEN c_tabel;
  LOOP
    EXIT WHEN c_tabel%NOTFOUND;
    FETCH c_tabel into v_nume_obiect;
    v_cursor := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor, 'DROP TABLE ' || v_nume_obiect, DBMS_SQL.V7);
    v_rownum := dbms_sql.execute(v_cursor);
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR(v_cursor);
  CLOSE c_tabel;
  
  -- Drop functions
  OPEN c_functie;
  LOOP
    EXIT WHEN c_functie%NOTFOUND;
    FETCH c_functie into v_nume_obiect;
    v_cursor := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor, 'DROP FUNCTION ' || v_nume_obiect, DBMS_SQL.V7);
    v_rownum := dbms_sql.execute(v_cursor);
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR(v_cursor);
  CLOSE c_functie;
  
  -- Drop procedures
  OPEN c_procedura;
  LOOP
    EXIT WHEN c_procedura%NOTFOUND;
    FETCH c_procedura into v_nume_obiect;
    v_cursor := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor, 'DROP PROCEDURE ' || v_nume_obiect, DBMS_SQL.V7);
    v_rownum := dbms_sql.execute(v_cursor);
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR(v_cursor);
  CLOSE c_procedura;
  
  -- Drop Triggers
  OPEN c_trigger;
  LOOP
    EXIT WHEN c_trigger%NOTFOUND;
    FETCH c_trigger into v_nume_obiect;
    v_cursor := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor, 'DROP TRIGGER ' || v_nume_obiect, DBMS_SQL.V7);
    v_rownum := dbms_sql.execute(v_cursor);
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR(v_cursor);
  CLOSE c_trigger;
END;