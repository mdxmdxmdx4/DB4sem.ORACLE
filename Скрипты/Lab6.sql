select * from v$parameter;

SELECT value 
FROM v$parameter 
WHERE name = 'spfile';

show parameter spfile;

create pfile='LDI_PFILE.ORA' FROM SPFILE;

create spfile = 'LDI_SPFILE.ORA' from pfile='LDI_PFILE.ORA';

select * from v$pgastat;

select * from v$parameter;


select * from v$controlfile;


alter database backup controlfile to trace;

SELECT value FROM v$parameter WHERE name = 'compatible';

ALTER SYSTEM SET compatible = '12.1.0.1.0' SCOPE=SPFILE;


SELECT value FROM v$parameter WHERE name = 'user_dump_dest';


SELECT value FROM v$parameter WHERE name = 'remote_login_passwordfile';
SELECT * FROM V$PWFILE_USERS;


select * from v$diag_info;

