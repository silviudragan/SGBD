DECLARE
  cursor c_comenzi IS select comanda from log_istoric order by data_modificare;
  v_comanda VARCHAR(250);
  v_cursor INTEGER;
  row_num INTEGER;
BEGIN
  OPEN c_comenzi;
  LOOP
    FETCH c_comenzi into v_comanda;
    EXIT WHEN c_comenzi%NOTFOUND;
    v_cursor := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor, v_comanda, DBMS_SQL.V7);
    row_num := dbms_sql.execute(v_cursor);
    DBMS_SQL.CLOSE_CURSOR(v_cursor); 
  END LOOP;
  CLOSE c_comenzi;
END;