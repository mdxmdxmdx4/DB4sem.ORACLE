--low level
--1
select * from v$sga;

SELECT *
FROM v$sgainfo;

select * from v$sgastat;

--2
select * from v$parameter;

--3
select * from v$controlfile;

--4
create pfile='pxx1.ora' from spfile;

--5
create table xmpltbl(
ident number primary key,
descript varchar2(10) not null
);

insert into xmpltbl values(1,'asdad');
insert into xmpltbl values(2,'qpowo');

SELECT *
FROM user_segments
WHERE segment_type = 'TABLE' and segment_name = 'XMPLTBL';

--6
select * from v$process;

select * from v$process where background = 1;


select * from v$session;

select 
p.pid, p.username, s.sid, s.server
from
v$session s join v$process p on s.paddr = p.addr;

--7
select * from dba_tablespaces;

SELECT tablespace_name, file_id, file_name, bytes, status 
FROM dba_data_files;

--8
select * from dba_roles;

--9
select * from dba_role_privs where grantee = 'samplerole123';

--10
select * from dba_users;

--11
create role samplerole123;

--12
create user Leshuk_DM identified by 12345
default tablespace USERS quota unlimited on USERS
TEMPORARY tablespace TEMP 
account unlock;

--13
select * from dba_profiles;

--14

select * from dba_profiles where profile = 'PF_LDICORE';

--15
CREATE PROFILE PF_LDICORE limit
password_life_time 180
sessions_per_user 3
FAILED_LOGIN_ATTEMPTS 7
PASSWORD_LOCK_TIME 1
PASSWORD_REUSE_TIME 10
PASSWORD_GRACE_TIME default
connect_time 180
idle_time 30;


--16
create sequence s1 
start with 1000
increment by 10
minvalue 0
maxvalue 10000
cycle 
cache 30
order;

create table lorem(
for_seq number,
for_seq2 number,
for_seq3 number);

insert INTO lorem values (s1.NEXTVAL,s1.NEXTVAL,s1.NEXTVAL);

select * from lorem;

--17
create synonym this_is_synonym for lorem;
create public synonym smthng for lorem;

select * from this_is_synonym; 
select * from smthng;

select * from dba_synonyms where synonym_name = 'THIS_IS_SYNONYM';
select * from dba_synonyms where synonym_name = 'SMTHNG';

--18
select * from v$logfile;

--19
select * from v$log where status = 'CURRENT';

--20
select * from v$controlfile;


--21
select * from dba_segments where tablespace_name = 'USERS';


--22
select * from user_objects;


--23
SELECT blocks
FROM user_tables
WHERE table_name = 'XMPLTBL';

--или это
SELECT *
FROM user_segments
WHERE segment_type = 'TABLE' and segment_name = 'XMPLTBL';


--24
select * from v$session;

--25
SELECT log_mode FROM v$database;

--26
create view my_view as
select * from lorem
where for_seq > 1010;

select * from my_view;

--27
create database link topdb
connect to system
identified by system
USING '(
  DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 80.94.168.150)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = ora12w)
    )
)';


select * from asd@topdb;


--low level end
select * from orders;
select * from customers;

--mid level
--1
create or replace procedure ORDERS_CNT_AND_PRICE(
company_name in varchar2,
res_list out sys_refcursor
)
as
v_result_price number;
begin

open res_list for 
select order_num, order_date, company, amount
from orders inner join customers on orders.cust = customers.cust_num
where company = company_name;

select sum(amount) into v_result_price from 
orders inner join customers on orders.cust = customers.cust_num
where company = company_name;
dbms_output.put_line('Result orders price:');
dbms_output.put_line(v_result_price);

exception
  when no_data_found then
    dbms_output.put_line('No data found for company: ' || company_name);
  when others then
    dbms_output.put_line('An error occurred');
end;

set serveroutput on;


var res_list refcursor;
EXEC ORDERS_CNT_AND_PRICE(NULL,:res_list);
PRINT res_list;


--2
select * from orders;
select * from customers;

create or replace function ORDERS_QTY_BY_DATE(
  company_name varchar2,
  date_start date,
  date_end date
)
return integer
is
  v_res_count number := 0;
begin
  select count(*) into v_res_count
  from orders
  join customers on orders.cust = customers.cust_num
  where customers.company = company_name
  and orders.order_date between date_start and date_end;
  
  return v_res_count;
end;

declare v_result integer;
begin 
v_result := ORDERS_QTY_BY_DATE('Holm Landis',to_date('2006.01.01','YYYY-MM-DD'), to_date('2009.01.01', 'YYYY-MM-DD'));
dbms_output.put_line('Order quantity: ' || v_result);
end;

--3
select * from products
select * from orders;
select * from customers;

create or replace procedure orders_list(
v_company varchar2,
res_list OUt sys_refcursor
)
as
begin
open res_list 
for select order_date, products.description, amount from 
customers join orders on orders.cust = customers.cust_num
join products on orders.product = products.product_id
where customers.company = v_company
order by orders.amount desc;
end;

var res_list refcursor
exec orders_list('Rico Enterprises',:res_list);
print res_list;


--4
create sequence special_add
start with 2222
increment by 1
minvalue 2000
maxvalue 3000
nocycle;


select * from customers;

create or replace function CUSTOMERS_ADD(
v_company varchar2,
v_cust_rep number,
v_credit_limit number
)
return integer
is
v_res_code number := 0; 
begin

select special_add.NEXTVAL into  v_res_code from dual;

insert into Customers values (v_res_code, v_company,v_cust_rep,v_credit_limit);
return v_res_code;

EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
end;

declare iii integer;
begin
iii := CUSTOMERS_ADD('NotDinii Inc.',101, 80000);
dbms_output.put_line('Result is ' || iii);
end;

--5
create or replace procedure Customers_amount_desc(
start_period_date date,
end_period_date date,
v_result_list out sys_refcursor
)
as
begin
open v_result_list for
select company, sum(amount)
from orders join customers
on orders.cust = customers.cust_num
where order_date between start_period_date and end_period_date
group by company
order by 2 desc;
end;

var v_res_list refcursor
exec Customers_amount_desc(to_date('2007.06.01','YYYY.MM.DD'),to_date('2008.01.01','YYYY.MM.DD'),:v_res_list);
print v_res_list;

--6
create or replace function orders_count_by_period(
start_date date,
end_date date
)
return numeric
is
v_res_count number :=0;
begin
select count(*) into v_res_count
from orders where
order_date between start_date and end_date;
return v_res_count;
end;

declare asd numeric;
begin
asd := orders_count_by_period(to_date('2007.06.01','YYYY.MM.DD'),to_date('2008.01.01','YYYY.MM.DD'));
dbms_output.put_line(asd);
end;

--7
create or replace procedure Customers_makes_orders_list(
start_date date,
end_date date,
v_res_list out sys_refcursor
)
as
begin
open v_res_list for
select distinct company 
from orders join customers on customers.cust_num = orders.cust
where order_date between start_date and end_date;
end;


var res_list refcursor
exec Customers_makes_orders_list(to_date('2007.06.01','YYYY.MM.DD'),to_date('2008.01.01','YYYY.MM.DD'),:res_list);
print res_list;


--8
create function Orders_by_product(
v_description varchar2
)
return numeric
is
v_res_count number := 0;
begin
select count(*) into v_res_count
from orders inner join products on products.product_id = orders.product
where products.description = v_description;
return v_res_count;
end;



declare res_c numeric;
begin
res_c := Orders_by_product('Brace Retainer');
dbms_output.put_line(res_c);
end;


--9
select * from products;


create or replace procedure Price_increacement(
v_prod_id varchar2
)
as
v_curr_price number :=0; 
begin
select price into v_curr_price from products where product_id = v_prod_id;
update products set price = v_curr_price * 1.1 where product_id = v_prod_id;
exception
when others then
dbms_output.put_line('An error occured!');
end;


select * from customers;
select * from products;
select * from orders;
exec Price_increacement('XK47');

--10
create or replace function Concrete_cust_orders_num(
v_yearr number,
v_company varchar2
)
return numeric 
is 
v_res_count numeric :=0;
begin
select count(order_num) into v_res_count
from orders  join customers on customers.cust_num = orders.cust
where EXTRACT(year from order_date) = v_yearr and company = v_company; 
return v_res_count;
end;

declare num_result numeric;
begin
num_result := Concrete_cust_orders_num(2007,'Midwest Systems');
dbms_output.put_line(num_result);
end;


--mid level end

--high level
--1
select * from orders;

select * from products;

create or replace procedure add_order(
v_order_num number,
v_order_date date,
v_cust number,
v_rep number,
v_mfr varchar2,
v_product varchar2,
v_qty number,
v_price decimal
)
as
begin
insert into orders values (v_order_num, v_order_date, v_cust, v_rep, v_mfr, v_product, v_qty, v_price);

commit;
exception
when others then
dbms_output.put_line('An error occurred: ' || SQLERRM); -- Вывод подробной информации об ошибке
end;


exec add_order(222000,to_date('2023.01.01','YYYY-MM-DD'), 2117, 101,'QSA','XK47',10,12);

--insert into orders values(210000,to_date('2023.01.01','YYYY-MM-DD'), 2117, 101,'QSA','XK47',10,12391.12);


create or replace trigger insertation_order_check 
before insert on Orders
for each row 
declare
v_product_qty number
begin
 SELECT QTY_ON_HAND INTO v_product_qty
    FROM PRODUCTS
    WHERE MFR_ID = :NEW.MFR
      AND PRODUCT_ID = :NEW.PRODUCT;

    IF v_product_qty IS NULL OR v_product_qty < :NEW.QTY THEN
        -- Выбрасываем исключение, если товар не найден или количество недостаточно
        RAISE_APPLICATION_ERROR(-20001,  ' Invalid product or insufficient quantity' );
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
        -- Выбрасываем исключение для любых других ошибок
        RAISE_APPLICATION_ERROR(-20003,  'An error occurreda: '  || SQLERRM);
END;


--2
CREATE OR REPLACE FUNCTION COUNT_ORDERS_BY_C(
    p_customer VARCHAR2,
    p_start_date DATE,
    p_end_date DATE
)
RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT TO_CHAR(O.ORDER_DATE,   'YYYY-MM' ) AS MONTH,
               COUNT(*) AS ORDER_COUNT
        FROM ORDERS O
        JOIN CUSTOMERS C ON O.CUST = C.CUST_NUM
        WHERE C.COMPANY = p_customer
          AND O.ORDER_DATE >= p_start_date
          AND O.ORDER_DATE <= p_end_date
        GROUP BY TO_CHAR(O.ORDER_DATE,  'YYYY-MM' )
        ORDER BY TO_CHAR(O.ORDER_DATE,   'YYYY-MM' );

    RETURN v_cursor;
EXCEPTION
    WHEN OTHERS THEN
        -- В случае ошибки, закрываем курсор и выбрасываем исключение
        IF v_cursor IS NOT NULL THEN
            CLOSE v_cursor;
        END IF;
        RAISE;
END;


DECLARE
    v_result SYS_REFCURSOR;
    v_month VARCHAR2(7);
    v_order_count NUMBER;
BEGIN
    v_result := COUNT_ORDERS_BY_C('JCP Inc.', DATE   '2007-01-01' , DATE   '2023-12-31' );

    -- Извлекаем данные из курсора и выводим результат
    LOOP
        FETCH v_result INTO v_month, v_order_count;
        EXIT WHEN v_result%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( ' Month: '  || v_month ||  ', Order Count: '  || v_order_count);
    END LOOP;

    -- Закрываем курсор
    CLOSE v_result;
END;

SET serveroutput on;

--3
create or replace procedure not_solded_product(
v_year number,
v_res_list out sys_refcursor
)
as
begin
open v_res_list for
select * from products p
where not exists (
select * from orders o where extract(year from order_date) = v_year
and O.MFR = P.MFR_ID AND O.PRODUCT = P.PRODUCT_ID
)
order by qty_on_hand desc;
end;

var res_list refcursor
exec not_solded_product(2008,:res_list);
print res_list;


--4
CREATE OR REPLACE FUNCTION Orders_by_year(
    p_year NUMBER,
    p_customer_name VARCHAR2
)
RETURN NUMBER
IS
    v_order_count NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_order_count
    FROM ORDERS O
    JOIN CUSTOMERS C ON O.CUST = C.CUST_NUM
    where extract(year from o.order_date) = p_year and c.company = p_customer_name;

    RETURN v_order_count;
EXCEPTION
    WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE( 'Error: ' || SQLERRM);
END;



DECLARE
    v_order_count NUMBER;
BEGIN
    v_order_count := Orders_by_year(2008,  'Midwest Systems');
    dbms_output.put_line(v_order_count);
END;


--5
create or replace procedure sort_table_data(
p_column_name varchar2,
p_sort_order varchar2,
v_cursor out sys_refcursor
)
as
v_sql_query varchar2(100);
v_mfr_id products.product_id%TYPE;
v_product_id products.product_id%TYPE;
v_description products.description%TYPE;
v_price PRODUCTS.PRICE%TYPE;
v_qty_on_hand PRODUCTS.QTY_ON_HAND%TYPE;
begin
SELECT COUNT(*)
INTO v_sql_query
FROM user_tab_cols
WHERE table_name = 'PRODUCTS'
AND column_name = p_column_name;

IF v_sql_query = 0 THEN
RAISE_APPLICATION_ERROR(-20001, 'Указанный столбец не существует в таблице');
END IF;

v_sql_query :=
'SELECT MFR_ID, PRODUCT_ID, DESCRIPTION, PRICE, QTY_ON_HAND
FROM PRODUCTS
ORDER BY ' || p_column_name || ' ' || p_sort_order;

OPEN v_cursor FOR v_sql_query;

LOOP
FETCH v_cursor INTO v_mfr_id, v_product_id, v_description, v_price, v_qty_on_hand;
EXIT WHEN v_cursor%NOTFOUND;

DBMS_OUTPUT.PUT_LINE(
'MFR_ID: ' || v_mfr_id ||
', PRODUCT_ID: ' || v_product_id ||
', DESCRIPTION: ' || v_description ||
', PRICE: ' || v_price ||
', QTY_ON_HAND: ' || v_qty_on_hand
);
END LOOP;


CLOSE v_cursor;
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END;

exec sort_table_data('PRICE', 'DESC',:v_asd);
