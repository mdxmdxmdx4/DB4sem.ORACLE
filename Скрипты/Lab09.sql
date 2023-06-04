--2
CREATE GLOBAL TEMPORARY TABLE temp_table (
  id NUMBER,
  name VARCHAR2(50)
);

INSERT INTO temp_table (id, name)
VALUES (1, 'John');

select * from temp_table;

--3
create sequence U1_LDI_PDB.SEQONE
increment by 10
start with 1000
nomaxvalue
nominvalue
nocycle
nocache
noorder;

select U1_LDI_PDB.SEQONE.CURRVAL from dual;
select U1_LDI_PDB.SEQONE.NEXTVAL from dual;
select U1_LDI_PDB.SEQONE.CURRVAL from dual;
select U1_LDI_PDB.SEQONE.NEXTVAL from dual;
select U1_LDI_PDB.SEQONE.CURRVAL from dual;


--4
create sequence U1_LDI_PDB.SEQTWO
increment by 10
start with 10
maxvalue 100
nocycle;


select U1_LDI_PDB.SEQTWO.NEXTVAL from dual;
select U1_LDI_PDB.SEQTWO.CURRVAL from dual;

--5 
create sequence U1_LDI_PDB.SEQ3
increment by -10
start with 10
minvalue -100
maxvalue 100
nocycle
order;

select U1_LDI_PDB.SEQ3.NEXTVAL from dual;
select U1_LDI_PDB.SEQ3.CURRVAL from dual;

--6 
CREATE SEQUENCE S4
  START WITH 10
  INCREMENT BY 1
  MINVALUE 10
  MAXVALUE 30
  CYCLE
  CACHE 5
  NOORDER;
  
SELECT S4.NEXTVAL FROM DUAL CONNECT BY LEVEL <= 20;

--7
select * from sys.user_sequences;

--8
commit;
--drop sequence U1_LDI_PDB.SEQONE;
--drop sequence U1_LDI_PDB.SEQTWO;
--drop sequence U1_LDI_PDB.SEQ3;
--drop sequence U1_LDI_PDB.S4;


 --as sys in cdb
--ALTER SYSTEM SET DB_KEEP_CACHE_SIZE = 500M SCOPE = MEMORY;


Create table tableone(
 nf number(10),
 ns number(10),
 nt number(10),
 nfr number(10)
 ) storage(buffer_pool Keep);

insert into tableone(nf,ns,nt,nfr)
values (U1_LDI_PDB.SEQONE.NEXTVAL, U1_LDI_PDB.SEQTWO.NEXTVAL,U1_LDI_PDB.SEQ3.NEXTVAL, U1_LDI_PDB.S4.NEXTVAL);

select * from tableone;

--9
CREATE CLUSTER ABC
(
  X NUMBER(10),
  V VARCHAR2(12)
)
HASHKEYS 200;


--10
CREATE TABLE A
(
  XA NUMBER(10),
  VA VARCHAR2(12),
  ADDITIONAL_COL VARCHAR2(50)
)
CLUSTER ABC(XA, VA);

-- 11
CREATE TABLE B
(
  XB NUMBER(10),
  VB VARCHAR2(12),
  ADDITIONAL_COL VARCHAR2(50)
)
CLUSTER ABC(XB, VB);

-- 12
CREATE TABLE C
(
  XC NUMBER(10),
  VC VARCHAR2(12),
  ADDITIONAL_COL VARCHAR2(50)
)
CLUSTER ABC(XC, VC);

-- 13
SELECT * FROM USER_TABLES WHERE TABLE_NAME IN ('A', 'B', 'C');

SELECT * FROM USER_CLUSTERS WHERE CLUSTER_NAME = 'ABC';

-- 14 
CREATE SYNONYM MYSYN FOR C;
select * from MYSYN;

-- 15
CREATE PUBLIC SYNONYM PUB_SYN FOR B;
--AS user and sys
select * from PUB_SYN;

--16
CREATE TABLE AA (
  id NUMBER(10) PRIMARY KEY,
  name VARCHAR2(50)
);
CREATE TABLE BB (
  name VARCHAR2(50),
  foreign_key NUMBER(10),
  CONSTRAINT fk_a FOREIGN KEY (foreign_key) REFERENCES AA(id)
);

INSERT INTO AA (id, name) VALUES (1, 'FIRST ROW OF A TABLE');
INSERT INTO AA (id, name) VALUES (2, 'SECOND ROW OF A TABLE');
INSERT INTO BB ( name, foreign_key) VALUES ('IT IS TABLE B1', 1);
INSERT INTO BB ( name, foreign_key) VALUES ('IT IS TABLE B2', 2);

CREATE OR REPLACE VIEW V1 AS
SELECT AA.id, AA.name, BB.name AS b_name
FROM AA
INNER JOIN BB
ON AA.id = BB.foreign_key;

select * from V1;

-- 17
CREATE MATERIALIZED VIEW MV_LDI
REFRESH FORCE ON DEMAND
START WITH SYSDATE
NEXT SYSDATE + 2/1440
AS SELECT AA.id, AA.name, BB.name AS b_name
FROM AA
INNER JOIN BB
ON AA.id = BB.foreign_key;


SELECT * From MV_LDI;
INSERT INTO AA (id, name) VALUES (12, 'ascasca');
INSERT INTO BB ( name, foreign_key) VALUES ('adsdasaa', 12);
commit;

--18
create public database link LDI_DBL_conn
connect to KDR_PDB_USER
identified by qqqqqq
using '192.168.31.173:1521/orcl';

--19
select * from test_table@LDI_DBL_conn;
insert into test_table@LDI_DBL_conn(ncol, ccol)
values(1, 'asdasd');
delete test_table where ncol = 1;