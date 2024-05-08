--1
SELECT name FROM sqlite_master

--2
--2.1
select * from CUSTOMERS;
select * from orders;


CREATE VIEW Rich_purchases as 
select c.COMPANY, o.AMOUNT from CUSTOMERS c
inner join orders o on o.CUST = c.CUST_NUM
where o.AMOUNT > 20000;

select * from Rich_purchases;

--2.2
select * from SALESREPS;
select * from OFFICES;

create view Empls_offices as
select s.NAME,o.city, o.REGION
from OFFICES o
inner join SALESREPS s on o.OFFICE = s.REP_OFFICE;

select * from Empls_offices;

--2.3
create view ordrs_2008 as
select * from ORDERS
where ORDER_DATE like '2008%'

select * from ordrs_2008;

--2.4
CREATE view no_orders_empls as
SELECT *
FROM SALESREPS
WHERE EMPL_NUM NOT IN (
    SELECT DISTINCT REP
    FROM ORDERS
);

select * from no_orders_empls;

--2.5
CREATE view Products_popularity as
select p.DESCRIPTION, count(p.DESCRIPTION) as 'Ordered_count' from orders o inner join 
PRODUCTS p  on o.PRODUCT = p.PRODUCT_ID
GROUP by p.DESCRIPTION;

select * from Products_popularity;

--3
create TEMPORARY TABLE temp_test
(frst_col int);

insert into temp_test 
VALUES(3);

select * from temp_test;


--4
CREATE TEMPORARY view temp_view_orders_test as
select * from orders;

select * from temp_view_orders_test;

--5
--запрос 3.14
explain query plan
select DISTINCT NAME
from ORDERs
inner join SALESREPS ON ORDERS.REP = SALESREPS.EMPL_NUM
where ORDErs.AMOUNT > 10000;

create index 'idx_names_more_ten' on 'ORDERS'(
'AMOUNT'
) where AMOUNT > 10000;

drop index 'idx_names_more_ten' ;

--запрос 3.16
explain query plan
select MFR_ID,max(price) as MAX_PRICE 
from PRODUCTS
group by MFR_ID;

create index 'idx_products_group' on 'PRODUCTS'(
'MFR_ID');
drop index idx_products_group;

--запрос 3.19
explain QUERY PLAN
SELECT *
FROM SALESREPS
WHERE AGE IN (
    SELECT AGE
    FROM SALESREPS
    GROUP BY AGE
    HAVING COUNT(*) > 1
);

CREATE INDEX idx_salesreps_age ON SALESREPS (AGE);

drop index idx_salesreps_age;

--Запрос 3.20
explain QUERY plan
select DESCRIPTION
from ORDERS inner join CUSTOMERS on CUST = CUST_NUM
inner join PRODUCTS on PRODUCT = PRODUCT_ID
where company = 'First Corp.';


	CREATE INDEX idx_customers_company ON CUSTOMERS (company);
	
	CREATE INDEX idx_orders_cust ON ORDERS (CUST);

	
--Запрос 3.24
EXPLAIN QUERY plan
select REP_OFFICE, sum(AMOUNT) as AMOUNT_SALES
from ORDERS inner join  SALESREPS on EMPL_NUM = rep
group by REP_OFFICE
having REP_OFFICE is not null
order by AMOUNT_SALES desc

select  * from orders;

create index idx_rep_off_gr on SALESREPS(REP_OFFICE);
CREATE INDEX idx_orders_rep ON ORDERS (rep);

DROP index idx_rep_off_gr;
DROP index idx_orders_rep;


--Запрос 3.35
explain QUERY plan
SELECT c.COMPANY
FROM CUSTOMERS c
JOIN ORDERS o ON c.CUST_NUM = o.CUST
WHERE strftime('%Y', o.ORDER_DATE) = '2008'
      AND c.COMPANY IN (
          SELECT c2.COMPANY
          FROM CUSTOMERS c2
          JOIN ORDERS o2 ON c2.CUST_NUM = o2.CUST
          WHERE strftime('%Y', o2.ORDER_DATE) = '2007'
      )
GROUP BY c.COMPANY;

CREATE INDEX idx_orders_order_date ON ORDERS (ORDER_DATE);

drop index idx_orders_order_date;

--6
CREATE TABLE AUDIT (
  AUDIT_ID INTEGER PRIMARY KEY,
  TABLE_NAME TEXT NOT NULL,
  CHANGE_DATE DATETIME NOT NULL,
  PREVIOUS_DATA TEXT
);

CREATE TRIGGER salesreps_trigger AFTER UPDATE ON SALESREPS
BEGIN
  INSERT INTO AUDIT (TABLE_NAME, CHANGE_DATE, PREVIOUS_DATA)
  VALUES ('SALESREPS', DATETIME('now'), (SELECT old.NAME FROM SALESREPS AS old WHERE old.EMPL_NUM = NEW.EMPL_NUM));
END;


drop TRIGGER salesreps_trigger;

UPDATE SALESREPS
SET NAME = 'Max Dvorov'
WHERE EMPL_NUM = 101;

select * from AUDIT;

--7

CREATE TRIGGER empls_offices_trigger INSTEAD OF INSERT ON Empls_offices
BEGIN

INSERT INTO OFFICES (OFFICE, CITY, REGION, MGR, TARGET, SALES)
  SELECT 23, NEW.CITY, NEW.REGION, 106, 888888, 777777;
  
  INSERT INTO SALESREPS (EMPL_NUM, NAME, AGE, REP_OFFICE, TITLE, HIRE_DATE, MANAGER, QUOTA, SALES)
  SELECT 199, NEW.NAME, 35, 23, 'Sales Rep', date('now'), 106, 200000, 188000;
END;

INSERT INTO Empls_offices (NAME, CITY, REGION)
VALUES ('Denis', 'Minsk', 'Eastern');


--8
begin EXCLUSIVE TRANSACTION;
insert into SALESREPS values(133, 'Ilya Korobkin', 24, 23, 'Sales Rep', date('now'),106, 500000, 450000);
UPDATE  SALESREPS set NAME = 'Bogdan Vasilenko' where SALESREPS.EMPL_NUM = 133;
commit ;

--9
begin TRANSACTION A;
UPDATE ORDERS set CUST = 2111 where ORDER_NUM = 112961;
begin TRANSACTION B;
update orders  set CUST = 2111 where ORDER_NUM = 112963;
COMMIT TRANSACTION B;
COMMIT TRANSACTION A;

--10
begin TRANSACTION A;
UPDATE ORDERS set CUST = 2111 where ORDER_NUM = 112961;
SAVEPOINT A;
update orders  set CUST = 2111 where ORDER_NUM = 112963;
RELEASE SAVEPOINT A
COMMIT TRANSACTION A;

begin TRANSACTION A;
UPDATE ORDERS set CUST = 2111 where ORDER_NUM = 112961;
SAVEPOINT A;
update orders  set CUST = 2111 where ORDER_NUM = 112963;
ROLLBACK to SAVEPOINT A
COMMIT TRANSACTION A;