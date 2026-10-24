mysql> USE COMPANY;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> CREATE TABLE EMPLOYEE ( Emp_no INT PRIMARY KEY, E_name VARCHAR(50), E_address VARCHAR(100), E_ph_no VARCHAR(15), Dept_no INT,    Dept_name VARCHAR(50), Job_id CHAR(10), Salary DECIMAL(10, 2)); 
ERROR 1050 (42S01): Table 'EMPLOYEE' already exists
mysql> Describe EMPLOYEE; 
+-----------+---------------+------+-----+---------+-------+
| Field     | Type          | Null | Key | Default | Extra |
+-----------+---------------+------+-----+---------+-------+
| E_no      | int           | NO   | PRI | NULL    |       |
| E_name    | varchar(50)   | NO   |     | NULL    |       |
| E_address | varchar(100)  | YES  |     | NULL    |       |
| E_ph_no   | varchar(15)   | YES  | UNI | NULL    |       |
| Dept_no   | int           | YES  |     | NULL    |       |
| Dept_name | varchar(50)   | YES  |     | NULL    |       |
| Job_id    | varchar(20)   | YES  |     | NULL    |       |
| Salary    | decimal(10,2) | YES  |     | NULL    |       |
| HIREDATE  | date          | YES  |     | NULL    |       |
+-----------+---------------+------+-----+---------+-------+
9 rows in set (0.00 sec)

mysql> ALTER TABLE EMPLOYEE ADD HIREDATE DATE; 
ERROR 1060 (42S21): Duplicate column name 'HIREDATE'
mysql> ALTER TABLE EMPLOYEE MODIFY Job_id VARCHAR(10); 
Query OK, 0 rows affected (0.11 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE EMPLOYEE RENAME COLUMN Emp_no TO E_no; 
ERROR 1054 (42S22): Unknown column 'Emp_no' in 'EMPLOYEE'
mysql> ALTER TABLE EMPLOYEE MODIFY Job_id VARCHAR(20); 
Query OK, 0 rows affected (0.01 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE EMPLOYEE MODIFY Job_id VARCHAR(20); 
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE EMPLOYEE ADD CONSTRAINT UQ_E_ph_no UNIQUE (E_ph_no); 
ERROR 1061 (42000): Duplicate key name 'UQ_E_ph_no'
mysql> ALTER TABLE EMPLOYEE MODIFY E_name VARCHAR(50) NOT NULL; 
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE EMPLOYEE ADD CONSTRAINT CHK_Salary 
    -> 
    -> CHECK(Salary > 0); 
ERROR 3822 (HY000): Duplicate check constraint name 'CHK_Salary'.
mysql> INSERT INTO EMPLOYEE (E_no, E_name, E_address, E_ph_no, Dept_no, Dept_name, Job_id, Salary, HIREDATE)VALUES (1, 'John Doe', '123 Main St', '555-1234', 101, 'Sales', 'J1001', 50000.00, '20-08-24'); 
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO EMPLOYEE (E_no, E_name, E_address, E_ph_no, Dept_no, Dept_name, Job_id, Salary, HIREDATE)VALUES (2, 'Jane Smith', '456 Oak St', '555-5678', 102, 'Marketing', 'J1002', 60000.00, '4-06-18'); 
Query OK, 1 row affected (0.00 sec)

mysql> 
mysql> 
mysql> INSERT INTO EMPLOYEE (E_no, E_name, E_address, E_ph_no, Dept_no, Dept_name, Job_id, Salary, HIREDATE)VALUES (4, 'Alice Bob', '112 Apple St', '555-1112', 104, 'ADMIN', 'J1004', 45000.00, '4-03-15'); 
Query OK, 1 row affected (0.00 sec)

mysql> 
mysql> 
mysql> INSERT INTO EMPLOYEE (E_no, E_name, E_address, E_ph_no, Dept_no, Dept_name, Job_id, Salary, HIREDATE)VALUES (4, 'Alice Bob', '112 Apple St', '555-1112', 104, 'ADMIN', 'J1004', 45000.00, '4-03-15'); 
ERROR 1062 (23000): Duplicate entry '4' for key 'EMPLOYEE.PRIMARY'
mysql> 
mysql> 
mysql> SELECT * FROM EMPLOYEE; 
+------+------------+--------------+----------+---------+-----------+--------+----------+------------+
| E_no | E_name     | E_address    | E_ph_no  | Dept_no | Dept_name | Job_id | Salary   | HIREDATE   |
+------+------------+--------------+----------+---------+-----------+--------+----------+------------+
|    1 | John Doe   | 123 Main St  | 555-1234 |     101 | Sales     | J1001  | 50000.00 | 2020-08-24 |
|    2 | Jane Smith | 456 Oak St   | 555-5678 |     102 | Marketing | J1002  | 60000.00 | 0004-06-18 |
|    4 | Alice Bob  | 112 Apple St | 555-1112 |     104 | ADMIN     | J1004  | 45000.00 | 0004-03-15 |
+------+------------+--------------+----------+---------+-----------+--------+----------+------------+
3 rows in set (0.00 sec)

mysql> UPDATE EMPLOYEE SET Salary = 55000.00 WHERE E_no = 1; 
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> UPDATE EMPLOYEE SET Dept_name = 'Digital Marketing' WHERE Dept_no = 102;  
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> 
mysql> SELECT * FROM EMPLOYEE; 
+------+------------+--------------+----------+---------+-------------------+--------+----------+------------+
| E_no | E_name     | E_address    | E_ph_no  | Dept_no | Dept_name         | Job_id | Salary   | HIREDATE   |
+------+------------+--------------+----------+---------+-------------------+--------+----------+------------+
|    1 | John Doe   | 123 Main St  | 555-1234 |     101 | Sales             | J1001  | 55000.00 | 2020-08-24 |
|    2 | Jane Smith | 456 Oak St   | 555-5678 |     102 | Digital Marketing | J1002  | 60000.00 | 0004-06-18 |
|    4 | Alice Bob  | 112 Apple St | 555-1112 |     104 | ADMIN             | J1004  | 45000.00 | 0004-03-15 |
+------+------------+--------------+----------+---------+-------------------+--------+----------+------------+
3 rows in set (0.00 sec)

mysql> 
mysql> DELETE FROM EMPLOYEE WHERE E_no = 3; 
Query OK, 0 rows affected (0.00 sec)

mysql> DELETE FROM EMPLOYEE WHERE Dept_no = 101; 
Query OK, 1 row affected (0.01 sec)

mysql> SELECT * FROM EMPLOYEE; 
+------+------------+--------------+----------+---------+-------------------+--------+----------+------------+
| E_no | E_name     | E_address    | E_ph_no  | Dept_no | Dept_name         | Job_id | Salary   | HIREDATE   |
+------+------------+--------------+----------+---------+-------------------+--------+----------+------------+
|    2 | Jane Smith | 456 Oak St   | 555-5678 |     102 | Digital Marketing | J1002  | 60000.00 | 0004-06-18 |
|    4 | Alice Bob  | 112 Apple St | 555-1112 |     104 | ADMIN             | J1004  | 45000.00 | 0004-03-15 |
+------+------------+--------------+----------+---------+-------------------+--------+----------+------------+
2 rows in set (0.00 sec)

mysql> TRUNCATE TABLE EMPLOYEE; 
Query OK, 0 rows affected (0.06 sec)

mysql> SELECT * FROM EMPLOYEE; 
Empty set (0.00 sec)

mysql> ^C
mysql> ^C
mysql> ^C
mysql>
