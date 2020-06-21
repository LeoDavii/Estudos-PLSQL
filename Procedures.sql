CREATE OR REPLACE
PROCEDURE PROC_DET_FUNC
IS
  CURSOR emp_cur
  IS
    SELECT first_name, last_name, salary FROM HR.EMPLOYEES;
    --RECEBENDO VALORES DO CURSOR
    emp_rec emp_cur%rowtype;
BEGIN
  FOR emp_rec IN emp_cur
  LOOP
    dbms_output.put_line('Nome do funcionario: ' || emp_rec.first_name);
    dbms_output.put_line('Sobrenome do funcionario: ' ||emp_rec.last_name);
    dbms_output.put_line('Sal�rio do funcionario: ' ||emp_rec.salary);
    dbms_output.put_line('---------------------------------------------');
  END LOOP;
END;

--executando procedure
SET serveroutput on
begin
 PROC_DET_FUNC;
end;

--outra forma de execucao
EXECUTE PROC_DET_FUNC;

-- criando uma procedure para retornar informa��es

CREATE OR REPLACE PROCEDURE PROC_INF_DEPTO
IS
  CURSOR FUN_CURSOR
  IS
    SELECT a.DEPARTMENT_ID,b.DEPARTMENT_NAME,SUM(salary)SALARIO FROM HR.EMPLOYEES a
    inner join HR.DEPARTMENTS b 
        on a.department_id=b.department_id
    group by a.DEPARTMENT_ID,b.DEPARTMENT_NAME;
    
    FUN_REC FUN_CURSOR%rowtype;
BEGIN
  FOR FUN_REC IN FUN_CURSOR
  LOOP
    dbms_output.put_line('Codigo Depto: ' || FUN_REC.DEPARTMENT_ID || 
     '. Nome Depto: ' ||FUN_REC.DEPARTMENT_NAME || '. Total Sal�rio do Depto: ' ||FUN_REC.salario);
  END LOOP;
  exception
  when others then
  dbms_output.put_line('Erro: '||sqlerrm);
END;
/

--EXECUTANDO
EXECUTE PROC_INF_DEPTO;

--PROCEDURE CALCULADORA
CREATE OR replace PROCEDURE proc_calc(operacao IN VARCHAR, --A ADICAO --D DIVISAO --S -SUBTR M --MULTIPL
                                      pnum1    IN NUMBER, 
                                      pnum2    IN NUMBER, 
                                      retorno OUT NUMBER) 

IS 
MSG_OUTRAS EXCEPTION;
BEGIN 

 IF operacao='A' THEN 
    retorno := pnum1 + pnum2; 
  ELSIF operacao='S' THEN 
    retorno := pnum1 - pnum2; 
  ELSIF operacao='M' THEN 
    retorno := pnum1*pnum2; 
  ELSIF operacao='D' THEN 
    retorno := pnum1/pnum2; 
    else
    raise MSG_OUTRAS;
END IF; 
  EXCEPTION 
  WHEN MSG_OUTRAS THEN 
    dbms_output.put_line('Erro nao catalogado'); 
 
  WHEN OTHERS THEN 
    dbms_output.put_line('erro: '||SQLERRM); 
  END;
  /
  
  --EXECUTANDO PROCEDURE
  DECLARE
  retorno number:=0;
  BEGIN
    proc_calc ('x',10,3,retorno);
    dbms_output.put_line(retorno);
  END;
  /
  
  
--OUTRO EXEMPLO

-- criando tabela para popular com procedure
--DROP TABLE EMPLOYEES_COPIA;
  CREATE TABLE EMPLOYEES_COPIA 
   (EMPLOYEE_ID NUMBER(6,0) PRIMARY KEY, 
	FIRST_NAME VARCHAR2(20 BYTE), 
	LAST_NAME VARCHAR2(25 BYTE), 
	EMAIL VARCHAR2(25 BYTE), 
	PHONE_NUMBER VARCHAR2(20 BYTE), 
	HIRE_DATE DATE, 
	JOB_ID VARCHAR2(10 BYTE), 
	SALARY NUMBER(8,2), 
	COMMISSION_PCT NUMBER(2,2), 
	MANAGER_ID NUMBER(6,0), 
	DEPARTMENT_ID NUMBER(4,0)
   );
   
-- VERIFICANDO TABELA CRIADA
SELECT * FROM EMPLOYEES_COPIA
 
-- criando procedure

CREATE OR REPLACE PROCEDURE PROC_COPIA_FUNC

is

BEGIN
    For func in (SELECT * FROM HR.EMPLOYEES)
  LOOP
    insert into EMPLOYEES_COPIA (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,
                                    MANAGER_ID,DEPARTMENT_ID) 
                                   values
                                   (func.EMPLOYEE_ID,func.FIRST_NAME,func.LAST_NAME,func.EMAIL,func.PHONE_NUMBER,
                                    func.HIRE_DATE,func.JOB_ID,func.SALARY,func.COMMISSION_PCT,func.MANAGER_ID,func.DEPARTMENT_ID);
  END LOOP;
 dbms_output.put_line('OK CARGA REALIZADA'); 
 COMMIT;
 
 exception
  when others then
    dbms_output.put_line('ERRO: '||sqlerrm);
    ROllBACK;
    
end PROC_COPIA_FUNC;

-- EXECUTANDO PROCEDURE
EXECUTE PROC_COPIA_FUNC;

--Verificando dados;
   
-- VERIFICANDO TABELA CRIADA
SELECT * FROM EMPLOYEES_COPIA;
SELECT COUNT(*) FROM EMPLOYEES_COPIA;

-- EXECUTANDO PROCEDURE
EXECUTE PROC_COPIA_FUNC;

--DROP TABLE EMPLOYEES_COPIA
--DROP PROCEDURE PROC_COPIA_FUNC



--DROP TABLE CAD_PESSOA;
CREATE TABLE CAD_PESSOA 
(
    ID_PESSOA INT NOT NULL PRIMARY KEY,
    NOME VARCHAR2(50),
    EMAIL VARCHAR(30),
    SITUACAO CHAR(1),
    CONSTRAINT CK_SITUA CHECK(SITUACAO IN('B','A'))
    );

--PROCEDURE DE CADASTRO
CREATE OR REPLACE PROCEDURE SP_CRUD (
                                  V_OPER       CHAR, --I INSERIR --A -ATUALIZA --S SELECIONA - D--DELETE
                                  V_ID_PESSOA  INTEGER,
                                  V_NOME       VARCHAR2,
                                  V_EMAIL      VARCHAR2,
                                  V_SITUACAO   CHAR)
IS
 --declarando variaveis
  V_SID_PESSOA INTEGER;
  V_SNOME VARCHAR2(50);
  V_SEMAIL VARCHAR2(30);
  V_SSITUACAO CHAR(1);
--declarando except
  v_EXCEPTION EXCEPTION;
  v_FALTA_CPO_INSERT EXCEPTION;
  v_FALTA_ID_DELETE EXCEPTION;
  v_FALTA_ID_UPDATE EXCEPTION;
BEGIN   
--verifica operacao de insert
  IF (V_OPER = 'I') THEN
    IF (V_ID_PESSOA is null or   V_ID_PESSOA='' or V_NOME is null OR V_NOME='' or  V_EMAIL is null or V_EMAIL='')
        then 
            ROLLBACK;
            RAISE v_FALTA_CPO_INSERT;
        else
        INSERT INTO CAD_PESSOA(ID_PESSOA, NOME,EMAIL, SITUACAO) VALUES (v_id_pessoa, v_NOME, v_email,'A');
    end if;
--verifica operacao de atualiza��o
  ELSIF (V_OPER = 'A') THEN
     IF (V_ID_PESSOA is null or   V_ID_PESSOA='') 
     THEN
        ROLLBACK;
        RAISE v_FALTA_ID_UPDATE;
        ELSE
            UPDATE CAD_PESSOA SET NOME =NVL(V_NOME,NOME), EMAIL=NVL(V_EMAIL,EMAIL),SITUACAO=NVL(V_SITUACAO,SITUACAO)
           WHERE ID_PESSOA = V_ID_PESSOA;
      end if;  
  --verifica operacao de delete
  ELSIF(V_OPER = 'D')THEN
     IF (V_ID_PESSOA is null or V_ID_PESSOA='') 
       THEN
        ROLLBACK;
        RAISE v_FALTA_ID_DELETE;
        ELSE
            DELETE FROM CAD_PESSOA WHERE ID_PESSOA = V_ID_PESSOA;
     END IF;
 --verifica operacao de select
   ELSIF(V_OPER = 'S')THEN
    SELECT * INTO  V_SID_PESSOA,V_SNOME,V_SEMAIL,V_SSITUACAO 
    FROM CAD_PESSOA WHERE ID_PESSOA = V_ID_PESSOA;
    
     dbms_output.put_line('ID: '||V_SID_PESSOA); 
     dbms_output.put_line('Nome: '||V_SNOME); 
     dbms_output.put_line('e-mail: '||V_SEMAIL); 
     dbms_output.put_line('Situacao: '||V_SSITUACAO); 
    ELSE
    RAISE v_EXCEPTION;
  END IF;
    
 COMMIT;
    dbms_output.put_line('DADOS SELECIONADOS,INSERIDOS OU ATUALIZADO COM SUCESSO'); 
 --execpt   
  EXCEPTION
   
    WHEN v_EXCEPTION THEN 
      RAISE_APPLICATION_ERROR(-20999,'ATEN��O! Opera��o diferente de I, D, A OU S', FALSE);
    
    WHEN v_FALTA_CPO_INSERT THEN    
      dbms_output.put_line('FALHA NO INSERT, CAMPOS NAO PREENCHIDOS CORRETAMENTE!'); 
    
    WHEN v_FALTA_ID_UPDATE THEN  
      dbms_output.put_line('FALHA NO UPDATE, INFORME O ID!'); 
   
    WHEN v_FALTA_ID_DELETE THEN   
      dbms_output.put_line('FALHA NO DELETE, INFORME O ID!'); 
     
     WHEN OTHERS THEN
        IF SQLCODE='-00001' THEN
             DBMS_OUTPUT.PUT_LINE('ERRO: CODIGO JA EXISTE! ');
             DBMS_OUTPUT.PUT_LINE('ERRO: '||SQLERRM);
        ELSE
            DBMS_OUTPUT.PUT_LINE('CODIGO: '||SQLCODE);
            DBMS_OUTPUT.PUT_LINE('ERRO: '||SQLERRM);
            RAISE;
        END IF;
    ROLLBACK;
      
END ;
/
----I INSERIR --A -ATUALIZA --S SELECIONA - D--DELETE
--EXECUTANDO 
--REALIZANDO INSERT PARAM V_OPER,V_ID_PESSOA,V_NOME,V_EMAIL,V_SITUACAO

SET SERVEROUTPUT ON
DECLARE
    P_OPER CHAR(1);
    P_ID INT;
    P_NOME VARCHAR2(50);
    P_EMAIL VARCHAR2(30);
    P_SIT CHAR(1);
    BEGIN
      P_OPER:='S';
      P_ID:=1;
      P_NOME:='JEFF';
      P_EMAIL:=NULL;
      P_SIT:='B';
    
        SP_CRUD(P_OPER,P_ID,P_NOME,P_EMAIL,P_SIT);
    END;

-- criando tabelas para procedure atualiza estoque

CREATE TABLE MATERIAL (
    COD_MAT INT PRIMARY KEY,
    DESCRICAO VARCHAR2(50) NOT NULL,
    PRECO_UNIT NUMBER(10,2)
);

 CREATE SEQUENCE  SEQ_COD_MAT
	INCREMENT BY 1
	START WITH 1
	ORDER
	CACHE 10;
 
CREATE TABLE ESTOQUE 
  ( 
     COD_MAT INT  PRIMARY KEY NOT NULL, 
     SALDO   DECIMAL (10, 2) NULL 
  ) ;
  

CREATE TABLE ESTOQUE_LOTE 
  ( 
     COD_MAT INT NOT NULL,
     LOTE    VARCHAR (15) NOT NULL, 
     SALDO   DECIMAL (10, 2) NULL, 
     FOREIGN KEY (COD_MAT) REFERENCES MATERIAL(COD_MAT), 
	 PRIMARY KEY (COD_MAT, LOTE) 
  ) ;

CREATE TABLE mov_estoque 
  ( 
     transacao  INT PRIMARY KEY NOT NULL,
     mov        VARCHAR2 (1) NOT NULL, 
     cod_mat    INT NOT NULL, 
     lote       VARCHAR (15) NOT NULL, 
     qtd        INT NOT NULL, 
     usuario    VARCHAR2 (30) NOT NULL, 
     dt_hor_mov DATE NOT NULL 
  ) ;
  
    CREATE SEQUENCE  seq_mov_estoque
	INCREMENT BY 1
	START WITH 1
	ORDER
	CACHE 10;



ALTER TABLE estoque 
  ADD FOREIGN KEY (cod_mat) REFERENCES material(cod_mat); 


ALTER TABLE mov_estoque 
  ADD FOREIGN KEY (cod_mat) REFERENCES material(cod_mat); 
  
 --inserindo dados 
  INSERT INTO material   (cod_mat,descricao,preco_unit) VALUES
        (seq_cod_mat.NEXTVAL,'SMART TV 40',2200.99);
  INSERT INTO material   (cod_mat,descricao,preco_unit) VALUES
        (seq_cod_mat.NEXTVAL,'SMARTPHONE',1990.99);
  INSERT INTO material   (cod_mat,descricao,preco_unit) VALUES
        (seq_cod_mat.NEXTVAL,'HOME THEATER',999.99);  
        


SELECT * FROM MATERIAL;

-- CRIANDO PROCEDURE PARA ALIMENTAR ESTOQUE
--REGRAS
/*
VERIFICAR SE A OPERACAO E PERMITIDA (-E ENTRADA E S SAIDA
VERIFICAR SE O MATERIAL EXISTE
-- VERIFICOES DE SAIDA
1 VERIFICAR SE MATERIAL TEM SALDO ESTOQUE E E QTD SAIDA E MENOR QUE SALDO
2 VERIFICAR SE MATERIAL TEM SALDO ESTOQUE_LOTE E E QTD SAIDA E MENOR QUE SALDO DO LOTE
-- VERIFICACOES ENTRADA
1 SE MATERIAL EXISTE UPDATE
2 SENAO EXISTE INSERT
TABELAS ENVOLVIDAS
ESTOQUE
ESTOQUE_LOTE
ESTQUE_MOV
-- EXECOES ROLLBACK


*/
CREATE OR REPLACE PROCEDURE PRC_MOV_ESTOQUE (P_OPER IN VARCHAR2,P_COD_MAT IN INT,P_LOTE IN VARCHAR2,P_QTD IN INT)
IS
V_SALDO_ESTOQUE INT;
V_SALDO_ESTOQUE_LOTE INT;
V_MAT_EXISTE INT ;
V_REG_ESTOQUE INT;
V_REG_ESTOQUE_LOTE INT;
EXC_MAT_N_EXISTE EXCEPTION;
EXC_OPERACAO_NAO_PERMITIDA EXCEPTION;
EXC_ESTOQUE_NEGATIVO EXCEPTION;
EXC_ESTOQUE_NEGATIVO_LOTE EXCEPTION;

BEGIN 
    -- VERIFICANDO SE OPERACAO � PERMITIDA;
    IF P_OPER NOT IN ('E','S') THEN
    RAISE EXC_OPERACAO_NAO_PERMITIDA;
    ELSE 
    dbms_output.put_line('OPERACAO OK! CONTINUA!');
    END IF;
    -- VERIFICANDO SE MATERIAL EXISTE
    SELECT COUNT(*) INTO V_MAT_EXISTE FROM MATERIAL WHERE COD_MAT=P_COD_MAT;
    IF V_MAT_EXISTE=0 THEN
    RAISE EXC_MAT_N_EXISTE;
    ELSE
        dbms_output.put_line('MATERIAL EXISTE! CONTINUA');
    END IF;
  
  --VERIFICANDO SE EXISTE REGISTRO EM ESTOQUE
  SELECT COUNT(*) INTO V_REG_ESTOQUE 
  FROM ESTOQUE 
  WHERE COD_MAT=P_COD_MAT;
   dbms_output.put_line('QTD REG ESTOQUE '||V_REG_ESTOQUE);
  -- VERIFICANDO OPERACAO DE SAIDA SE MATERIAL EXISTE NAO ESTOQUE
  IF P_OPER='S' AND V_REG_ESTOQUE=0 
  THEN
      RAISE EXC_ESTOQUE_NEGATIVO;
      ELSIF  P_OPER='S' AND V_REG_ESTOQUE>0  THEN
       -- ATRIBUINDO SALDO DE ESTOQUE E QTD REGISTRO
        SELECT SALDO,COUNT(*) INTO V_SALDO_ESTOQUE,V_REG_ESTOQUE FROM ESTOQUE 
        WHERE COD_MAT=P_COD_MAT 
        GROUP BY SALDO;
        dbms_output.put_line('TEM ESTOQUE');
  END IF;
  
  --VERIFICANDO SE EXISTE REGISTRO EM ESTOQUE LOTE
  SELECT COUNT(*) INTO V_REG_ESTOQUE_LOTE 
  FROM ESTOQUE_LOTE 
  WHERE COD_MAT=P_COD_MAT AND LOTE=P_LOTE;
  dbms_output.put_line('QTD REG ESTOQUE LOTE '||V_REG_ESTOQUE_LOTE);
  -- VERIFICANDO OPERACAO DE SAIDA SE MATERIAL EXISTE NAO ESTOQUE
  IF P_OPER='S' AND V_REG_ESTOQUE_LOTE=0 
  THEN
      RAISE EXC_ESTOQUE_NEGATIVO_LOTE;
      ELSIF P_OPER='S' AND V_REG_ESTOQUE_LOTE>0 THEN
      -- ATRIBUINDO SALDO DE ESTOQUE_LOTE E QTD REGISTRO
        SELECT SUM(SALDO),COUNT(*) INTO V_SALDO_ESTOQUE_LOTE,V_REG_ESTOQUE_LOTE FROM ESTOQUE_LOTE 
        WHERE COD_MAT=P_COD_MAT AND LOTE=P_LOTE;
        dbms_output.put_line('TEM ESTOQUE LOTE');
  END IF;
  
  IF P_OPER='S' AND  (V_SALDO_ESTOQUE_LOTE-P_QTD<0 OR V_SALDO_ESTOQUE-P_QTD<0) THEN
     RAISE EXC_ESTOQUE_NEGATIVO_LOTE;
    ELSIF P_OPER='S' AND  V_SALDO_ESTOQUE_LOTE-P_QTD>=0 AND V_SALDO_ESTOQUE-P_QTD>=0 THEN
    -- ATUALIZA ESTOQUE
    UPDATE ESTOQUE SET SALDO=SALDO-P_QTD WHERE COD_MAT=P_COD_MAT;
    -- ATUALIZA ESTOQUE LOTE
    UPDATE ESTOQUE_LOTE SET SALDO=SALDO-P_QTD WHERE COD_MAT=P_COD_MAT AND LOTE=P_LOTE;
    -- INSERE ESTOQUE MOV
    INSERT INTO MOV_ESTOQUE (transacao,mov,cod_mat,lote,qtd,usuario,dt_hor_mov) VALUES
        (seq_mov_estoque.NEXTVAL,P_OPER,P_COD_MAT,P_LOTE,P_QTD,USER,SYSDATE);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('OPERACAO FINALIZADA');
    END IF;
    -- FINALIZA OPERACAO PARA SAIDA
    --INICIA OPERACAO PARA ENTRADA
    
    --VERIFCANDO SE MATERIAL TEM REGISTRO NA ESTOQUE E ESTOQUE LOTE
    IF P_OPER='E' AND V_REG_ESTOQUE_LOTE>0 AND V_REG_ESTOQUE>0 THEN
        -- ATUALIZANDO ESTOQUE
         UPDATE ESTOQUE SET SALDO=SALDO+P_QTD WHERE COD_MAT=P_COD_MAT;
          -- ATUALIZANDO ESTOQUE_LOTE
         UPDATE ESTOQUE_LOTE SET SALDO=SALDO+P_QTD WHERE COD_MAT=P_COD_MAT AND LOTE=P_LOTE;
         -- INSERE ESTOQUE MOV
         INSERT INTO MOV_ESTOQUE (transacao,mov,cod_mat,lote,qtd,usuario,dt_hor_mov) VALUES
            (seq_mov_estoque.NEXTVAL,P_OPER,P_COD_MAT,P_LOTE,P_QTD,USER,SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('OPERACAO FINALIZADA');
        -- VERIFICA QUE EXISTE ESTOQUE MAS NAO EXISTE ESTOQUE LOTE PARA INSERT ESTOQUE LOTE E UPDATE ESTOQUE
    ELSIF P_OPER='E' AND V_REG_ESTOQUE_LOTE=0 AND V_REG_ESTOQUE>0 THEN
        -- ATUALIZANDO ESTOQUE
         UPDATE ESTOQUE SET SALDO=SALDO+P_QTD WHERE COD_MAT=P_COD_MAT;
        --INSERINDO REGISTRO NA ESTOQUE LOTE
         INSERT INTO ESTOQUE_LOTE (COD_MAT,SALDO,LOTE) VALUES (P_COD_MAT,P_QTD,P_LOTE);
          -- INSERE ESTOQUE MOV
         INSERT INTO MOV_ESTOQUE (transacao,mov,cod_mat,lote,qtd,usuario,dt_hor_mov) VALUES
            (seq_mov_estoque.NEXTVAL,P_OPER,P_COD_MAT,P_LOTE,P_QTD,USER,SYSDATE);
         COMMIT;
        DBMS_OUTPUT.PUT_LINE('OPERACAO FINALIZADA');
        -- VERIFICANDO QUE NAO EXISTE ESTOQUE E ESTOQUE LOTE PARA INSERT
    ELSIF P_OPER='E' AND V_REG_ESTOQUE_LOTE=0 AND V_REG_ESTOQUE=0 THEN
        -- INSERINDO ESTOQUE
         INSERT INTO  ESTOQUE (COD_MAT,SALDO) VALUES (P_COD_MAT,P_QTD);
        --INSERINDO REGISTRO NA ESTOQUE LOTE
         INSERT INTO ESTOQUE_LOTE (COD_MAT,SALDO,LOTE) VALUES (P_COD_MAT,P_QTD,P_LOTE);
          -- INSERE ESTOQUE MOV
         INSERT INTO MOV_ESTOQUE (transacao,mov,cod_mat,lote,qtd,usuario,dt_hor_mov) VALUES
            (seq_mov_estoque.NEXTVAL,P_OPER,P_COD_MAT,P_LOTE,P_QTD,USER,SYSDATE);
         COMMIT;
        DBMS_OUTPUT.PUT_LINE('OPERACAO FINALIZADA');
    END IF;
    -- TERMINA ENTRADA
    --INICIA EXCESSOES
EXCEPTION
    when EXC_OPERACAO_NAO_PERMITIDA THEN
        DBMS_OUTPUT.PUT_LINE('A OPERACAO DEVER SER E-ENTRADA OU S-SAIDA');
        ROLLBACK;
     
     when EXC_MAT_N_EXISTE THEN
        DBMS_OUTPUT.PUT_LINE('MATERIAL NAO EXISTE CADASTRO');
        ROLLBACK;
     
    when EXC_ESTOQUE_NEGATIVO THEN
        DBMS_OUTPUT.PUT_LINE('ESTOQUE NEGATIVO,OPERACAO NAO PERMITIDA!!!');
        ROLLBACK;
     
    when EXC_ESTOQUE_NEGATIVO_LOTE THEN
        DBMS_OUTPUT.PUT_LINE('ESTOQUE LOTE NEGATIVO,OPERACAO NAO PERMITIDA!!!');
        ROLLBACK;
    
    when NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('REGISTRO NAO ENCONTRADO!');
        DBMS_OUTPUT.PUT_LINE('Linha: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        ROLLBACK;
         
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('CODIGO DO ERRO '||SQLCODE||' MSG '||SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Linha: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        ROLLBACK;

end;

-- testando procedure
--PARAMETROS OPERACAO,MATERIAL,LOTE,QTD
execute PRC_MOV_ESTOQUE ('S',1,'ABC',10);


      
select * from ESTOQUE;
SELECT * FROM ESTOQUE_LOTE;
SELECT a.*,to_char(a.DT_HOR_MOV,'dd/mm/yyyy hh24:mi:ss') data 
FROM MOV_ESTOQUE a;
/*
DELETE from ESTOQUE;
DELETE FROM ESTOQUE_LOTE;
DELETE FROM MOV_ESTOQUE;
*/


select to_char(DT_HOR_MOV,'cc dd/mm/yyyy hh24:mi:ss') data from MOV_ESTOQUE;
select to_char(sysdate,'cc dd/mm/yyyy hh24:mi:ss') data from dual;

select to_char(sysdate,'cc dd/mm/yyyy hh24:mi:ss'),
       to_char(current_date,'cc dd/mm/yyyy hh24:mi:ss'),
       sysdate,
       current_date from dual;
