--1
SELECT value/1024/1024 as sga_target_mb
FROM v$parameter
WHERE name = 'sga_target';

--2
SELECT pool, bytes/1024/1024 size_mb
FROM v$sgastat
WHERE pool IN ('shared pool', 'buffer cache', 'large pool', 'java pool', 'streams pool');

--3

SELECT *
FROM v$sgainfo
WHERE name = 'Granule Size';


--4

SELECT SUM(bytes)
FROM v$sgastat
WHERE pool = 'free memory';

--5

SELECT name, value/1024/1024 AS size_mb
FROM v$parameter
WHERE name IN ('sga_max_size', 'sga_target');


--6

SELECT *
FROM v$buffer_pool
WHERE name IN ('KEEP', 'DEFAULT', 'RECYCLE');

ALTER SYSTEM SET DB_KEEP_CACHE_SIZE = 500M SCOPE = MEMORY;

--7
CREATE TABLE TforLab7 (
  id NUMBER PRIMARY KEY,
  name VARCHAR2(50)
) storage(buffer_pool Keep) TABLESPACE users;

SELECT *
FROM user_segments
WHERE segment_name = 'TforLab7';

--8
CREATE TABLE TforLab72 (
  id NUMBER,
  name VARCHAR2(50),
  date_created DATE
)
CACHE;

insert into TforLab72(id, name, date_created)
values(1, 'AOIJSDA', TO_DATE('15.12.2023', 'DD.MM.YYYY'));
COMMIT

SELECT *
FROM user_segments
WHERE segment_type = 'TABLE' AND segment_name = 'TforLab72';

--9
SELECT name, value
FROM v$parameter
WHERE name = 'log_buffer'

--10
SELECT name, bytes/1024/1024 AS "Free Size (MB)"
FROM v$sgastat
WHERE pool = 'large pool'
AND name = 'free memory'

--11

SELECT sid, serial#, program, server
FROM v$session
WHERE type != 'BACKGROUND'

--12
SELECT *
FROM v$bgprocess;

--13----
SELECT *
FROM v$process
WHERE background = 0



--14
SELECT COUNT(*)
FROM v$bgprocess
WHERE name LIKE 'DBW%';

--15

SELECT *
FROM v$active_services;

--16
SELECT name, value
FROM v$parameter
WHERE name LIKE '%dispatch%'
   OR name LIKE '%server%';
   
   