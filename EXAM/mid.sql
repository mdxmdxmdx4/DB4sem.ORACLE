--1. Создайте процедуру, которая выводит список заказов и их итоговую стоимость для определенного покупателя. 
--   Параметр – наименование покупателя. Обработайте возможные ошибки.
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


--2. Создайте функцию, которая подсчитывает количество заказов покупателя за определенный период.
--   Параметры – покупатель, дата начала периода, дата окончания периода.
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

--3 Создайте процедуру, которая выводит список всех товаров, приобретенных покупателем, с указанием суммы продаж по возрастанию.
--  Параметр – наименование покупателя. Обработайте возможные ошибки.
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


--4 Создайте функцию, которая добавляет покупателя в таблицу Customers, и возвращает код добавленного покупателя или -1 в случае ошибки.
--  Параметры соответствуют столбцам таблицы, кроме кода покупателя, который задается при помощи последовательности.
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


--5. Создайте процедуру, которая выводит список покупателей, в порядке убывания общей стоимости заказов.
--   Параметры – дата начала периода, дата окончания периода. Обработайте возможные ошибки.

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

--6.  Создайте функцию, которая подсчитывает количество заказанных товаров за определенный период. Параметры – дата начала периода, дата окончания периода.
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

--7 Создайте процедуру, которая выводит список покупателей, у которых есть заказы в этом временном периоде.
--  Параметры – дата начала периода, дата окончания периода. Обработайте возможные ошибки
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


--8 Создайте функцию, которая подсчитывает количество покупателей определенного товара. Параметры – наименование товара.
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


--9 Создайте процедуру, которая увеличивает на 10% стоимость определенного товара. Параметр – наименование товара. Обработайте возможные ошибки
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

--10 Создайте функцию, которая вычисляет количество заказов, выполненных в определенном году для определенного покупателя. Параметры – покупатель, год. товара.
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
