CREATE OR REPLACE DIRECTORY ex2_dir AS 'D:\Anul 2\Semestrul 2\PSGBD\Teme\Dragan_SilviuConstantin_A7_10';
GRANT READ ON DIRECTORY ex2_dir TO PUBLIC;

set SERVEROUTPUT ON;
DECLARE
  v_file UTL_FILE.FILE_TYPE;
  CURSOR c_tabel IS SELECT table_name FROM user_tables;
  CURSOR c_functie IS SELECT object_name FROM ALL_OBJECTS WHERE OBJECT_TYPE IN ('FUNCTION') and OWNER='STUDENT';
  CURSOR c_procedura IS SELECT object_name FROM ALL_OBJECTS WHERE OBJECT_TYPE IN ('PROCEDURE') and OWNER='STUDENT';
  CURSOR c_view IS SELECT object_name FROM ALL_OBJECTS WHERE OBJECT_TYPE IN ('VIEW') and OWNER='STUDENT';
  CURSOR c_trigger IS SELECT object_name FROM ALL_OBJECTS WHERE OBJECT_TYPE IN ('TRIGGER') and OWNER='STUDENT';
  v_cursor INTEGER;
  v_nume_obiect VARCHAR2(50);
  v_creare_obiect CLOB;
  v_coloane INTEGER;
  v_it INTEGER;
  v_query VARCHAR2(100);
  type array_t is varray(200) of varchar2(300);
  array array_t := array_t('', '', '', '','', '','', '','', '','', '');
  v_rownum INTEGER;
  v_insert CLOB;
  v_insert_final CLOB;
BEGIN
  v_file := UTL_FILE.FOPEN('EX2_DIR', 'export.sql', 'W');
  
  -- Tabele
  OPEN c_tabel;
  LOOP
    EXIT WHEN c_tabel%NOTFOUND;
    FETCH c_tabel into v_nume_obiect;
    SELECT DBMS_METADATA.GET_DDL('TABLE', v_nume_obiect) into v_creare_obiect FROM USER_TABLES where rownum <= 1;
    utl_file.put_line(v_file, v_creare_obiect);
    
    select count(column_name) into v_coloane from user_tab_columns where table_name = v_nume_obiect;
    v_query := 'SELECT * FROM ' || v_nume_obiect;
    v_cursor := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor, v_query, DBMS_SQL.V7);
    FOR v_it in 1..v_coloane LOOP
      DBMS_SQL.DEFINE_COLUMN(v_cursor, v_it, array(v_it), 300);
    END LOOP;
    v_rownum :=  DBMS_SQL.EXECUTE(v_cursor);
    
    LOOP
      IF DBMS_SQL.FETCH_ROWS(v_cursor) = 0 THEN
          EXIT;
      END IF;
      v_insert := 'INSERT INTO ' || v_nume_obiect || ' VALUES(';
      FOR v_it in 1..v_coloane LOOP
        DBMS_SQL.COLUMN_VALUE(v_cursor, v_it, array(v_it));
        v_insert := v_insert || q'$'$' || array(v_it) ||  q'$'$' || ', ';
      END LOOP;
      v_insert_final := substr(v_insert, 1, length(v_insert)-2);
      v_insert_final := v_insert_final || ');';
      utl_file.put_line(v_file, v_insert_final);
    END LOOP;
  END LOOP;
  CLOSE c_tabel;
    
  -- Functii
  OPEN c_functie;
  LOOP
    EXIT WHEN c_functie%NOTFOUND;
    FETCH c_functie into v_nume_obiect;
    SELECT DBMS_METADATA.GET_DDL('FUNCTION', v_nume_obiect) into v_creare_obiect FROM USER_TABLES where rownum <= 1;
    utl_file.put_line(v_file, v_creare_obiect);
  END LOOP;
  CLOSE c_functie;
  
  --Proceduri
  OPEN c_procedura;
  LOOP
    EXIT WHEN c_procedura%NOTFOUND;
    FETCH c_procedura into v_nume_obiect;
    SELECT DBMS_METADATA.GET_DDL('PROCEDURE', v_nume_obiect) into v_creare_obiect FROM USER_TABLES where rownum <= 1;
    utl_file.put_line(v_file, v_creare_obiect);
  END LOOP;
  CLOSE c_procedura;
  
  -- View-uri
  OPEN c_view;
  LOOP
    EXIT WHEN c_view%NOTFOUND;
    FETCH c_view into v_nume_obiect;
    SELECT DBMS_METADATA.GET_DDL('VIEW', v_nume_obiect) into v_creare_obiect FROM USER_TABLES where rownum <= 1;
    utl_file.put_line(v_file, v_creare_obiect);
  END LOOP;
  CLOSE c_view; 
  
  -- Triggers
  OPEN c_trigger;
  LOOP
    EXIT WHEN c_trigger%NOTFOUND;
    FETCH c_trigger into v_nume_obiect;
    SELECT DBMS_METADATA.GET_DDL('TRIGGER', v_nume_obiect) into v_creare_obiect FROM USER_TABLES where rownum <= 1;
    utl_file.put_line(v_file, v_creare_obiect);
  END LOOP;
  CLOSE c_trigger;
  UTL_FILE.FCLOSE(v_file);
END;