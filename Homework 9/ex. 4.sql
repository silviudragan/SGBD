CREATE OR REPLACE PROCEDURE clone_table(tabel_sursa VARCHAR2, tabel_destinatie VARCHAR2) IS
v_cursor1 INTEGER;
row_num INTEGER;
BEGIN
  v_cursor1 := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(v_cursor1, 'CREATE TABLE ' || tabel_destinatie || ' as select * from ' || tabel_sursa, DBMS_SQL.V7);
  row_num := dbms_sql.execute(v_cursor1);
  DBMS_SQL.CLOSE_CURSOR(v_cursor1);
END;

DECLARE
sursa VARCHAR2(20);
destinatie VARCHAR(20);
BEGIN
  sursa := 'users';
  destinatie := 'users_clone';
  clone_table(sursa, destinatie);
END;