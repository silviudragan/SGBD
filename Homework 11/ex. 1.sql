CREATE or REPLACE TRIGGER update_bursa
  AFTER UPDATE or INSERT or DELETE ON note
DECLARE
  v_an INTEGER;
  v_nota INTEGER;
  v_id_curs VARCHAR2(4);
  v_nr_matricol VARCHAR2(4);
  cursor c_student IS select nr_matricol from studenti;
  cursor c_curs IS select id_curs from cursuri;
  cursor c_nota IS select valoare from note n 
          join cursuri c on c.id_curs = n.id_curs
          join studenti s on s.nr_matricol = n.nr_matricol
          where n.nr_matricol = v_nr_matricol and n.id_curs = v_id_curs;
  v_suma_note INTEGER;
  v_medie_maxima INTEGER := 0;
  v_medie INTEGER;
  v_id_student_medie_maxima VARCHAR(4);
  v_count_note INTEGER;
  v_count_burse INTEGER := 0;
  v_bursa_student INTEGER;
  v_it INTEGER;
  v_an_student INTEGER;
  v_nr_matricol_duplicat VARCHAR2(4);
  type array_t is varray(3) of INTEGER;
  array array_t := array_t(0, 0, 0);  --daca are valoarea 1 pe pozitia i inseamna ca este macar un student care va lua bursa in anul i
  type array_t2 is varray(6) of VARCHAR(20);
  array2 array_t2 := array_t2('', '', '', '', '', ''); --id-urile cu bursa maxima din fiecare an; valorile 3, 4 si 5 din vector sunt pentru 2 studenti care au media maxima egala
BEGIN
  FOR v_an in 1..3 LOOP
    v_medie_maxima := 0;
    OPEN c_student;
    LOOP
      EXIT WHEN c_student%NOTFOUND;
      FETCH c_student into v_nr_matricol;
      select an into v_an_student from studenti where nr_matricol = v_nr_matricol;
      IF v_an_student = v_an THEN
        v_suma_note := 0;
        v_count_note := 0;
        v_medie := 0;
      
        OPEN c_curs;
        LOOP
          EXIT WHEN c_curs%NOTFOUND;
          FETCH c_curs into v_id_curs;
            OPEN c_nota;
            LOOP
              FETCH c_nota into v_nota;
              EXIT WHEN c_nota%NOTFOUND;
              IF v_nota < 5 THEN
                v_suma_note := -100;
              ELSE 
                v_suma_note := v_suma_note + v_nota;
                v_count_note := v_count_note + 1;
              END IF;
            END LOOP;
            CLOSE c_nota;
            
        END LOOP;
        CLOSE c_curs;
        IF v_suma_note > 0 THEN
              v_medie := v_suma_note/v_count_note;
              IF v_medie > v_medie_maxima THEN
                v_medie_maxima := v_medie;
                v_id_student_medie_maxima := v_nr_matricol;
                array(v_an) := v_suma_note;
                array2(v_an+3) := '';
              ELSE IF v_medie = v_medie_maxima THEN
                      array2(v_an+3) := v_nr_matricol;
                    END IF;
              END IF;
            END IF;
        array2(v_an) := v_id_student_medie_maxima;
      END IF;
    END LOOP;
    CLOSE c_student;
    --pentru fiecare an se da bursa?
   IF v_medie_maxima > 0 THEN
      array(v_an) := 1;
    END IF;
  END LOOP;
   --cate burse se dau
  FOR v_it in 1..3 LOOP
    IF array(v_it)=1 THEN
      v_count_burse := v_count_burse + 1;
    END IF;
  END LOOP;
  --ofera bursele
  UPDATE studenti set bursa = (null) where bursa > 0;
  FOR v_an in 1..3 LOOP
    IF array(v_an)=1 THEN
      IF length(array2(v_an+3)) > 1 THEN
          UPDATE studenti set bursa = (1000/v_count_burse)/2 where nr_matricol = array2(v_an+3);
          UPDATE studenti set bursa = (1000/v_count_burse)/2 where nr_matricol = array2(v_an);
      ELSE
        UPDATE studenti set bursa = 1000/v_count_burse where nr_matricol = array2(v_an);
      END IF;
    END IF;
  END LOOP; 
END;