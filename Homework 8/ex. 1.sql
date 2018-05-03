DROP TABLE LOT;
DROP TYPE jucator_norocos;
CREATE OR REPLACE TYPE jucator AS OBJECT
(nume VARCHAR2(15),
prenume VARCHAR2(15),
echipa VARCHAR2(25),
data_nastere date,
inaltime number(3),
salariu number(5),
NOT FINAL member procedure profil_jucator,
member procedure varsta,
CONSTRUCTOR FUNCTION jucator(nume VARCHAR2, prenume VARCHAR2) RETURN SELF AS RESULT,
CONSTRUCTOR FUNCTION jucator(echipa VARCHAR2) RETURN SELF AS RESULT,
MAP MEMBER FUNCTION sortare_dupa_salariu RETURN NUMBER
)NOT FINAL;

CREATE OR REPLACE TYPE jucator_norocos UNDER jucator
(prima_instalare NUMBER(5),
OVERRIDING member procedure profil_jucator
);
/

CREATE OR REPLACE TYPE BODY jucator_norocos AS
  OVERRIDING MEMBER PROCEDURE profil_jucator IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Profilul jucatorului');
    DBMS_OUTPUT.PUT_LINE('Nume: ' || nume);
    DBMS_OUTPUT.PUT_LINE('Prenume: ' || prenume);
    DBMS_OUTPUT.PUT_LINE('Echipa: ' || echipa);
    DBMS_OUTPUT.PUT_LINE('Data nasterii: ' || data_nastere);
    DBMS_OUTPUT.PUT_LINE('Inaltimea: ' || inaltime || ' cm');
    DBMS_OUTPUT.PUT_LINE('Salariu: ' || salariu || ' euro/luna');
    DBMS_OUTPUT.PUT_LINE('Prima de instalare: ' || prima_instalare || ' euro');
  END profil_jucator;
END;
/

CREATE TABLE lot(id_jucator VARCHAR(3), obiect JUCATOR);

CREATE OR REPLACE TYPE BODY jucator AS
  MEMBER PROCEDURE profil_jucator IS
  BEGIN 
    DBMS_OUTPUT.PUT_LINE('Profilul jucatorului');
    DBMS_OUTPUT.PUT_LINE('Nume: ' || nume);
    DBMS_OUTPUT.PUT_LINE('Prenume: ' || prenume);
    DBMS_OUTPUT.PUT_LINE('Echipa: ' || echipa);
    DBMS_OUTPUT.PUT_LINE('Data nasterii: ' || data_nastere);
    DBMS_OUTPUT.PUT_LINE('Inaltimea: ' || inaltime || ' cm');
    DBMS_OUTPUT.PUT_LINE('Salariu: ' || salariu || ' euro/luna');
  END profil_jucator;
  
  MEMBER PROCEDURE varsta IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(prenume || ' ' || nume || ' are ' || round((sysdate - data_nastere)/365) || ' ani.');
  END varsta;
  
  CONSTRUCTOR FUNCTION jucator(nume VARCHAR2, prenume VARCHAR2) RETURN SELF AS RESULT AS
  BEGIN
    SELF.nume := nume;
    SELF.prenume := prenume;
    SELF.echipa := 'liber de contract';
    SELF.data_nastere := TO_DATE('24/08/1996', 'dd/mm/yyyy');
    SELF.inaltime := 192;
    SELF.salariu := 0;
    RETURN;
  END;
  
  CONSTRUCTOR FUNCTION jucator(echipa VARCHAR2) RETURN SELF AS RESULT AS
  BEGIN
    SELF.nume := 'unknown';
    SELF.prenume := 'unknown';
    SELF.echipa := echipa;
    SELF.data_nastere := TO_DATE('22/05/1990', 'dd/mm/yyyy');
    SELF.inaltime := 0;
    SELF.salariu := 0;
    RETURN;
  END;
  
  MAP MEMBER FUNCTION sortare_dupa_salariu RETURN NUMBER IS
  BEGIN
    RETURN salariu;
  END;
END;
/

set serveroutput on;
DECLARE
  v_jucator_1 JUCATOR;
  v_jucator_2 JUCATOR;
  v_jucator_3 JUCATOR;
  v_jucator_4 JUCATOR;
  v_jucator_5 jucator_norocos;
  v_jucator_6 JUCATOR;
  v_it INTEGER;
  v_count_lot INTEGER;
BEGIN
  v_jucator_1 := jucator('Reus', 'Marco', 'Dortmund', TO_DATE('31/05/1989', 'dd/mm/yyyy'), 180, 30000);
  v_jucator_2 := jucator('Ibrahimociv', 'Zlatan', 'Manchester United', TO_DATE('03/10/1981', 'dd/mm/yyyy'), 195, 38500);
  v_jucator_3 := jucator('Hazard', 'Eden', 'Chelsea FC', TO_DATE('07/01/1991', 'dd/mm/yyyy'), 173, 24000);
  
  v_jucator_4 := jucator('Dragan', 'Silviu');
  --v_jucator_4.profil_jucator();
  insert into lot values ('1', v_jucator_1);
  insert into lot values ('2', v_jucator_2);
  insert into lot values ('3', v_jucator_3);
  insert into lot values ('4', v_jucator_4);
  
  --overriding
  v_jucator_5 := jucator_norocos('Neuer', 'Manuel', 'FC Bayern Munchen', TO_DATE('27/03/1986', 'dd/mm/yyyy'), 193, 28000, 50000);
  --v_jucator_5.profil_jucator();
  
  --overloading
  v_jucator_6 := jucator('Manchester City');
  v_jucator_6.profil_jucator();
END;

--verificarea ca interogarile pot fi sortate dupa coloana cu obiectele de tip jucator
select * from lot order by obiect;