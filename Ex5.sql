mysql> CREATE DATABASE CollegeDB;
Query OK, 1 row affected (0.01 sec)

mysql> USE CollegeDB;
Database changed

mysql> CREATE TABLE Employees (
    -> EmpID INT PRIMARY KEY,
    -> FirstName VARCHAR(30),
    -> LastName VARCHAR(30),
    -> DepartmentID INT
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> CREATE TABLE Departments (
    -> DepartmentID INT PRIMARY KEY,
    -> DeptName VARCHAR(50)
    -> );
Query OK, 0 rows affected (0.03 sec)

mysql> CREATE TABLE Projects (
    -> ProjectID INT PRIMARY KEY,
    -> ProjectName VARCHAR(50),
    -> DepartmentID INT,
    -> FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
    -> );
Query OK, 0 rows affected (0.05 sec)

mysql> INSERT INTO Employees (EmpID, FirstName, LastName, DepartmentID)
    -> VALUES
    -> (1, 'Alice', 'Johnson', 101),
    -> (2, 'Bob', 'Smith', 102),
    -> (3, 'Charlie', 'Brown', 103),
    -> (4, 'Daisy', 'Wills', NULL);
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Departments (DepartmentID, DeptName)
    -> VALUES
    -> (101, 'HR'),
    -> (102, 'IT'),
    -> (103, 'Finance'),
    -> (104, 'Marketing');
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Projects (ProjectID, ProjectName, DepartmentID)
    -> VALUES
    -> (1, 'Recruitment Drive', 101),
    -> (2, 'Website Revamp', 102),
    -> (3, 'Audit FY25', 103),
    -> (4, 'Campaign Launch', 104);
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE Projects RENAME COLUMN DepartmentID TO DeptID;
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE Departments RENAME COLUMN DepartmentID TO DeptID;
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> SELECT CONCAT(FirstName, ' ', LastName) AS FullName,
    ->        DeptName,
    ->        ProjectName
    -> FROM Employees
    -> NATURAL JOIN Departments
    -> NATURAL JOIN Projects
    -> ORDER BY FullName;
+---------------+----------+-------------------+
| FullName      | DeptName | ProjectName       |
+---------------+----------+-------------------+
| Alice Johnson | HR       | Recruitment Drive |
| Alice Johnson | IT       | Website Revamp    |
| Alice Johnson | Finance  | Audit FY25        |
| Alice Johnson | Marketing | Campaign Launch  |
| Bob Smith     | HR       | Recruitment Drive |
| Bob Smith     | IT       | Website Revamp    |
| Bob Smith     | Finance  | Audit FY25        |
| Bob Smith     | Marketing | Campaign Launch  |
| Charlie Brown | HR       | Recruitment Drive |
| Charlie Brown | IT       | Website Revamp    |
| Charlie Brown | Finance  | Audit FY25        |
| Charlie Brown | Marketing | Campaign Launch  |
| Daisy Wills   | HR       | Recruitment Drive |
| Daisy Wills   | IT       | Website Revamp    |
| Daisy Wills   | Finance  | Audit FY25        |
| Daisy Wills   | Marketing | Campaign Launch  |
+---------------+----------+-------------------+
16 rows in set (0.00 sec)

mysql> SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    ->        IFNULL(d.DeptName, 'No Department') AS Department,
    ->        IFNULL(p.ProjectName, 'No Project Assigned') AS Project
    -> FROM Employees e
    -> JOIN Departments d
    -> ON e.DepartmentID = d.DeptID
    -> LEFT JOIN Projects p
    -> ON d.DeptID = p.DeptID
    -> ORDER BY e.EmpID;
+---------------+------------+-------------------+
| EmployeeName  | Department | Project           |
+---------------+------------+-------------------+
| Alice Johnson | HR         | Recruitment Drive |
| Bob Smith     | IT         | Website Revamp    |
| Charlie Brown | Finance    | Audit FY25        |
+---------------+------------+-------------------+
3 rows in set (0.00 sec)

mysql> SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    ->        IFNULL(d.DeptName, 'Unassigned') AS Department,
    ->        IFNULL(p.ProjectName, 'Not Allocated') AS Project
    -> FROM Employees e
    -> LEFT JOIN Departments d
    -> ON e.DepartmentID = d.DeptID
    -> LEFT JOIN Projects p
    -> ON d.DeptID = p.DeptID
    -> ORDER BY Department;
+---------------+------------+-------------------+
| EmployeeName  | Department | Project           |
+---------------+------------+-------------------+
| Charlie Brown | Finance    | Audit FY25        |
| Alice Johnson | HR         | Recruitment Drive |
| Bob Smith     | IT         | Website Revamp    |
| Daisy Wills   | Unassigned | Not Allocated     |
+---------------+------------+-------------------+
4 rows in set (0.00 sec)

mysql> SELECT d.DeptName,
    ->        CONCAT(IFNULL(e.FirstName, 'No'), ' ',
    ->               IFNULL(e.LastName, 'Employee')) AS EmployeeName
    -> FROM Departments d
    -> RIGHT JOIN Employees e
    -> ON e.DepartmentID = d.DeptID
    -> WHERE e.DepartmentID IS NULL
    ->    OR d.DeptName IS NOT NULL;
+----------+---------------+
| DeptName | EmployeeName  |
+----------+---------------+
| HR       | Alice Johnson |
| IT       | Bob Smith     |
| Finance  | Charlie Brown |
| NULL     | Daisy Wills   |
+----------+---------------+
4 rows in set (0.00 sec)

mysql> SELECT *
    -> FROM (
    ->     SELECT e.EmpID,
    ->            CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    ->            d.DeptName
    ->     FROM Employees e
    ->     LEFT JOIN Departments d
    ->     ON e.DepartmentID = d.DeptID
    ->
    ->     UNION
    ->
    ->     SELECT e.EmpID,
    ->            CONCAT(IFNULL(e.FirstName, 'Unknown'), ' ',
    ->                   IFNULL(e.LastName, '')) AS EmployeeName,
    ->            d.DeptName
    ->     FROM Employees e
    ->     RIGHT JOIN Departments d
    ->     ON e.DepartmentID = d.DeptID
    -> ) AS EmployeeDepartment
    -> ORDER BY EmployeeName;
+-------+---------------+-----------+
| EmpID | EmployeeName  | DeptName  |
+-------+---------------+-----------+
|     1 | Alice Johnson | HR        |
|     2 | Bob Smith     | IT        |
|     3 | Charlie Brown | Finance   |
|     4 | Daisy Wills   | NULL      |
|  NULL | Unknown       | Marketing |
+-------+---------------+-----------+
5 rows in set (0.01 sec)
