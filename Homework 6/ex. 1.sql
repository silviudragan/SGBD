set serveroutput on;
DECLARE
  TYPE array1 IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
  TYPE matrix IS TABLE OF array1;
  first_matrix matrix;
  second_matrix matrix;
  result_matrix matrix;
  v_lin_matrix_1 INTEGER;
  v_col_matrix_1 INTEGER;
  v_lin_matrix_2 INTEGER;
  v_col_matrix_2 INTEGER;
  v_iterator INTEGER;
  v_iterator_2 INTEGER;
  v_iterator_3 INTEGER;
  v_result_1 VARCHAR2(100);
  v_sum INTEGER;
  
BEGIN

  v_lin_matrix_1 := trunc(dbms_random.value(2,6));
  --DBMS_OUTPUT.PUT_LINE(v_lin_matrix_1);
  v_col_matrix_1 := trunc(dbms_random.value(2,6));
  --DBMS_OUTPUT.PUT_LINE(v_col_matrix_1);
  v_col_matrix_2 := trunc(dbms_random.value(2,6));
  --DBMS_OUTPUT.PUT_LINE(v_col_matrix_2);
  v_lin_matrix_2 := v_col_matrix_1;
  
  first_matrix := matrix();
  first_matrix.extend(v_lin_matrix_1);
  FOR v_iterator in 1..v_lin_matrix_1 LOOP
    first_matrix.extend(v_col_matrix_1);
    FOR v_iterator_2 in 1..v_col_matrix_1 LOOP
      first_matrix(v_iterator)(v_iterator_2) := trunc(dbms_random.value(0, 31));
    END LOOP;
  END LOOP;
  
  second_matrix := matrix();
  second_matrix.extend(v_lin_matrix_2);
  FOR v_iterator in 1..v_lin_matrix_2 LOOP
    second_matrix.extend(v_col_matrix_2);
    FOR v_iterator_2 in 1..v_col_matrix_2 LOOP
      second_matrix(v_iterator)(v_iterator_2) := trunc(dbms_random.value(0, 30));
    END LOOP;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Matricea 1');
  FOR v_iterator in 1..v_lin_matrix_1 LOOP
    v_result_1 := lpad(to_char(first_matrix(v_iterator)(1)),2);
    FOR v_iterator_2 in 2..v_col_matrix_1 LOOP
      v_result_1 := v_result_1 || ' ' || lpad(to_char(first_matrix(v_iterator)(v_iterator_2)),2);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_result_1);
    v_result_1 := null;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  
  DBMS_OUTPUT.PUT_LINE('Matricea 2');
  FOR v_iterator in 1..v_lin_matrix_2 LOOP
    v_result_1 := lpad(to_char(second_matrix(v_iterator)(1)), 2);
    FOR v_iterator_2 in 2..v_col_matrix_2 LOOP
      v_result_1 := v_result_1 || ' ' || lpad(to_char(second_matrix(v_iterator)(v_iterator_2)), 2);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_result_1);
    v_result_1 := null;
  END LOOP;
  
  result_matrix := matrix();
  result_matrix.extend(v_lin_matrix_1);
  FOR v_iterator in 1..v_lin_matrix_1 LOOP
    FOR v_iterator_2 in 1..v_col_matrix_2 LOOP
      v_sum := 0;
      FOR v_iterator_3 in 1..v_col_matrix_1 LOOP
        v_sum := v_sum + first_matrix(v_iterator)(v_iterator_3) * second_matrix(v_iterator_3)(v_iterator_2);
      END LOOP;
      result_matrix(v_iterator)(v_iterator_2) := v_sum;
    END LOOP;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  
  DBMS_OUTPUT.PUT_LINE('Matricea resultat');
  FOR v_iterator in 1..v_lin_matrix_1 LOOP
    v_result_1 := lpad(to_char(result_matrix(v_iterator)(1)),4);
    FOR v_iterator_2 in 2..v_col_matrix_2 LOOP
      v_result_1 := v_result_1 || ' ' || lpad(to_char(result_matrix(v_iterator)(v_iterator_2)),3);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_result_1);
    v_result_1 := null;
  END LOOP;

END;