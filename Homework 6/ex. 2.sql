GRANT CREATE TYPE TO STUDENT; -- aceasta linie se executa din "SYS as SYSDBA"
DROP TABLE persoane;
DROP TYPE lista_prenume ;
CREATE OR REPLACE TYPE lista_prenume AS TABLE OF VARCHAR2(10);
/
CREATE TABLE persoane (nume varchar2(10), 
       prenume lista_prenume)
       NESTED TABLE prenume STORE AS lista;
/       

INSERT INTO persoane VALUES('Popescu', lista_prenume('Ionut', 'Razvan'));
INSERT INTO persoane VALUES('Ionescu', lista_prenume('Elena', 'Madalina'));
INSERT INTO persoane VALUES('Rizea', lista_prenume('Mircea', 'Catalin'));
INSERT INTO persoane VALUES('Dragan', lista_prenume('SILVIU', 'Constantin'));
/

set serveroutput on;
DECLARE
  v_contor INTEGER := 0;
BEGIN
  FOR v_inregistrare in (select * from persoane) LOOP
   IF lower(v_inregistrare.prenume(1)) like '%u%' or lower(v_inregistrare.prenume(2)) like '%u%' 
    THEN 
      DBMS_OUTPUT.PUT_LINE(v_inregistrare.nume || ' ' || v_inregistrare.prenume(1) || ' ' || v_inregistrare.prenume(2));
      v_contor := v_contor + 1;
    END IF;
  END LOOP;
  IF v_contor = 0 
    THEN
      DBMS_OUTPUT.PUT_LINE('Nu sunt persoane care au litera ''u'' in prenume.');
    ELSE IF v_contor = 1
        THEN
          DBMS_OUTPUT.PUT_LINE('O singura persoana are litera ''u'' in prenume.');
        ELSE
          DBMS_OUTPUT.PUT_LINE('Sunt ' || v_contor || ' persoane care au litera ''u'' in prenume.');
        END IF;
  END IF;
END;