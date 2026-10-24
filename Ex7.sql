mysql> CREATE
DATABASE CollegeDB;
Query OK, 1 row affected (0.01 sec)
mysql> USE CollegeDB;
Database changed
2. CREATE TABLE DEPARTMENTS: mysql> CREATE TABLE
Departments ( -> DeptID INT PRIMARY KEY,
-> DeptName VARCHAR(100),
-> StudentCount INT,
-> TeacherCount INT,
-> Classrooms INT,
-> Email VARCHAR(100)
-> );
Query OK, 0 rows affected (0.03 sec)
3. BEGIN TRANSACTION:
Ex No: 7 IMPLEMENTING DCL AND TCL COMMANDS
mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)
4. INSERT RECORDS + SAVEPOINTS:
mysql> INSERT INTO Departments VALUES (1, 'Computer Science', 200, 15, 5,
'cs@college.edu');
Query OK, 1 row affected (0.00 sec)
mysql> SAVEPOINT sp1;
Query OK, 0 rows affected (0.00 sec)
mysql> mysql> INSERT INTO Departments VALUES (2, 'Information
Technology', 180,
12, 4, 'it@college.edu');
Query OK, 1 row affected (0.00 sec)
mysql> SAVEPOINT sp2;
Query OK, 0 rows affected (0.00 sec)
mysql> mysql> INSERT INTO Departments VALUES (3, 'Cyber Security',
150, 10, 6,
'cyber@college.edu');
Query OK, 1 row affected (0.00 sec)
mysql> SAVEPOINT sp3;
Query OK, 0 rows affected (0.00 sec)
mysql> mysql> INSERT INTO Departments VALUES (4, 'Electronics',
150, 10, 6,
'ece@college.edu');
Query OK, 1 row affected (0.00 sec)
5. VIEW ALL RECORDS:
mysql> SELECT * FROM Departments;
+--------+------------------------+--------------+--------------+------------+------------------
+
| DeptID | DeptName | StudentCount | TeacherCount | Classrooms | Email
|
+--------+------------------------+--------------+--------------+------------+------------------
+
| 1 | Computer Science | 200 | 15 | 5 | cs@college.edu |
| 2 | Information Technology | 180 | 12 | 4 | it@college.edu |
| 3 | Cyber Security | 150 | 10 | 6 | cyber@college.edu |
| 4 | Electronics | 150 | 10 | 6 | ece@college.edu |
+--------+------------------------+--------------+--------------+------------+------------------
+
4 rows in set (0.00 sec)
6. UPDATE SOME DATA:
mysql> UPDATE Departments SET StudentCount = 220 WHERE DeptID = 1;
Query OK, 1 row affected (0.00 sec)
Rows matched: 1 Changed: 1 Warnings: 0
mysql> UPDATE Departments SET StudentCount = 190 WHERE DeptID = 2;
Query OK, 1 row affected (0.00 sec)
Rows matched: 1 Changed: 1 Warnings: 0
mysql> SAVEPOINT sp4;
Query OK, 0 rows affected (0.00 sec)
7. ROLLBACK TO SAVEPOINT (UNDO LAST UPDATE):
mysql> ROLLBACK TO sp2;
Query OK, 0 rows affected (0.03 sec)
8. VIEW AFTER ROLLBACK:
mysql> SELECT * FROM Departments;
+--------+------------------------+--------------+--------------+------------+----------------+
| DeptID | DeptName | StudentCount | TeacherCount | Classrooms | Email
|
+--------+------------------------+--------------+--------------+------------+----------------+
| 1 | Computer Science | 200 | 15 | 5 | cs@college.edu |
| 2 | Information Technology | 180 | 12 | 4 | it@college.edu |
+--------+------------------------+--------------+--------------+------------+----------------+
2 rows in set (0.00 sec)
9. ADD NEW RECORD AND DELETE:
mysql> INSERT INTO Departments VALUES (5, 'Mechanical', 160, 11, 7,
'mech@college.edu');
Query OK, 1 row affected (0.00 sec)
mysql> DELETE FROM Departments WHERE DeptID = 2;
Query OK, 1 row affected (0.00 sec)
10. FINAL COMMIT: mysql> COMMIT;
Query OK, 0 rows affected (0.04 sec)
11. CREATE NEW USER:
mysql> CREATE USER 'dept_user'@'localhost' IDENTIFIED BY 'pass123';
Query OK, 0 rows affected (0.05 sec)
12. GRANT PRIVILEGES TO USER:
mysql> GRANT SELECT, INSERT ON CollegeDB.Departments TO
'dept_user'@'localhost';
Query OK, 0 rows affected (0.04 sec)
13. SWITCH USER IN COMMAND LINE: mysql> mysql -u dept_user -p -> USE
CollegeDB; mysql> SELECT * FROM Departments;
+--------+------------------+--------------+--------------+------------+------------------+
| DeptID | DeptName | StudentCount | TeacherCount | Classrooms | Email
|
+--------+------------------+--------------+--------------+------------+------------------+
| 1 | Computer Science | 200 | 15 | 5 | cs@college.edu |
| 5 | Mechanical | 160 | 11 | 7 | mech@college.edu |
+--------+------------------+--------------+--------------+------------+------------------+ 2
rows in set (0.00 sec)
mysql> INSERT INTO Departments VALUES (6, 'Artificial Intelligence', 140, 9,
4, 'ai@college.edu');
Query OK, 1 row affected (0.01 sec)
mysql> DELETE FROM Departments WHERE DeptID = 1;
Query OK, 1 row affected (0.04 sec)
mysql> -- ERROR 1142 (42000): DELETE command denied to user
'dept_user'@'localhost'
14. GRANT ADDITIONAL PRIVILEGES (FROM ROOT):
mysql> GRANT DELETE, UPDATE ON CollegeDB.Departments TO
'dept_user'@'localhost';
Query OK, 0 rows affected (0.04 sec)
15. REVOKE ALL PERMISSIONS: mysql> REVOKE DELETE, INSERT, UPDATE
ON CollegeDB.Departments
FROM 'dept_user'@'localhost';
Query OK, 0 rows affected (0.01 sec)
16. DROP USER:
mysql> DROP USER 'dept_user'@'localhost'; Query
OK, 0 rows affected (0.04 sec
