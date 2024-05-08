--1
CREATE TABLE T_RANGE (
  id NUMBER,
  value VARCHAR2(100)
)
PARTITION BY RANGE (id)
(
  PARTITION p1 VALUES LESS THAN (10),
  PARTITION p2 VALUES LESS THAN (20),
  PARTITION p3 VALUES LESS THAN (45)
);

INSERT INTO T_RANGE (id, value) VALUES (5, 'Значение1');
INSERT INTO T_RANGE (id, value) VALUES (15, 'Значение2');
INSERT INTO T_RANGE (id, value) VALUES (44, 'Значение3');

COMMIT;

SELECT * FROM T_RANGE;

select * from  U1_LDI_PDB.T_RANGE partition(p1);

select * from  U1_LDI_PDB.T_RANGE partition(p2);

select * from  U1_LDI_PDB.T_RANGE partition(p3);


--SELECT tablespace_name
--FROM dba_data_files
--WHERE owner = 'U1_LDI_PDB';

--ALTER USER U1_LDI_PDB DEFAULT TABLESPACE USERS;
--alter user U1_LDI_PDB quota unlimited on users;
--commit;

--2


-- Создание таблицы T_INTERVAL с интервальным секционированием
CREATE TABLE T_INTERVAL (
  id NUMBER,
  date_column DATE
)
PARTITION BY RANGE (date_column)
INTERVAL(NUMTODSINTERVAL(1, 'DAY'))
(
  PARTITION d1 VALUES LESS THAN (TO_DATE('2023-01-01', 'YYYY-MM-DD')),
  PARTITION d2 VALUES LESS THAN (TO_DATE('2023-02-01', 'YYYY-MM-DD')),
  PARTITION d3 VALUES LESS THAN (TO_DATE('2023-10-01', 'YYYY-MM-DD'))
);

-- Вставка данных в таблицу T_INTERVAL
INSERT INTO T_INTERVAL (id, date_column) VALUES (1, TO_DATE('2022-01-15', 'YYYY-MM-DD'));
INSERT INTO T_INTERVAL (id, date_column) VALUES (2,  TO_DATE('2023-01-25', 'YYYY-MM-DD'));
INSERT INTO T_INTERVAL (id, date_column) VALUES (3, TO_DATE('2023-02-10', 'YYYY-MM-DD'));
COMMIT;

select * from T_INTERVAL partition(d1);
select * from T_INTERVAL partition(d2);
select * from T_INTERVAL partition(d3);

--3
CREATE TABLE T_HASH (
  id NUMBER,
  hash_key VARCHAR2(50)
)
PARTITION BY HASH (hash_key)
PARTITIONS 3;

-- Вставка данных в таблицу T_HASH
INSERT INTO T_HASH (id, hash_key) VALUES (1, 'Key1');
INSERT INTO T_HASH (id, hash_key) VALUES (2,  'Key2');
INSERT INTO T_HASH (id, hash_key) VALUES (3,  'Key3');
COMMIT;

select * from t_hash partition(sys_p422);

SELECT table_name, partition_name, high_value
FROM user_tab_partitions
WHERE table_name = 'T_HASH';

--4
-- Создание таблицы T_LIST со списочным секционированием
CREATE TABLE T_LIST (
  id NUMBER,
  char_key CHAR(1)
)
PARTITION BY LIST (char_key)
(
  PARTITION p1 VALUES ('A', 'B', 'C'),
  PARTITION p2 VALUES ('G'),
  PARTITION p3 VALUES (DEFAULT)
);

-- Вставка данных в таблицу T_LIST
INSERT INTO T_LIST (id, char_key) VALUES (1, 'A');
INSERT INTO T_LIST (id, char_key) VALUES (2, 'B');
INSERT INTO T_LIST (id, char_key) VALUES (3, 'G');
INSERT INTO T_LIST (id, char_key) VALUES (3, 'L');
COMMIT;

select * from T_LIST partition(p1);

select * from T_LIST partition(p2);

select * from T_LIST partition(p3);


--6

alter table T_RANGE enable row movement;

alter table T_INTERVAL enable row movement;

alter table T_HASH enable row movement;

alter table t_LIST enable row movement;

select * from T_RANGE partition(p1);
update T_RANGE set id = 17 where id = 5;
update T_RANGE set value = 'a' where id = 5;
--оператором update невозможно переместить данные из одной секции в другую

update T_INTERVAL set date_column = TO_DATE('2024-09-09', 'YYYY.MM.DD') where id = 1;

update T_HASH set hash_key = 'Key2' where id = 3;

update T_LIST set char_key = 'G' where id = 3;

--7
ALTER TABLE T_RANGE
MERGE PARTITIONS p1, p2
INTO PARTITION p_merged;

-- Проверка результата
SELECT PARTITION_NAME
FROM USER_TAB_PARTITIONS
WHERE TABLE_NAME = 'T_RANGE';

commit;

--8
ALTER TABLE T_RANGE
SPLIT PARTITION p3
AT (30)
INTO (PARTITION p3_1, PARTITION p3_2);

-- Проверка результата
SELECT PARTITION_NAME
FROM USER_TAB_PARTITIONS
WHERE TABLE_NAME = 'T_RANGE';
commit;

--9
CREATE TABLE T_EXCHANGE (
  id NUMBER,
  value VARCHAR2(100)
);

select * from T_EXCHANGE;

ALTER TABLE T_RANGE
EXCHANGE PARTITION p3_2
WITH TABLE T_EXCHANGE;

select * from T_EXCHANGE;
commit;

--10

--10.1
SELECT TABLE_NAME
FROM USER_TAB_PARTITIONS;

--10.2
SELECT PARTITION_NAME
FROM USER_TAB_PARTITIONS
WHERE TABLE_NAME = 'T_RANGE';

--10.3
select * from T_LIST partition(p1);

--10.4
SELECT *
FROM T_LIST
WHERE char_key = 'A';
