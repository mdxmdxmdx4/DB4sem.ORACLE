create tablespace TS_LDI1
datafile 'C:\BD\tablespaces\ldi.dbf'
size 7m
AUTOEXTEND on next 5m
maxsize 30m
extent management local;

create temporary tablespace TS_TEMP_LDI
TEMPFILE 'C:\BD\tablespaces\TEMP_ldi.dbf'
size 5m
autoextend on next 3m
maxsize 20m
extent management local;



