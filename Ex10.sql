mysql> CREATE DATABASE IF NOT EXISTS sqli_demo;
Query OK, 1 row affected (0.05 sec)

mysql> USE sqli_demo;
Database changed

mysql> CREATE TABLE IF NOT EXISTS users (
    -> id INT AUTO_INCREMENT PRIMARY KEY,
    -> username VARCHAR(50) NOT NULL,
    -> password VARCHAR(100) NOT NULL,
    -> role VARCHAR(20) DEFAULT 'user'
    -> );
Query OK, 0 rows affected (0.06 sec)

mysql> INSERT INTO users (username, password, role) VALUES
    -> ('admin','password','admin'),
    -> ('alice', 'alicepwd', 'user'),
    -> ('bob','bobpwd','user');
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> SET @user_input := "admin";
Query OK, 0 rows affected (0.03 sec)

mysql> SET @vuln_sql := CONCAT("SELECT id, username, password FROM users WHERE username = '",
    -> @user_input, "';");
Query OK, 0 rows affected (0.00 sec)

mysql> PREPARE p FROM @vuln_sql;
Query OK, 0 rows affected (0.00 sec)
Statement prepared

mysql> EXECUTE p;
+----+----------+----------+
| id | username | password |
+----+----------+----------+
| 1  | admin    | p@ssword |
+----+----------+----------+
1 row in set (0.00 sec)

mysql> DEALLOCATE PREPARE p;
Query OK, 0 rows affected (0.00 sec)

mysql> SET @user_input := "[SQLi test payload from the lab]";
Query OK, 0 rows affected (0.00 sec)

mysql> PREPARE p2 FROM @vuln_sql;
Statement prepared

mysql> EXECUTE p2;
+----+----------+----------+
| id | username | password |
+----+----------+----------+
| 1  | admin    | p@ssword |
| 2  | alice    | alicepwd |
| 3  | bob      | bobpwd   |
+----+----------+----------+
3 rows in set (0.00 sec)

mysql> DEALLOCATE PREPARE p2;
Query OK, 0 rows affected (0.00 sec)

mysql> SET @sql := 'SELECT id, username FROM users WHERE username = ?';
Query OK, 0 rows affected (0.00 sec)

mysql> PREPARE safe_stmt FROM @sql;
Query OK, 0 rows affected (0.03 sec)
Statement prepared

mysql> SET @u := 'admin';
Query OK, 0 rows affected (0.00 sec)

mysql> EXECUTE safe_stmt USING @u;
+----+----------+
| id | username |
+----+----------+
| 1  | admin    |
+----+----------+
1 row in set (0.00 sec)

mysql> SET @u := "[SQLi test payload from the lab]";
Query OK, 0 rows affected (0.00 sec)

mysql> EXECUTE safe_stmt USING @u;
Empty set (0.00 sec)

mysql> DEALLOCATE PREPARE safe_stmt;
Query OK, 0 rows affected (0.00 sec)

mysql> DELIMITER $$

mysql> CREATE PROCEDURE get_user(IN p_username VARCHAR(50))
    -> BEGIN
    -> SET @sql := 'SELECT id, username FROM users WHERE username = ?';
    -> PREPARE s FROM @sql;
    -> SET @p := p_username;
    -> EXECUTE s USING @p;
    -> DEALLOCATE PREPARE s;
    -> END $$
Query OK, 0 rows affected (0.04 sec)

mysql> DELIMITER ;

mysql> CALL get_user('alice');
+----+----------+
| id | username |
+----+----------+
| 2  | alice    |
+----+----------+
1 row in set (0.00 sec)
Query OK, 0 rows affected (0.00 sec)

mysql> CALL get_user("[SQLi test payload from the lab]");
Empty set (0.00 sec)
Query OK, 0 rows affected (0.00 sec)

mysql> CREATE OR REPLACE VIEW v_users AS
    -> SELECT id, username, role FROM users;
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE USER IF NOT EXISTS 'app_user'@'localhost' IDENTIFIED BY 'app_pass';
Query OK, 0 rows affected (0.02 sec)

mysql> GRANT SELECT ON sqli_demo.v_users TO 'app_user'@'localhost';
Query OK, 0 rows affected (0.01 sec)

mysql> REVOKE SELECT ON sqli_demo.users FROM 'app_user'@'localhost';
ERROR 1147 (42000): There is no such grant defined for user 'app_user' on host 'localhost' on table 'users'

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)

mysql> DELIMITER $$

mysql> CREATE PROCEDURE get_user_by_id_strict(IN p_id_str VARCHAR(20))
    -> BEGIN
    -> IF p_id_str REGEXP '^[0-9]+$' THEN
    -> SET @idnum := CAST(p_id_str AS UNSIGNED);
    -> PREPARE q FROM 'SELECT id, username FROM users WHERE id = ?';
    -> EXECUTE q USING @idnum;
    -> DEALLOCATE PREPARE q;
    -> ELSE
    -> SELECT 'ERROR: invalid id format' AS error;
    -> END IF;
    -> END $$
Query OK, 0 rows affected (0.04 sec)

mysql> DELIMITER ;

mysql> CALL get_user_by_id_strict('1');
+----+----------+
| id | username |
+----+----------+
| 1  | admin    |
+----+----------+
1 row in set (0.01 sec)
Query OK, 0 rows affected (0.01 sec)

mysql> CALL get_user_by_id_strict('[invalid SQLi input]');
+--------------------------+
| error                    |
+--------------------------+
| ERROR: invalid id format |
+--------------------------+
1 row in set (0.00 sec)
Query OK, 0 rows affected (0.00 sec)

mysql> DROP PROCEDURE IF EXISTS get_user;
Query OK, 0 rows affected (0.01 sec)

mysql> DROP PROCEDURE IF EXISTS get_user_by_id_strict;
Query OK, 0 rows affected (0.01 sec)

mysql> DROP VIEW IF EXISTS v_users;
Query OK, 0 rows affected (0.01 sec)

mysql> DROP USER IF EXISTS 'app_user'@'localhost';
Query OK, 0 rows affected (0.00 sec)

mysql> DROP DATABASE IF EXISTS sqli_demo;
Query OK, 1 row affected (0.02 sec)
