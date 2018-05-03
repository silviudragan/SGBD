set serveroutput on;
declare 
    v_id_utilizator_1 int := 156;
    v_id_utilizator_2 int := 64;
    v_ex_utilizator_1 int := 0;
    v_ex_utilizator_2 int := 0;
    v_rezolvate_1 int := 0;
    v_rezolvate_2 int := 0;
begin
    select count(u.id) into v_ex_utilizator_1 from users u
    join questions q on q.user_id = u.id
    where u.id = v_id_utilizator_1;
    
    select count(u.id) into v_ex_utilizator_2 from users u
    join questions q on q.user_id = u.id
    where u.id = v_id_utilizator_2;
    
    select count(user_id) into v_rezolvate_1 from answers
    where user_id = v_id_utilizator_1;
    
    select count(user_id) into v_rezolvate_2 from answers
    where user_id = v_id_utilizator_2;
    
    IF(v_ex_utilizator_1 > v_ex_utilizator_2) 
        THEN DBMS_OUTPUT.PUT_LINE('Utilizatorul ' || v_id_utilizator_1 || ' a introdus mai multe intrebari.');
        ELSE IF(v_ex_utilizator_1 < v_ex_utilizator_2)
                THEN DBMS_OUTPUT.PUT_LINE('Utilizatorul ' || v_id_utilizator_1 || ' a introdus mai multe intrebari.');
                ELSE IF(v_rezolvate_1 > v_rezolvate_2 )
                      THEN DBMS_OUTPUT.PUT_LINE('Utilizatorul ' || v_id_utilizator_1 || ' a raspuns la mai multe intrebari.');
                      ELSE IF(v_rezolvate_1 < v_rezolvate_2)
                          THEN DBMS_OUTPUT.PUT_LINE('Utilizatorul ' || v_id_utilizator_2 || ' a raspuns la mai multe intrebari.');
                              ELSE DBMS_OUTPUT.PUT_LINE('Utilizatorii au acelasi numar de intrebari puse si intrebari la care au raspuns.');
                          END IF;
                     END IF;     
             END IF;
    END IF;    
end;