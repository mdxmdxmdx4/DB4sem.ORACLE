-- Таблица сотрудников (номер, имя, ставка за месяц, номер начальника, отдел) 
CREATE TABLE emp (
        empno NUMBER(4), 
        ename VARCHAR2(15), 
        sal NUMBER(6,2),
        mgr NUMBER(4),
        deptno NUMBER (2));

INSERT INTO EMP VALUES (7839,'KING',5000, null, 10);
INSERT INTO EMP VALUES (7698,'BLAKE',2750, 7839, 10);
INSERT INTO EMP VALUES (7782,'CLARK',2450, 7839, 10);
INSERT INTO EMP VALUES (7566,'JONES',295, 7698, 20);
INSERT INTO EMP VALUES (7654,'MARTIN',1250, 7566, 30);
INSERT INTO EMP VALUES (7499,'ALLEN',1600, 7566, 20);
INSERT INTO EMP VALUES (7844,'TURNER', 1500, 7698, 30);
INSERT INTO EMP VALUES (7900,'JAMES', 950, 7839, 20);
INSERT INTO EMP VALUES (7521,'WARD', 1250,7844, 20);
INSERT INTO EMP VALUES (7902,'FORD',3000, 7521, 10);
INSERT INTO EMP VALUES (7369,'SMITH', 700, 7499, 20);
INSERT INTO EMP VALUES (7788,'SCOTT', 3000, 7698, 30);
INSERT INTO EMP VALUES (7876,'ADAMS',1100, 7788, 30);
INSERT INTO EMP VALUES (7934,'MILLER',1300, 7788, 10);
COMMIT;

ALTER SESSION SET  NLS_DATE_FORMAT = 'YYYY-MM-DD';
-- Таблица дополнительных выплат сотрудников (номер сотрудника, дата выплаты, сумма)
CREATE TABLE emp_payment (
        empno NUMBER(4),
        payment_date DATE, 
        amount NUMBER(6,2));

INSERT INTO emp_payment VALUES (7839,'2023-01-01',1000);
INSERT INTO emp_payment VALUES (7839,'2023-01-03',1000);
INSERT INTO emp_payment VALUES (7839,'2023-02-01',1000);
INSERT INTO emp_payment VALUES (7839,'2023-02-03',1000);
INSERT INTO emp_payment VALUES (7698,'2023-01-01',275);
INSERT INTO emp_payment VALUES (7698,'2023-01-07',275);
INSERT INTO emp_payment VALUES (7698,'2023-02-01',275);
INSERT INTO emp_payment VALUES (7698,'2023-02-07',275);
INSERT INTO emp_payment VALUES (7782,'2023-01-01',245);
INSERT INTO emp_payment VALUES (7782,'2023-01-06',245);
INSERT INTO emp_payment VALUES (7782,'2023-01-09',245);
INSERT INTO emp_payment VALUES (7566,'2023-01-01',295);
INSERT INTO emp_payment VALUES (7566,'2023-01-09',295);
INSERT INTO emp_payment VALUES (7566,'2023-04-01',295);
INSERT INTO emp_payment VALUES (7566,'2023-03-09',295);
INSERT INTO emp_payment VALUES (7654,'2023-01-01',125);
INSERT INTO emp_payment VALUES (7654,'2023-01-02',125);
INSERT INTO emp_payment VALUES (7499,'2023-01-01',160);
INSERT INTO emp_payment VALUES (7844,'2023-01-01', 150);
INSERT INTO emp_payment VALUES (7900,'2023-01-01', 950);
INSERT INTO emp_payment VALUES (7521,'2023-01-01', 125);
INSERT INTO emp_payment VALUES (7902,'2023-01-01',300);
INSERT INTO emp_payment VALUES (7902,'2023-01-02',300);
INSERT INTO emp_payment VALUES (7902,'2023-02-01',300);
INSERT INTO emp_payment VALUES (7902,'2023-02-02',300);
INSERT INTO emp_payment VALUES (7902,'2023-03-01',300);
INSERT INTO emp_payment VALUES (7902,'2023-03-02',300);
INSERT INTO emp_payment VALUES (7369,'2023-01-01', 700);
INSERT INTO emp_payment VALUES (7788,'2023-01-01', 300);
INSERT INTO emp_payment VALUES (7876,'2023-01-01',110);
INSERT INTO emp_payment VALUES (7934,'2023-01-01',130);
COMMIT;


-- Таблица имеющихся банкнот
CREATE TABLE bank
    (banknote number(3));

INSERT INTO bank VALUES (100);
INSERT INTO bank VALUES (50);
INSERT INTO bank VALUES (20);
INSERT INTO bank VALUES (10);
INSERT INTO bank VALUES (5);
INSERT INTO bank VALUES (2);
INSERT INTO bank VALUES (1);
COMMIT;

-- Таблица больничных листов (номер заболевшего, с какого числа отсутствует, до какого числа отсутствует)
CREATE TABLE sick_day   
            (empno number(4),   
             date_from date,   
             date_to date);

INSERT INTO sick_day VALUES (7839,'2023-04-01','2023-04-03');
INSERT INTO sick_day VALUES (7839,'2023-04-09','2023-04-11');
INSERT INTO sick_day VALUES (7839,'2023-04-29','2023-05-01');
INSERT INTO sick_day VALUES (7698,'2023-04-05','2023-04-06');
INSERT INTO sick_day VALUES (7698,'2023-04-09','2023-04-10');
INSERT INTO sick_day VALUES (7698,'2023-04-28','2023-05-02');
INSERT INTO sick_day VALUES (7782,'2023-04-07','2023-04-07');
INSERT INTO sick_day VALUES (7782,'2023-04-09','2023-04-09');
INSERT INTO sick_day VALUES (7566,'2023-04-03','2023-04-07');
INSERT INTO sick_day VALUES (7654,'2023-04-09','2023-04-09');
INSERT INTO sick_day VALUES (7499,'2023-04-12','2023-04-17');
INSERT INTO sick_day VALUES (7844,'2023-04-19','2023-04-19');
INSERT INTO sick_day VALUES (7900,'2023-04-13','2023-04-19');
INSERT INTO sick_day VALUES (7521,'2023-04-19','2023-05-09');
COMMIT;


select * from emp;
select * from emp_payment;
select * from bank;
select * from sick_day;

--1
SELECT empno, ename,
  CASE
    WHEN CONNECT_BY_ISLEAF = 0 AND LEVEL > 1 THEN 'Inner'
    WHEN CONNECT_BY_ISLEAF = 1 THEN 'Leaf'
    ELSE 'Root'
  END AS status
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;


--2
SET SERVEROUTPUT ON;

DECLARE
  sal_list VARCHAR2(100);
  i        NUMBER := 1;
BEGIN
  SELECT LISTAGG(sal, '') WITHIN GROUP (ORDER BY empno)
  INTO sal_list
  FROM emp;
  
  FOR i IN 1..9 LOOP
    IF INSTR(sal_list, i) = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Output');
      DBMS_OUTPUT.PUT_LINE(i);
    END IF;
  END LOOP;
END;

--3
SELECT empno
FROM emp_payment
WHERE EXTRACT(MONTH FROM payment_date) IN (1,2)
GROUP BY empno
HAVING COUNT(DISTINCT EXTRACT(MONTH FROM payment_date)) = 2
AND COUNT(*) >= 2;


--4
SELECT empno, MAX(payment_date) AS glory_date
FROM (
    SELECT empno, payment_date, 
           COUNT(*) OVER (PARTITION BY empno, EXTRACT(MONTH FROM payment_date)) AS cnt
    FROM emp_payment
) t
WHERE cnt >= 2
GROUP BY empno, EXTRACT(MONTH FROM payment_date)
HAVING COUNT(*) >= 2;

--5
WITH total_payments AS (
  SELECT empno, SUM(amount) AS total_amount
  FROM emp_payment
  GROUP BY empno
)
SELECT t1.empno AS first_emp, t1.total_amount AS first_amount, t2.empno AS second_emp, t2.total_amount AS second_amount, ABS(t1.total_amount - t2.total_amount) AS amount_diff
FROM total_payments t1
JOIN total_payments t2 ON t1.total_amount <= t2.total_amount + 5 AND t1.total_amount >= t2.total_amount - 5 AND t1.empno < t2.empno
ORDER BY amount_diff ASC;
    
    select * from emp_payment;
    
--6
SELECT deptno, (COUNT(CASE WHEN sal > 1500 THEN 1 END) / COUNT(*)) * 100 AS percentage
FROM emp
GROUP BY deptno
HAVING COUNT(*) >= 3
ORDER BY percentage DESC
FETCH FIRST ROW ONLY;

--7
SELECT empno, MAX(amount_3) AS max_3_amount
FROM (
  SELECT empno, 
         SUM(amount) OVER (PARTITION BY empno ORDER BY payment_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS amount_3
  FROM emp_payment
)
GROUP BY empno
HAVING count(*) >= 3;


select *  from emp;

--8
SELECT empno, MAX(amount_3) AS max_3_sequence_amount
FROM (
  SELECT empno, 
         SUM(amount) OVER (PARTITION BY empno ORDER BY payment_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS amount_3,
         COUNT(*) OVER (PARTITION BY empno ORDER BY payment_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS cnt
  FROM emp_payment
)
WHERE cnt = 3
GROUP BY empno;

--9    -ne sdelal

select * from emp;
select * from sick_day;

--10
SELECT e.empno, e.ename, e.sal, 
    TO_CHAR(SYSDATE, 'MM') as current_month,
    SUM(sd.date_to - sd.date_from + 1) as sick_days_per_month,
    ROUND(e.sal / TO_NUMBER(TO_CHAR(LAST_DAY(SYSDATE), 'DD')) *
        (TO_NUMBER(TO_CHAR(LAST_DAY(SYSDATE), 'DD')) - COUNT(sd.empno))) as to_pay
FROM emp e
LEFT JOIN sick_day sd ON e.empno = sd.empno
WHERE TO_CHAR(sd.date_from, 'MM') = TO_CHAR(SYSDATE, 'MM')
   OR TO_CHAR(sd.date_to, 'MM') = TO_CHAR(SYSDATE, 'MM')
GROUP BY e.empno, e.ename, e.sal;