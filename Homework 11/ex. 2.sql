DROP table log_istoric;
CREATE TABLE log_istoric(
      comanda VARCHAR2(250),
      data_modificare TIMESTAMP
      );

CREATE or REPLACE TRIGGER stocare_comenzi
  AFTER UPDATE of valoare or INSERT or DELETE ON note FOR EACH ROW
DECLARE
  v_query VARCHAR2(250);
BEGIN
  CASE
    WHEN INSERTING THEN
      v_query := 'insert into note values(';
      v_query := v_query || q'$'$' || :NEW.nr_matricol || q'$'$' || ',' || q'$'$' || :NEW.id_curs || q'$'$' || ',' || :NEW.valoare || ',' || q'$'$' || :NEW.data_notare || q'$'$' || ')';
      insert into log_istoric values(v_query, CURRENT_TIMESTAMP);
    WHEN UPDATING('valoare') THEN
      v_query := 'update note set valoare=' || :NEW.valoare || ' where nr_matricol='|| :OLD.nr_matricol || ' and id_curs=' || :OLD.id_curs;
      insert into log_istoric values(v_query, CURRENT_TIMESTAMP);
    WHEN DELETING THEN
      v_query := 'delete from note where nr_matricol=' || :OLD.nr_matricol || ' and id_curs=' || :OLD.id_curs;
      insert into log_istoric values(v_query, CURRENT_TIMESTAMP);
  END CASE;
END;