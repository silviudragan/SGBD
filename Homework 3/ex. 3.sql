DROP TABLE ZODIAC;

CREATE TABLE ZODIAC(
  LIMITA_INFERIOARA DATE NOT NULL UNIQUE,
  LIMITA_SUPERIOARA DATE NOT NULL UNIQUE,
  NUME VARCHAR2(255 BYTE) NOT NULL
);

insert into ZODIAC(LIMITA_INFERIOARA, LIMITA_SUPERIOARA, NUME) values ('21-MAR-97', '20-APR-97', 'Berbec');
insert into ZODIAC(LIMITA_INFERIOARA, LIMITA_SUPERIOARA, NUME) values ('21-APR-97', '21-MAY-97', 'Taur');
insert into ZODIAC(LIMITA_INFERIOARA, LIMITA_SUPERIOARA, NUME) values ('21-MAY-97', '21-JUN-97', 'Gemeni');
insert into ZODIAC(LIMITA_INFERIOARA, LIMITA_SUPERIOARA, NUME) values ('22-JUN-97', '22-JUL-97', 'Rac');
insert into ZODIAC(LIMITA_INFERIOARA, LIMITA_SUPERIOARA, NUME) values ('23-JUL-97', '22-AUG-97', 'Leu');
insert into ZODIAC(LIMITA_INFERIOARA, LIMITA_SUPERIOARA, NUME) values ('23-AUG-97', '22-SEP-97', 'Fecioara');
insert into ZODIAC(LIMITA_INFERIOARA, LIMITA_SUPERIOARA, NUME) values ('23-SEP-97', '22-OCT-97', 'Balanta');
insert into ZODIAC(LIMITA_INFERIOARA, LIMITA_SUPERIOARA, NUME) values ('23-OCT-97', '21-NOV-97', 'Scorpion');
insert into ZODIAC(LIMITA_INFERIOARA, LIMITA_SUPERIOARA, NUME) values ('22-NOV-97', '21-DEC-97', 'Sagetator');
insert into ZODIAC(LIMITA_INFERIOARA, LIMITA_SUPERIOARA, NUME) values ('22-DEC-97', '20-JAN-97', 'Capricorn');
insert into ZODIAC(LIMITA_INFERIOARA, LIMITA_SUPERIOARA, NUME) values ('21-JAN-97', '19-FEB-97', 'Varsator');
insert into ZODIAC(LIMITA_INFERIOARA, LIMITA_SUPERIOARA, NUME) values ('20-FEB-97', '20-MAR-97', 'Pesti');

set serveroutput on;
declare
    CURSOR info_utilizator IS select nume, prenume, data_nastere from tema3;
    CURSOR info_zodie IS select limita_inferioara, limita_superioara, nume from zodiac;
    v_inregistrari INTEGER := 0;
    v_iterator_1 INTEGER := 0;
    v_iterator_2 INTEGER := 0;
    v_data_utilizator tema3.data_nastere%type;
    v_limita_inferioara_zodiac DATE;
    v_limita_superioara_zodiac zodiac.limita_superioara%type;
    v_nume_utilizator tema3.nume%type;
    v_prenume_utilizator tema3.prenume%type;
    v_nume_zodie zodiac.nume%type;
    v_procent_distributie INTEGER := 0;
    v_exit INTEGER := 0;
begin
    OPEN info_zodie;
    select count(id) into v_inregistrari from tema3;
    
    FOR v_iterator_1 in 1..12 LOOP
      FETCH info_zodie into v_limita_inferioara_zodiac, v_limita_superioara_zodiac, v_nume_zodie;
      --DBMS_OUTPUT.PUT_LINE(v_limita_inferioara_zodiac || '->' || v_limita_superioara_zodiac);
      OPEN info_utilizator;
      v_procent_distributie := 0;
      FOR v_iterator_2 in 1..v_inregistrari LOOP
        v_exit := 0;
        FETCH info_utilizator into v_nume_utilizator, v_prenume_utilizator, v_data_utilizator;
        IF(v_nume_zodie = 'Capricorn' and (v_data_utilizator >= '22-DEC-97' or v_data_utilizator <= '22-JAN-97'))
          THEN
            v_procent_distributie := v_procent_distributie + 1;
        END IF;
        IF(v_limita_inferioara_zodiac <= v_data_utilizator and v_data_utilizator <= v_limita_superioara_zodiac)
          THEN
            v_procent_distributie := v_procent_distributie + 1;
        END IF;
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('Sunt ' || v_procent_distributie/50*100 || '% utilizatori cu zodia ' || v_nume_zodie);
      CLOSE info_utilizator;
    END LOOP;
    CLOSE info_zodie;
end;
