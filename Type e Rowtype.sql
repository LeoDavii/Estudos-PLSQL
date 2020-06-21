-- Exibe dados de um funcionario da tabela 'employees', schema 'hr' --
--% comercial na variavel fora PL/SQL pedir valor para variavel
--usando TYPE

set SERVEROUTPUT ON;
DECLARE
   v_id hr.employees.employee_id%TYPE;
   v_name hr.employees.first_name%TYPE;
   v_sal hr.employees.salary%TYPE;
BEGIN
   SELECT a.employee_id,a.first_name,a.salary INTO v_id,v_name,v_sal
   FROM hr.employees a
   WHERE a.employee_id=&emp_id;
 
   DBMS_OUTPUT.PUT_LINE('-----------------------------------');
   DBMS_OUTPUT.PUT_LINE('ID: ' || TO_CHAR(v_id));
   DBMS_OUTPUT.PUT_LINE('Nome: ' || TO_CHAR(v_name));
   DBMS_OUTPUT.PUT_LINE('Salario: ' || TO_CHAR(v_sal));
   DBMS_OUTPUT.PUT_LINE('-----------------------------------');
END;
/


set SERVEROUTPUT ON;
DECLARE
   v_emp hr.employees%ROWTYPE;
BEGIN
   SELECT * INTO v_emp
   FROM hr.employees
   WHERE employee_id=&emp_id;
 
   DBMS_OUTPUT.PUT_LINE('-----------------------------------');
   DBMS_OUTPUT.PUT_LINE('ID: ' || TO_CHAR(v_emp.employee_id));
   DBMS_OUTPUT.PUT_LINE('Nome: ' || TO_CHAR(v_emp.first_name));
   DBMS_OUTPUT.PUT_LINE('Sobrenome: ' || TO_CHAR(v_emp.last_name));
   DBMS_OUTPUT.PUT_LINE('-----------------------------------');
END;
/

-- tratando codigo nao existente

-- Exibe dados de um funcionario da tabela 'employees', schema 'hr' --
--% comercial na variavel fora PL/SQL pedir valor para variavel
DECLARE
   v_emp hr.employees%ROWTYPE;
BEGIN
   SELECT * INTO v_emp
   FROM hr.employees
   WHERE employee_id=&emp_id;


   DBMS_OUTPUT.PUT_LINE('-----------------------------------');
   DBMS_OUTPUT.PUT_LINE('ID: ' || TO_CHAR(v_emp.employee_id));
   DBMS_OUTPUT.PUT_LINE('Nome: ' || TO_CHAR(v_emp.first_name));
   DBMS_OUTPUT.PUT_LINE('Sobrenome: ' || TO_CHAR(v_emp.last_name));
   DBMS_OUTPUT.PUT_LINE('-----------------------------------');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Matricula não existe');
      
END;
/
    
    
    
  

