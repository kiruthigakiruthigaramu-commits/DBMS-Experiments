mysql> CREATE DATABASE CompanyDB;
Query OK, 1 row affected (0.23 sec)

mysql> USE CompanyDB;
Database changed
mysql> CREATE TABLE Employees (
    ->     EmpID INT PRIMARY KEY,
    ->     FirstName VARCHAR(30),
    ->     LastName VARCHAR(30),
    ->     Salary DECIMAL(10,2),
    ->     Department VARCHAR(30)
    -> );
Query OK, 0 rows affected (1.29 sec)

mysql> CREATE TABLE Attendance (
    ->     AttendanceID INT PRIMARY KEY AUTO_INCREMENT,
    ->     EmpID INT,
    ->     Date DATE,
    ->     Status ENUM('Present', 'Absent'),
    ->     FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
    -> );
Query OK, 0 rows affected (1.32 sec)

mysql> INSERT INTO Employees VALUES
    -> (1, 'Alice', 'Thomas', 55000.00, 'HR'),
    -> (2, 'Bob', 'Williams', 62000.00, 'IT'),
    -> (3, 'Charlie', 'Smith', 47000.00, 'Finance'),
    -> (4, 'Daisy', 'Johnson', 50000.00, 'IT');
Query OK, 4 rows affected (0.13 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Attendance (EmpID, Date, Status) VALUES
    -> (1, '2025-08-01', 'Present'),
    -> (2, '2025-08-01', 'Absent'),
    -> (3, '2025-08-01', 'Present'),
    -> (4, '2025-08-01', 'Present'),
    -> (2, '2025-08-02', 'Present');
Query OK, 5 rows affected (0.14 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> CREATE VIEW IT_Employees AS
    -> SELECT EmpID,
    ->        CONCAT(FirstName, ' ', LastName) AS FullName,
    ->        Salary
    -> FROM Employees
    -> WHERE Department = 'IT';
Query OK, 0 rows affected (0.15 sec)

mysql> SELECT * FROM IT_Employees;
+-------+---------------+----------+
| EmpID | FullName      | Salary   |
+-------+---------------+----------+
|     2 | Bob Williams  | 62000.00 |
|     4 | Daisy Johnson | 50000.00 |
+-------+---------------+----------+
2 rows in set (0.06 sec)

mysql> UPDATE IT_Employees
    -> SET Salary = Salary + 5000
    -> WHERE FullName = 'Bob Williams';
Query OK, 1 row affected (0.12 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> SELECT * FROM IT_Employees;
+-------+---------------+----------+
| EmpID | FullName      | Salary   |
+-------+---------------+----------+
|     2 | Bob Williams  | 67000.00 |
|     4 | Daisy Johnson | 50000.00 |
+-------+---------------+----------+
2 rows in set (0.00 sec)

mysql> DELIMITER //
mysql> 
mysql> CREATE PROCEDURE GetSalaryRange(
    ->     IN minSal DECIMAL(10,2),
    ->     IN maxSal DECIMAL(10,2)
    -> )
    -> BEGIN
    ->     SELECT EmpID,
    ->            CONCAT(FirstName, ' ', LastName) AS FullName,
    ->            Salary
    ->     FROM Employees
    ->     WHERE Salary BETWEEN minSal AND maxSal;
    -> END //
Query OK, 0 rows affected (0.25 sec)

mysql> 
mysql> DELIMITER ;
mysql> CREATE VIEW NameDetails AS
    -> SELECT EmpID,
    ->        CONCAT(FirstName, ' ', LastName) AS FullName,
    ->        LENGTH(CONCAT(FirstName, ' ', LastName)) AS NameLength
    -> FROM Employees;
Query OK, 0 rows affected (0.22 sec)

mysql> CALL GetSalaryRange(48000.00, 60000.00);
+-------+---------------+----------+
| EmpID | FullName      | Salary   |
+-------+---------------+----------+
|     1 | Alice Thomas  | 55000.00 |
|     4 | Daisy Johnson | 50000.00 |
+-------+---------------+----------+
2 rows in set (0.00 sec)

Query OK, 0 rows affected (0.01 sec)

mysql> DELIMITER //
mysql> 
mysql> CREATE PROCEDURE CheckAboveAverageSalary(IN emp_id INT)
    -> BEGIN
    ->     DECLARE empSal DECIMAL(10,2);
    ->     DECLARE avgSal DECIMAL(10,2);
    -> 
    ->     SELECT Salary INTO empSal
    ->     FROM Employees
    ->     WHERE EmpID = emp_id;
    -> 
    ->     SELECT AVG(Salary) INTO avgSal
    ->     FROM Employees;
    -> 
    ->     IF empSal > avgSal THEN
    ->         SELECT CONCAT(
    ->             'Employee ', emp_id,
    ->             ' has salary above average.'
    ->         ) AS Message;
    ->     ELSE
    ->         SELECT CONCAT(
    ->             'Employee ', emp_id,
    ->             ' has salary below average.'
    ->         ) AS Message;
    ->     END IF;
    -> END //
Query OK, 0 rows affected (0.23 sec)

mysql> 
mysql> DELIMITER ;
mysql> CALL CheckAboveAverageSalary(2);
+--------------------------------------+
| Message                              |
+--------------------------------------+
| Employee 2 has salary above average. |
+--------------------------------------+
1 row in set (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

mysql> DELIMITER //
mysql> 
mysql> CREATE FUNCTION AttendanceDays(emp_id INT)
    -> RETURNS INT
    -> DETERMINISTIC
    -> BEGIN
    ->     DECLARE countDays INT;
    -> 
    ->     SELECT COUNT(*)
    ->     INTO countDays
    ->     FROM Attendance
    ->     WHERE EmpID = emp_id
    ->       AND Status = 'Present';
    -> 
    ->     RETURN countDays;
    -> END //
Query OK, 0 rows affected (0.20 sec)

mysql> 
mysql> DELIMITER ;
mysql> SELECT EmpID, AttendanceDays(EmpID) AS PresentDays FROM Employees;
+-------+-------------+
| EmpID | PresentDays |
+-------+-------------+
|     1 |           1 |
|     2 |           1 |
|     3 |           1 |
|     4 |           1 |
+-------+-------------+
4 rows in set (0.00 sec)
