set serveroutput on;
CREATE OR REPLACE PROCEDURE SQL_Dinamic IS
v_nume VARCHAR2(50);
v_id users.id%type;
v_puturos INTEGER;
v_intrebari_puse INTEGER;
v_intrebari_relevante INTEGER;
v_reporturi INTEGER;
v_reporturi_gresite INTEGER;
v_student_p int;
v_table VARCHAR2(10);
row_num INTEGER;
v_cursor1 INTEGER;
v_cursor_table INTEGER;
CURSOR haters IS select * from(select u.name, u.id, count(u.id) from users u
                              join reports r on r.user_id = u.id
                              where u.user_role not like 'admin'
                              group by u.name, STUDENTI_PUTUROSI(U.ID), u.id
                              order by count(u.id) desc)
                              where rownum < 11;

BEGIN
  OPEN haters;
  LOOP
    FETCH haters into v_nume, v_id, v_reporturi;
    EXIT WHEN haters%NOTFOUND;
    v_cursor1 := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor1, 'CREATE TABLE u' || v_id || '(
                                  name varchar(60),
                                  puturos int,
                                  intrebari_puse int,
                                  intrebari_relevante int,
                                  reporturi_total int,
                                  reporturi_gresite int
                               )', DBMS_SQL.V7);
    row_num := dbms_sql.execute(v_cursor1);
    DBMS_SQL.CLOSE_CURSOR(v_cursor1);
    v_cursor_table := DBMS_SQL.OPEN_CURSOR;
    
    select STUDENTI_PUTUROSI(v_id) into v_student_p from dual; 
    
    select count(user_id) into v_intrebari_puse from questions where user_id = v_id;
    
    select count(user_id) into v_intrebari_relevante from questions where user_id = v_id and RELEVANTA(id) > 0;
    
    select count(q.id) into v_reporturi_gresite from questions q 
    join reports r on r.question_id = q.id
    where r.user_id = v_id and report_resolved = 1;
    
    DBMS_SQL.PARSE(v_cursor_table, 'INSERT INTO u' || v_id || '(name, puturos, intrebari_puse, intrebari_relevante, reporturi_total, reporturi_gresite) VALUES (:v_nume, :v_student_p, :v_intrebari_puse, :v_intrebari_relevante, :v_reporturi, :v_reporturi_gresite)', DBMS_SQL.V7);
    
    DBMS_SQL.BIND_VARIABLE(v_cursor_table, ':v_nume', v_nume);
    DBMS_SQL.BIND_VARIABLE(v_cursor_table, ':v_student_p', v_student_p);
    DBMS_SQL.BIND_VARIABLE(v_cursor_table, ':v_intrebari_puse', v_intrebari_puse);
    DBMS_SQL.BIND_VARIABLE(v_cursor_table, ':v_intrebari_relevante', v_intrebari_relevante);
    DBMS_SQL.BIND_VARIABLE(v_cursor_table, ':v_reporturi', v_reporturi);
    DBMS_SQL.BIND_VARIABLE(v_cursor_table, ':v_reporturi_gresite', v_reporturi_gresite);
    row_num := DBMS_SQL.EXECUTE(v_cursor_table);
    DBMS_SQL.CLOSE_CURSOR(v_cursor_table);
  END LOOP;
  CLOSE haters;
END;

CREATE OR REPLACE PROCEDURE Delete_tables IS
v_id INTEGER;
row_num INTEGER;
v_cursor1 INTEGER;
CURSOR haters IS select * from(select u.id from users u
                              join reports r on r.user_id = u.id
                              where u.user_role not like 'admin'
                              group by u.name, STUDENTI_PUTUROSI(U.ID), u.id
                              order by count(u.id) desc)
                              where rownum < 11;
BEGIN 
  OPEN haters;
  LOOP
    FETCH haters into v_id;
    EXIT WHEN haters%NOTFOUND;
    v_cursor1 := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor1, 'DROP TABLE u' || v_id, DBMS_SQL.V7);
    row_num := dbms_sql.execute(v_cursor1);
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR(v_cursor1);
  CLOSE haters;
END;

set serveroutput on;
BEGIN
  SQL_Dinamic;
  --Delete_tables;
END;