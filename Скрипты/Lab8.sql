SHOW PARAMETER DIAGNOSTIC_DEST;

select * from v$pdbs;


SELECT name, open_mode
FROM v$pdbs;

alter pluggable database LDI_PDB open;