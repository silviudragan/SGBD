CREATE OR REPLACE PROCEDURE Intrebare  IS
v_id_q INTEGER;
v_cursor1 INTEGER;
row_num INTEGER;
v_cursor_intrebare INTEGER;
v_username VARCHAR2(30);
v_raspunsuri INTEGER;
v_raspunsuri_corecte INTEGER;
v_creata_la TIMESTAMP(6);
CURSOR promotie IS select id from questions where created_at > '15-JAN-17';
BEGIN
  OPEN promotie;
  LOOP
    FETCH promotie into v_id_q;
    EXIT WHEN promotie%NOTFOUND;
    v_cursor1 := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor1, 'CREATE TABLE intrebare_' || v_id_q || '(
                                  username varchar(60),
                                  raspunsuri int,
                                  raspunsuri_corecte int,
                                  creata_la timestamp(6)
                               )', DBMS_SQL.V7);
    row_num := dbms_sql.execute(v_cursor1);
    DBMS_SQL.CLOSE_CURSOR(v_cursor1);
    v_cursor_intrebare := DBMS_SQL.OPEN_CURSOR;
    
    select u.username into v_username from users u
    join questions q on q.user_id = u.id
    where q.id = v_id_q;
    
    select asked, solved, created_at into v_raspunsuri, v_raspunsuri_corecte, v_creata_la from questions where id = v_id_q;
    
    DBMS_SQL.PARSE(v_cursor_intrebare, 'INSERT INTO intrebare_' || v_id_q || '(username, raspunsuri, raspunsuri_corecte, creata_la) VALUES (:v_username, :v_raspunsuri, :v_raspunsuri_corecte, :v_creata_la)', DBMS_SQL.V7);
    
    DBMS_SQL.BIND_VARIABLE(v_cursor_intrebare, ':v_username', v_username);
    DBMS_SQL.BIND_VARIABLE(v_cursor_intrebare, ':v_raspunsuri', v_raspunsuri);
    DBMS_SQL.BIND_VARIABLE(v_cursor_intrebare, ':v_raspunsuri_corecte', v_raspunsuri_corecte);
    DBMS_SQL.BIND_VARIABLE(v_cursor_intrebare, ':v_creata_la', v_creata_la);
    row_num := DBMS_SQL.EXECUTE(v_cursor_intrebare);
    DBMS_SQL.CLOSE_CURSOR(v_cursor_intrebare);
    
  END LOOP;
  CLOSE promotie;
END;

CREATE OR REPLACE PROCEDURE Delete_questions IS
v_id_q INTEGER;
row_num INTEGER;
v_cursor1 INTEGER;
CURSOR promotie IS select * from(select id from questions where created_at > '15-JAN-17')
                              where rownum < 11;
BEGIN 
  OPEN promotie;
  LOOP
    FETCH promotie into v_id_q;
    EXIT WHEN promotie%NOTFOUND;
    v_cursor1 := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor1, 'DROP TABLE intrebare_' || v_id_q, DBMS_SQL.V7);
    row_num := dbms_sql.execute(v_cursor1);
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR(v_cursor1);
  CLOSE promotie;
END;

BEGIN
  Intrebare;
  --Delete_questions;
END;