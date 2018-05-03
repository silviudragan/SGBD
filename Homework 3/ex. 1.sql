DROP TABLE TEMA3;

CREATE TABLE TEMA3(
  ID NUMBER(10) PRIMARY KEY,
  NUME VARCHAR2(255 BYTE),
  PRENUME VARCHAR2(255 BYTE),
  DATA_NASTERE TIMESTAMP,
  TELEFON VARCHAR(11) UNIQUE,
  ADRESA_EMAIL VARCHAR2(255 BYTE) UNIQUE
);

DECLARE
    CURSOR noul_nume IS select name from(select name from users order by dbms_random.value) where rownum < 515;
    v_nume users.name%type;
    v_prenume_1 users.name%type;
    v_prenume_2 users.name%type;
    v_numar_inregistrari INTEGER := 0;
    v_decizie INTEGER; --va avea 3 valori(1,2,3); daca are valoare 1 atunci persoana va avea 2 prenume, altfel va avea 1.
    v_email varchar2(70);
    v_telefon NUMBER(8);
    V_variabila_for INTEGER;
BEGIN
    OPEN noul_nume;
    LOOP
      v_numar_inregistrari := v_numar_inregistrari + 1;
      FETCH noul_nume into v_nume;
      FETCH noul_nume into v_prenume_1;
      v_decizie := trunc(dbms_random.value(1,4));
      
      v_telefon := dbms_random.value(10000000, 99999999);

      
      
      IF(v_decizie = 1) --are 2 prenume
        THEN
           FETCH noul_nume into v_prenume_2;
           v_nume := substr(v_nume, instr(v_nume, ' ')+1);
           v_prenume_1 := substr(v_prenume_1, 1, instr(v_prenume_1, ' ')-1); 
           v_prenume_2 := substr(v_prenume_2, 1, instr(v_prenume_2, ' ')-1); 
           v_email := lower(v_prenume_1)||'.'||lower(v_nume)||'@info.uaic.ro';
           IF((substr(v_prenume_1, length(v_prenume_1)) = 'a' and substr(v_prenume_2, length(v_prenume_2)) != 'a') or (substr(v_prenume_1, length(v_prenume_1)) != 'a' and substr(v_prenume_2, length(v_prenume_2)) = 'a') or v_prenume_1 = v_prenume_2)
              THEN --avem cazul prenumelor fata-baiat sau avem cele doua prenume la fel; vom renunta la unul din ele
                v_prenume_2 := null; 
          END IF;
          INSERT INTO TEMA3(ID, NUME, PRENUME, DATA_NASTERE, TELEFON, ADRESA_EMAIL) values (v_numar_inregistrari, v_nume, v_prenume_1|| ' ' ||v_prenume_2, TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '1997-01-01','J'),TO_CHAR(DATE '1997-12-31','J'))),'J'), '07'||v_telefon, v_email);
        ELSE 
          v_nume := substr(v_nume, instr(v_nume, ' ')+1);
          v_prenume_1 := substr(v_prenume_1, 1, instr(v_prenume_1, ' ')-1); 
          v_email := lower(v_prenume_1)||'.'||lower(v_nume)||'@info.uaic.ro';
          INSERT INTO TEMA3(ID, NUME, PRENUME, DATA_NASTERE, TELEFON, ADRESA_EMAIL) values (v_numar_inregistrari, v_nume, v_prenume_1, TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '1997-01-01','J'),TO_CHAR(DATE '1997-12-31','J'))),'J'), '07'||v_telefon, v_email);
      END IF;
      EXIT WHEN v_numar_inregistrari = 50;
    END LOOP;
    CLOSE noul_nume;
END;
select * from tema3;