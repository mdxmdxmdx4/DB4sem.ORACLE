create table LDI_t(
First_Row number(3) primary KEY,
Second_Row varchar2(50)
);

select * from LDI_t;

--??
insert into LDI_t values (8,'223');
insert into LDI_t values (10,'sample of string');
insert into LDI_t values (700,'asdasd');

commit;

update LDI_t set First_Row = 123 where First_Row = 1;
update LDI_t set Second_Row = 'update statement' where ldi_t.second_row = '223';

commit;

select * from LDI_t
where ldi_t.first_row > 133;

select max(ldi_t.first_row)
from LDI_t;

delete ldi_t
where ldi_t.first_row = 999;

rollback;

create table LDI_t_childd(
NumOfSmthng number(3) not null,
CONSTRAINT fk_child
foreign key(NumOfSmthng)
references LDI_t(First_Row)
);

commit;

select * from ldi_t_childd;
insert into ldi_t_childd values (8);
insert into ldi_t_childd values (10);

select * from ldi_t e1
inner join ldi_t_childd e2 on e1.First_Row = e2.NumOfSmthng;

select * from ldi_t e1
left join ldi_t_childd e2 on e1.First_Row = e2.NumOfSmthng;

drop table ldi_t_childd;
drop table ldi_t;
