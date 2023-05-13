---as sys in CBD
SELECT name, open_mode
FROM v$pdbs;

alter pluggable database LDI_PDB open; --!!!!!!!!!! ЕСЛИ ПДБ В СОСТОЯНИИ МАУНТЕД


SELECT SID, SERIAL#, USERNAME, MACHINE, PROGRAM, STATUS
FROM V$SESSION; -- список подключений

SELECT *
FROM v$pdbs
where name = 'LDI_PDB';

create tablespace CDB_TBS
datafile 'C:\BD\CDB_TBS.dbf'
size 7 m
autoextend on next 5 m
maxsize 30M
extent management local;

create temporary tablespace CDB_TBS_TEMP
tempfile 'C:\BD\CDB1_TBS_TEMP.dbf'
size 7 m
autoextend on next 5 m
maxsize 30M
extent management local;

-- as sys in PBD
create tablespace LDI_PDB_TRUE
datafile 'C:\BD\LDI_PDB\true_ldi_pdb.dbf'
size 7 m
autoextend on next 5 m
maxsize 30M
extent management local;

create temporary tablespace LDI_PDB_TRUE_TEMP
tempfile 'C:\BD\LDI_PDB\true_ldi_pdb_temp.dbf'
size 5 m
autoextend on next 3 m
maxsize 20 m
extent management local;

create role U_LDI_PDB;

grant create session,
create table,
create view,
create procedure to U_LDI_PDB;

commit;

select * from dba_roles where role like 'U_LDI_PDB%';

CREATE PROFILE PF_LDI_PDB limit
password_life_time 180
sessions_per_user 5
FAILED_LOGIN_ATTEMPTS 10
PASSWORD_LOCK_TIME 1
PASSWORD_REUSE_TIME 10
PASSWORD_GRACE_TIME default
connect_time 180
idle_time 30;

CREATE USER U1_LDI_PDB identified  by 55555
default tablespace LDI_PDB_TRUE quota unlimited on LDI_PDB_TRUE
temporary tablespace LDI_PDB_TRUE_TEMP
profile PF_LDI_PDB
account unlock;

grant U_LDI_PDB to U1_LDI_PDB;


--as U1 in PDB
create table LDI_table(
NUMBER_COLUMN number(3) not null
);

insert into LDI_table 
values (11);
select * from LDI_table;

commit;


--as sys in PDB
select * from SYS.DBA_TABLESPACES;

SELECT tablespace_name, file_id, file_name, bytes, status 
FROM dba_data_files;


select * from dba_roles where role like 'U_LDI_PDB%';

select * from dba_sys_privs where grantee = 'U_LDI_PDB';

select * from dba_profiles; --where profile = 'PF_LDI_PDB';

select * from dba_users where username = 'U1_LDI_PDB';


--as sys in CDB!!!
create user C##LDILDI identified by 5555;

grant create session to C##LDILDI;
grant create table to C##LDILDI;


commit;

--as c## in CDB

create table sampleTest(
StrCollumn varchar2(10)
)

insert into sampleTest
values(88);

select * from sampleTest;

--пользователь не может добавлять строки, т.к не прописано табличное пространство

--as C## in PDB
alter user C##LDILDI QUOTA 10m on USERS

create table ASD(
NUMSS number(3)
)
commit;

insert into ASD
values(11);
select * from ASD;



select * from user_objects;


