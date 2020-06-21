--criando funçao para media ponderada;

CREATE OR REPLACE FUNCTION Fn_mediaPond
                    (nota1 in number,
                     peso1 in number,
                     nota2 in number,
                     peso2 in number)
return number
is
media_pond number;
begin
        media_pond:=(nota1*peso1+nota2*peso2)/(peso1+peso2);
        return media_pond;
end;
/

-- retornance valor de função
select  Fn_mediaPond(10,1,10,1) from SYS.DUAL;

-- REtornando atraves de output]
SET SERVEROUTPUT ON
BEGIN
dbms_output.put_line(Fn_mediaPond(5,5,10,1)); 
END;
/

-- sem paramentros
CREATE OR REPLACE FUNCTION FnNome
   RETURN varchar IS
   v_nome varchar(20);
BEGIN
   SELECT a.FIRST_NAME
   INTO   v_nome
   FROM   hr.EMPLOYEES a WHERE a.EMPLOYEE_ID=100;

   RETURN v_nome;
END;
/

select FnNome from DUAL;

--com paramentros

CREATE OR REPLACE FUNCTION FnNome2(p_id in number)
   RETURN varchar IS
   v_nome varchar(20);
BEGIN
   SELECT a.FIRST_NAME
   INTO   v_nome
   FROM   hr.EMPLOYEES a WHERE a.EMPLOYEE_ID=p_id;

   RETURN v_nome;
END;
/

select FnNome2(103) from DUAL;


--function simula aumento

CREATE OR REPLACE FUNCTION FnAumento(p_pct in number,p_id_func in number)
   RETURN number IS
   v_Sal_novo number(20);
BEGIN
   SELECT ((a.SALARY/100)*p_pct)+a.SALARY
   INTO   v_Sal_novo
   FROM   hr.EMPLOYEES a where a.EMPLOYEE_ID=p_id_func;

   RETURN v_Sal_novo;
END;
/

--EXEC DA FUNÇÃO.
select a.FIRST_NAME,
       a.SALARY as sal_antigo, 
       FnAumento(10,a.EMPLOYEE_ID) as sal_novo
from  hr.EMPLOYEES a;


-- funcão como  bloco anônimo concluído
--PEGAR DOIS NUMEROS A DIZER QUAL É O MAIOR
SET serveroutput ON;
 
DECLARE
  PNUM1 NUMBER;
  PNUM2 NUMBER;
  PNUM_AUX NUMBER;
 
  FUNCTION FN_MAX_VAL(
      PNUM1 IN NUMBER,
      PNUM2 IN NUMBER)
    RETURN NUMBER
  AS
    PNUM_AUX NUMBER;
  BEGIN
    IF PNUM1 > PNUM2 THEN
      PNUM_AUX := PNUM1;
    ELSE
      PNUM_AUX:= PNUM2;
    END IF;
    RETURN PNUM_AUX;
  END;
  
  BEGIN
    PNUM1 := 122;
    PNUM2 := 99;
    PNUM_AUX := FN_MAX_VAL (PNUM1, PNUM2);
    dbms_output.put_line('O maior valor entre ' || PNUM1 ||' e ' || PNUM2 || ' é=>> ' || PNUM_AUX);  
END;
  / 

--1) Cria tabelas 
create table notas
(id_aluno int,
 nota1 number,
 peso1 number,
 nota2 number,
 peso2 number,
 media number
 );
 --2 inserindo dados
 
 insert into notas (id_aluno,nota1,peso1,nota2,peso2) values (1,8,4,6,6);
 insert into notas (id_aluno,nota1,peso1,nota2,peso2) values (2,10,4,10,6);
 insert into notas (id_aluno,nota1,peso1,nota2,peso2) values (3,5,4,5,6);
 
 --select
 select * from notas;
 --atualiza
 UPDATE notas SET media=FN_MEDIAPOND(nota1, peso1, nota2, peso2)
 where 1=1;
 
 --verifica

 select * from notas;

 

-- criando funcao para retornar numero de salarios minimos

CREATE OR REPLACE FUNCTION FN_SAL_MIN (P_SALARIO IN NUMBER)
RETURN NUMBER
    IS
QTD_SAL_MIN NUMBER(10,2);
BEGIN 
    QTD_SAL_MIN:=P_SALARIO/954;
RETURN QTD_SAL_MIN;
END;
/
-- USANDO A FUNCAO,

SELECT A.FIRST_NAME,
       A.SALARY,
       FN_SAL_MIN(A.SALARY) AS QTD_MIN
FROM HR.EMPLOYEES A;


--1) Cria tabelas 
create table notas
(id_aluno int,
 nota1 number,
 peso1 number,
 nota2 number,
 peso2 number,
 media number
 );
 --2 inserindo dados
 
 insert into notas (id_aluno,nota1,peso1,nota2,peso2) values (1,8,4,6,6);
 insert into notas (id_aluno,nota1,peso1,nota2,peso2) values (2,10,4,10,6);
 insert into notas (id_aluno,nota1,peso1,nota2,peso2) values (3,5,4,5,6);
 
 --select
 select * from notas;
 --atualiza
 UPDATE notas SET media=FN_MEDIAPOND(nota1, peso1, nota2, peso2)
 where 1=1;
 
 --verifica

 select * from notas;

 CREATE OR REPLACE FUNCTION FUN_CALCULO(PAR1 IN NUMBER, 
                                      PAR2 IN NUMBER, 
                                      RES OUT NUMBER)

    RETURN NUMBER
    IS
    AUX NUMBER :=0;
    
    BEGIN
    RES := PAR1 + PAR2;
    AUX := RES +100;
    RETURN(AUX);
    EXCEPTION
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: '||SQLERRM);
    END;

--testando 
DECLARE
res0 NUMBER := 0;
res1 NUMBER := 0;
BEGIN
res0 := fun_calculo(6, 14, res1);
    dbms_output.put_line('O resultado é: '||res0||' e '||res1);
END;


