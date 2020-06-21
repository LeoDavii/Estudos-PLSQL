-- Exibe dados de um funcionario da tabela 'employees', schema 'hr' --
--% comercial na variavel fora PL/SQL pedir valor para variavel
set SERVEROUTPUT ON;

DECLARE
-- Definição de tipos
TYPE TFuncionario IS RECORD(
Nome VARCHAR2(40) ,
Depto VARCHAR2(20),
Salario NUMBER(10,2)
);
-- Declaração de variáveis
vFunc TFuncionario;
BEGIN
-- Atribuir valor para o registro vProduto
SELECT a.FIRST_NAME,a.DEPARTMENT_ID,a.SALARY
INTO vFunc.Nome, vFunc.Depto, vFunc.Salario
FROM hr.employees a
WHERE a.EMPLOYEE_ID = 103;
-- Imprimir na tela os dados recuperados
dbms_output.put_line('Nome do Func: '||vFunc.Nome||chr(10)||
'Depto: '||vFunc.Depto||chr(10)||
'Salario: '||to_char(vFunc.Salario)
);
END;
/


