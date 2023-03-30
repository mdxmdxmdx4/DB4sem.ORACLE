--1
select * from dba_tablespaces;

select * from dba_users;

--2
CREATE smallfile 
tablespace LDI_QDATA
datafile 'C:\BD\tablespaces\LDI_QDATA_5TBS.dbf' size 10m reuse autoextend on next 2m maxsize 1024m
logging
offline
extent management local
segment space management auto;

alter tablespace LDI_QDATA online;

alter user C##LDILDI QUOTA 2m on LDI_QDATA;
commit;

--as user
create table LDI_t1(
FR number(4) primary KEY,
SR varchar2(50)
) tablespace LDI_QDATA;
commit;

select * from C##LDILDI.ldi_t1;


insert into LDI_t1 values(999,'asd');
insert into LDI_t1 values(4,'lookatme!');
insert into LDI_t1 values(11,'moonlight');

select * from C##LDILDI.ldi_t1;
commit;

--3
select * from dba_segments where tablespace_name = 'LDI_QDATA';

select case 
when exists (select * from dba_segments where tablespace_name = 'LDI_QDATA') then 'yes'
else 'no'
end as "Are segments exists?"
from dual;

show parameter segment;
commit;

--4

select * from dba_segments
where owner = 'C##LDILDI';

insert into LDI_t1 values(3,'asdv');

--5

select * from dba_segments;

--6
drop table C##LDILDI.LDI_t1;
commit;

select * from dba_segments
where tablespace_name = 'LDI_QDATA';

--7
select * from dba_segments where tablespace_name = 'LDI_QDATA';

--as user
select * from user_recyclebin;


--8
flashback table LDI_t1 to before drop;

select table_name, tablespace_name from user_tables;

select * from all_tables where owner = 'C##LDILDI';

select * from C##LDILDI.ldi_t1;

--9
alter table C##LDILDI.ldi_t1 modify fr number(5);

begin
for k in 1..10000
loop
insert into C##LDILDI.ldi_t1 values(k,'o');
end loop;
commit;
end;


--10
select segment_name, segment_type, tablespace_name, bytes, blocks, extents, buffer_pool
from user_segments
where tablespace_name = 'LDI_QDATA';

--11
select * from user_extents;

--12
select rowid, fr, sr from C##LDILDI.LDI_t1;

select RowSCN, fr, sr from C##LDILDI.LDI_t1;






