set serveroutput on;

declare
    v_sir_caractere VARCHAR(10) := '&secventa_caractere';
    v_username users.username%type;
    v_id users.id%type;
    v_name users.name%type;
    v_numar_studenti int := 0;
    v_numar_intrebari int := 0;
    
begin

    SELECT id, UPPER(substr(username, instr(username, '.')+1)), substr(name, 0, instr(name, ' ')) into v_id, v_username, v_name FROM 
   (select id, username, name FROM 
    users where instr(username, v_sir_caractere) != 0
    group by id, username, name
    order by dbms_random.value, id)
    where rownum = 1;
    
    select COUNT(id) into v_numar_studenti from users where instr(username, v_sir_caractere) != 0;
    
    select COUNT(q.id) into v_numar_intrebari from questions q
    join users u on u.id = q.user_id 
    where q.reported < 5 and u.id = v_id;
    
    DBMS_OUTPUT.PUT_LINE('Sunt ' || v_numar_studenti || ' studenti ce au in componenta sirul ' || v_sir_caractere);
    DBMS_OUTPUT.PUT_LINE('Unul din ei este ' || v_id || ' ' ||  v_username || ' ' || v_name || 'ce are ' || v_numar_intrebari || ' intrebari sub 5 reporturi.');
end;