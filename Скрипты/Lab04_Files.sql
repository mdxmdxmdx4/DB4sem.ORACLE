--1
SELECT tablespace_name, contents
FROM dba_tablespaces;


--2
SELECT tablespace_name, file_id, file_name 
FROM dba_data_files
UNION
SELECT tablespace_name, file_id, file_name
FROM dba_temp_files;

SELECT * FROM DBA_DATA_FILES WHERE TABLESPACE_NAME='UNDOTBS1';

--3
SELECT GROUP# FROM V$LOG GROUP BY GROUP#;

SELECT GROUP# FROM V$LOG WHERE STATUS='CURRENT';


SELECT * FROM V$LOG;

--4
SELECT member 
FROM v$logfile 
WHERE group# IN (
    SELECT group# 
    FROM v$log
); -- ИЛИ  SELECT member FROM v$logfile


--5
SELECT group#, sequence#, bytes, status, first_change#, next_change#
FROM v$log;

ALTER SYSTEM SWITCH LOGFILE;


SELECT log_mode FROM v$database;

--6
ALTER DATABASE
ADD LOGFILE GROUP 99 (
    'C:\APP\ORA_INSTALL_USER\ORADATA\MYORCL\REDOX99a.LOG',
    'C:\APP\ORA_INSTALL_USER\ORADATA\MYORCL\REDOX99b.LOG',
    'C:\APP\ORA_INSTALL_USER\ORADATA\MYORCL\REDOX99c.LOG'
) SIZE 100M;


ALTER SYSTEM SWITCH LOGFILE;

SELECT group#, sequence#, bytes, status, first_change#, next_change#
FROM v$log;

ALTER DATABASE CLEAR LOGFILE GROUP 99;

--7
ALTER DATABASE
DROP LOGFILE GROUP 99;

--8
SELECT log_mode FROM v$database;

--9
SELECT MAX(sequence#) AS last_archived_seq#
FROM v$log_history;


SELECT log_mode FROM v$database;

--10
ALTER SYSTEM SET log_archive_start=TRUE SCOPE=SPFILE;

SHUTDOWN IMMEDIATE;
STARTUP;

SELECT dest_name, status FROM v$archive_dest;

ALTER SYSTEM ARCHIVE LOG START;


SELECT group#, sequence#, bytes, status, first_change#, next_change#
FROM v$log;

alter database archivelog;

--11
alter system switch logfile;
select * from v$archived_log;

select Name, first_change#, next_change#, from v$archived_log;

show parameter db_recovery;

archive log list;
--12
shutdown;
startup mount;
alter database noarchivelog;


select * from v$instance;

--13

SELECT name FROM v$controlfile;


--14
SHUTDOWN IMMEDIATE;
startup mount exclusive;

ALTER DATABASE BACKUP CONTROLFILE TO TRACE;

SHUTDOWN IMMEDIATE;
