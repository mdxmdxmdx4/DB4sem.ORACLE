ALTER SESSION SET "_oracle_script" = TRUE

select * from my_table;
SELECT DEFAULT_TABLESPACE FROM USER_USERS;

create tablespace ldildi
datafile 'C:\ldildi.dbf'
size 7 m
autoextend on next 5 m
maxsize 30M
extent management local;

create temporary tablespace ldildi_temp
tempfile 'C:\ldildi_temp.dbf'
size 5 m
autoextend on next 3 m
maxsize 20 m
extent management local;

select * from SYS.DBA_TABLESPACES;

SELECT tablespace_name, file_id, file_name, bytes, status 
FROM dba_data_files;

commit;

create role RL_LDICORE;

select * from dba_roles where role like 'RL_LDICORE%';

grant create session,
create table,
create view,
create procedure to RL_LDICORE;

select * from dba_sys_privs where grantee = 'RL_LDICORE';

CREATE PROFILE PF_LDICORE limit
password_life_time 180
sessions_per_user 3
FAILED_LOGIN_ATTEMPTS 7
PASSWORD_LOCK_TIME 1
PASSWORD_REUSE_TIME 10
PASSWORD_GRACE_TIME default
connect_time 180
idle_time 30;

SELECT distinct profile FROM dba_profiles;


select * from dba_profiles where profile = 'PF_LDICORE';

select * from dba_profiles where profile = 'DEFAULT';

CREATE USER LDICORE identified  by 12345
default tablespace ldildi quota unlimited on ldildi
temporary tablespace ldildi_temp
profile PF_LDICORE
account unlock
password expire;

grant RL_LDICORE to LDICORE;

alter user LDICORE identified by 666666;

create table LDI_T(
SOMESTR varchar(10)
)
insert into LDI_T values ('12345678');

alter user LDICORE Quota 2m on ldildi;

commit;

insert into LDI_T values ('8685858');

select * from ldi_t;

alter tablespace  ldildi OFFLINE;

insert into LDI_T values ('110');

alter tablespace  ldildi online;

insert into LDI_T values ('23');

select * from ldi_t;
commit;
    




