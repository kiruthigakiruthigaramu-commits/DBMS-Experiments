CREATE TABLE students (
    ->     student_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     name VARCHAR(100) NOT NULL,
    ->     email VARCHAR(100) NOT NULL UNIQUE
    -> );
Query OK, 0 rows affected (0.05 sec)

mysql> 
mysql> CREATE TABLE courses (
    ->     course_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     course_name VARCHAR(100) NOT NULL,
    ->     credits INT NOT NULL,
    ->     CHECK (credits > 0 AND credits <= 6)
    -> );
Query OK, 0 rows affected (0.03 sec)

mysql> 
mysql> CREATE TABLE enrollments (
    ->     enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     student_id INT NOT NULL,
    ->     course_id INT NOT NULL,
    ->     enrollment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    -> 
    ->     FOREIGN KEY (student_id) REFERENCES students(student_id)
    ->         ON DELETE CASCADE
    ->         ON UPDATE CASCADE,
    -> 
    ->     FOREIGN KEY (course_id) REFERENCES courses(course_id)
    ->         ON DELETE CASCADE
    ->         ON UPDATE CASCADE,
    -> 
    ->     UNIQUE (student_id, course_id)
    -> );
Query OK, 0 rows affected (0.05 sec)

mysql> 
mysql> INSERT INTO students (name, email)
    -> VALUES
    -> ('Alice Johnson', 'alice@example.com'),
    -> ('Bob Smith', 'bob@example.com');
Query OK, 2 rows affected (0.01 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> 
mysql> SELECT * FROM students;
+------------+---------------+-------------------+
| student_id | name          | email             |
+------------+---------------+-------------------+
|          1 | Alice Johnson | alice@example.com |
|          2 | Bob Smith     | bob@example.com   |
+------------+---------------+-------------------+
2 rows in set (0.00 sec)

mysql> 
mysql> INSERT INTO courses (course_name, credits)
    -> VALUES
    -> ('Database Systems', 3),
    -> ('Computer Networks', 4);
Query OK, 2 rows affected (0.01 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> 
mysql> SELECT * FROM courses;
+-----------+-------------------+---------+
| course_id | course_name       | credits |
+-----------+-------------------+---------+
|         1 | Database Systems  |       3 |
|         2 | Computer Networks |       4 |
+-----------+-------------------+---------+
2 rows in set (0.00 sec)

mysql> 
mysql> INSERT INTO enrollments (student_id, course_id)
    -> VALUES
    -> (1, 1),
    -> (2, 1),
    -> (1, 2);
Query OK, 3 rows affected (0.02 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> 
mysql> SELECT * FROM enrollments;
+---------------+------------+-----------+-----------------+
| enrollment_id | student_id | course_id | enrollment_date |
+---------------+------------+-----------+-----------------+
|             1 |          1 |         1 | 2026-07-14      |
|             2 |          2 |         1 | 2026-07-14      |
|             3 |          1 |         2 | 2026-07-14      |
+---------------+------------+-----------+-----------------+
3 rows in set (0.00 sec)

mysql> 
mysql> DELETE FROM students
    -> WHERE student_id = 2;
Query OK, 1 row affected (0.00 sec)

mysql> 
mysql> DELETE FROM courses
    -> WHERE course_id = 2;
Query OK, 1 row affected (0.01 sec)

mysql> 
mysql> SELECT * FROM students;
+------------+---------------+-------------------+
| student_id | name          | email             |
+------------+---------------+-------------------+
|          1 | Alice Johnson | alice@example.com |
+------------+---------------+-------------------+
1 row in set (0.00 sec)

mysql> 
mysql> SELECT * FROM courses;
+-----------+------------------+---------+
| course_id | course_name      | credits |
+-----------+------------------+---------+
|         1 | Database Systems |       3 |
+-----------+------------------+---------+
1 row in set (0.00 sec)

mysql> 
mysql> DROP TABLE IF EXISTS enrollments;
Query OK, 0 rows affected (0.03 sec)

mysql> 
mysql> DROP TABLE IF EXISTS students;
Query OK, 0 rows affected (0.02 sec)

mysql> 
mysql> DROP TABLE IF EXISTS courses;
Query OK, 0 rows affected (0.02 sec)

mysql> 
mysql> DROP DATABASE university_db;
