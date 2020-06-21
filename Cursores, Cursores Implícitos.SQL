SET SERVEROUTPUT ON
DECLARE
-- Declaração de variáveis
viDFunc HR.EMPLOYEES.EMPLOYEE_ID%type;
vNome HR.EMPLOYEES.FIRST_NAME%type;
VSalario HR.EMPLOYEES.SALARY%type;
-- Declaração de cursores
CURSOR cs_salario_top_10 is
    SELECT a.EMPLOYEE_ID,a.FIRST_NAME,a.SALARY
FROM HR.EMPLOYEES a
order by a.salary desc;
BEGIN
-- Abre cursor
OPEN cs_salario_top_10;
-- Executa um loop com 10 ciclos
FOR i IN 1..10 LOOP
-- Extrai dados o registro corrente do cursor e avança para o próximo
FETCH cs_salario_top_10 INTO viDFunc,vNome,VSalario;
-- Imprime dados extraídos na tela
dbms_output.put_line(viDFunc||' - '||vNome||' - '||VSalario);
END LOOP;
--fecha cursor
close cs_salario_top_10;
END;
/

SET SERVEROUTPUT ON
DECLARE
-- Declaração de variáveis
viDFunc HR.EMPLOYEES.EMPLOYEE_ID%type;
vNome HR.EMPLOYEES.FIRST_NAME%type;
VSalario HR.EMPLOYEES.SALARY%type;
-- Declaração de cursores
CURSOR cs_top_10 is
 SELECT a.EMPLOYEE_ID,a.FIRST_NAME,a.SALARY
FROM HR.EMPLOYEES a
order by a.salary desc;
BEGIN
-- Abre cursor se ainda não estiver aberto
IF NOT cs_top_10%ISOPEN THEN
OPEN cs_top_10;
END IF;
-- Executa um loop com 10 ciclos
FOR i IN 1..10 LOOP
-- Extrai dados o registro corrente do cursor e avança para o próximo
FETCH cs_top_10 INTO  viDFunc,vNome,VSalario;
-- Imprime dados extraídos na tela
dbms_output.put_line(i||'-'||viDFunc||' - '||vNome||' - '||VSalario);
END LOOP;
-- Fechar cursor
CLOSE cs_top_10;
END;
/


SET SERVEROUTPUT ON
DECLARE
-- Declaração de variáveis
viDFunc HR.EMPLOYEES.EMPLOYEE_ID%type;
vNome HR.EMPLOYEES.FIRST_NAME%type;
VSalario HR.EMPLOYEES.SALARY%type;
v_posicao int default 0;
-- Declaração de cursores
CURSOR cs_salario is
 SELECT a.EMPLOYEE_ID,a.FIRST_NAME,a.SALARY
FROM HR.EMPLOYEES a
order by a.salary desc;
BEGIN
-- Abre cursor se ainda não estiver aberto
IF NOT cs_salario%ISOPEN THEN
OPEN cs_salario;
END IF;
-- Executa um loop 
LOOP
-- Extrai dados o registro corrente do cursor e avança para o próximo
FETCH cs_salario INTO  viDFunc,vNome,VSalario;

-- Sai do Loop quando não houver mais registros para processar
EXIT WHEN cs_salario%NOTFOUND;
-- Imprime dados extraídos na tela
v_posicao:=v_posicao+1;
dbms_output.put_line(v_posicao||' - '||viDFunc||' - '||vNome||' - '||VSalario);
END LOOP;
-- Fechar cursor
CLOSE cs_salario;
END;

SET SERVEROUTPUT ON
DECLARE
-- Declaração de tipo registro
TYPE TFuncionario IS RECORD(
viDFunc HR.EMPLOYEES.EMPLOYEE_ID%type,
vNome HR.EMPLOYEES.FIRST_NAME%type,
VSalario HR.EMPLOYEES.SALARY%type);
-- Declaração de variáveis
VFunc TFuncionario;
-- Declaração de cursores
CURSOR cs_func is
 SELECT a.EMPLOYEE_ID,a.FIRST_NAME,a.SALARY
FROM HR.EMPLOYEES a
order by a.salary desc;
BEGIN
-- Abre cursor se ainda não estiver aberto
IF NOT cs_func%ISOPEN THEN
OPEN cs_func;
END IF;
-- Executa um loop 
LOOP
-- Extrai dados o registro corrente do cursor e avança para o próximo
FETCH cs_func INTO VFunc;
-- Sai do Loop quando não houver mais registros para processar
EXIT WHEN cs_func%NOTFOUND;
-- Imprime dados extraídos na tela
dbms_output.put_line(VFunc.viDFunc||' - '||VFunc.vNome||' - '||VFunc.VSalario);
END LOOP;
-- Fechar cursor
CLOSE cs_func;
END;
/

--CURSOR IMPLICITO ORACLE
BEGIN
-- Inicia o loop no conjunto ativo do cursor
FOR vFunc in (SELECT a.EMPLOYEE_ID,a.FIRST_NAME,a.SALARY
FROM HR.EMPLOYEES a
order by a.salary desc)
LOOP
-- Imprime dados extraídos na tela
dbms_output.put_line(VFunc.EMPLOYEE_ID||' - '||VFunc.FIRST_NAME||' - '||VFunc.SALARY);
END LOOP;
END;
/

DECLARE
-- Declaração de cursores
CURSOR cs_func(pMenor NUMBER, pMaior NUMBER) is
SELECT a.EMPLOYEE_ID,a.FIRST_NAME,a.SALARY
FROM HR.EMPLOYEES a
WHERE a.SALARY BETWEEN pMenor AND pMaior order by a.SALARY desc ;
BEGIN
-- Abre cursor para Funcionarios com Salario entre 1000 e 9999
dbms_output.put_line('Funcionarios com média entre 1000 e 9999');
FOR rFunc in cs_func(1000,9999) LOOP
/* Imprime na tela os Funcionarios com Salario no intervalo de 1000 e 9999
*/
dbms_output.put_line(rFunc.EMPLOYEE_ID||' - '||rFunc.FIRST_NAME||' - '||rFunc.SALARY);
END LOOP;
-- Abre cursor para Funcionarios com Salario entre 10000 e 19000
dbms_output.put_line('Funcionarios com média entre 10000 e 19000');
FOR rFunc in cs_func(10000,19000) LOOP
/* Imprime na tela os Funcionarios com Salario entre 10000 e 19000
Está no intervalo de 10000 e 19000
*/
dbms_output.put_line(rFunc.EMPLOYEE_ID||' - '||rFunc.FIRST_NAME||' - '||rFunc.SALARY);
END LOOP;

END;
/

DECLARE
-- Declaração de cursores
CURSOR cs_func(pMenor NUMBER, pMaior NUMBER) is
SELECT a.EMPLOYEE_ID,a.FIRST_NAME,a.SALARY
FROM HR.EMPLOYEES a
WHERE a.SALARY BETWEEN pMenor AND pMaior order by a.SALARY desc ;
BEGIN
-- Abre cursor para Funcionarios com Salario entre 1000 e 9999
dbms_output.put_line('Funcionarios com média entre 1000 e 9999');
FOR rFunc in cs_func(10000,9999) LOOP
/* Imprime na tela os Funcionarios com Salario no intervalo de 1000 e 9999
*/
dbms_output.put_line(rFunc.EMPLOYEE_ID||' - '||rFunc.FIRST_NAME||' - '||rFunc.SALARY);
END LOOP;
-- Abre cursor para Funcionarios com Salario entre 10000 e 19000
dbms_output.put_line('Funcionarios com média entre 10000 e 19000');
FOR rFunc in cs_func(10000,19000) LOOP
/* Imprime na tela os Funcionarios com Salario entre 10000 e 19000
Está no intervalo de 10000 e 19000
*/
dbms_output.put_line(rFunc.EMPLOYEE_ID||' - '||rFunc.FIRST_NAME||' - '||rFunc.SALARY);
END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NÃO TEM REGISTROS');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/