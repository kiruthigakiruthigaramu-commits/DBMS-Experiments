mysql> CREATE DATABASE libraryDB;
Query OK, 1 row affected (0.01 sec)

mysql> USE libraryDB;
Database changed
mysql> CREATE TABLE Authors(
    -> AuthorID INT PRIMARY KEY,
    -> Name VARCHAR(100)
    -> );
Query OK, 0 rows affected (0.06 sec)

mysql> CREATE TABLE Books(
    -> BookID INT PRIMARY KEY,
    -> Title VARCHAR(150),
    -> AuthorID INT,
    -> FOREIGN KEY(AuthorID)REFERENCES Authors(AuthorID)
    -> );
Query OK, 0 rows affected (0.06 sec)

mysql> CREATE TABLE Borrowers(
    -> BorrowerID INT PRIMARY KEY,
    -> Name VARCHAR(100)
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> CREATE TABLE BookBorrowing(
    -> BookID INT,
    -> BorrowerID INT,
    -> BorrowedDate TIMESTAMP DEFAULT CURRENT_TIMESTANP,
    -> ;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'CURRENT_TIMESTANP,' at line 4
mysql> CREATE TABLE BookBorrowing(
    -> BookID INT,
    -> BorrowerID INT,
    -> BorrowedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -> FOREIGN KEY(BookID)REFERENCES Books(BookID),
    -> FOREIGN KEY(BorroweriD)REFERENCES Borrowers(BorrowerID)
    -> );
Query OK, 0 rows affected (0.07 sec)

mysql> INSERT INTO Authors(AuthorID,Name)
    -> VALUES
    -> (1,'J.K.Rowling'),
    -> (2.'George Orwell'),
    -> (3,'J.R.R.Tolkien');
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''George Orwell'),
(3,'J.R.R.Tolkien')' at line 4
mysql> INSERT INTO Authors(AuthorID,Name)
    ->     -> VALUES
    ->     -> (1,'J.K.Rowling'),
    -> (2,'George Orwell'),
    -> (3,'J.R.R.Tolkien');
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '-> VALUES
    -> (1,'J.K.Rowling'),
(2,'George Orwell'),
(3,'J.R.R.Tolkien')' at line 2
mysql> INSERT INTO Authors(AuthorID,Name)
    -> VALUES
    -> (1,'J.K.Rowling'),
    -> (2,'George Orwell'),
    -> (3,'J.R.R.Tolkien');
Query OK, 3 rows affected (0.03 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Books(BookID,Title,AuthorID)
    -> VALUES
    -> (101,'Harry Potter and the Philosopher\'s Stone',1),
    -> (102,'1984',2),
    -> (103,'The Hobbit',3),
    -> (104,'Harry Potter and the Chamber of Secrets',1);
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Borrowers(BorrowerID,Name)
    -> VALUES
    -> (1,'John Doe'),
    -> (2,'Jane Smith'),
    -> (3,'Alice Johnson');
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> INSERT INTO BookBorrowing(BookID,BorrowerID)
    -> VALUES
    -> (101,1),
    -> (102,2),
    -> (103,3),
    -> (104,1);
Query OK, 4 rows affected (0.02 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> SELECT*FROM Authors;
+----------+---------------+
| AuthorID | Name          |
+----------+---------------+
|        1 | J.K.Rowling   |
|        2 | George Orwell |
|        3 | J.R.R.Tolkien |
+----------+---------------+
3 rows in set (0.00 sec)

mysql> SELECT*FROM Books;
+--------+------------------------------------------+----------+
| BookID | Title                                    | AuthorID |
+--------+------------------------------------------+----------+
|    101 | Harry Potter and the Philosopher's Stone |        1 |
|    102 | 1984                                     |        2 |
|    103 | The Hobbit                               |        3 |
|    104 | Harry Potter and the Chamber of Secrets  |        1 |
+--------+------------------------------------------+----------+
4 rows in set (0.01 sec)

mysql> SELECT *FROM BookBorrowing;
+--------+------------+---------------------+
| BookID | BorrowerID | BorrowedDate        |
+--------+------------+---------------------+
|    101 |          1 | 2026-08-10 14:49:46 |
|    102 |          2 | 2026-08-10 14:49:46 |
|    103 |          3 | 2026-08-10 14:49:46 |
|    104 |          1 | 2026-08-10 14:49:46 |
+--------+------------+---------------------+
4 rows in set (0.00 sec)

mysql> SELECT UPPER(b.Title)AS Title,a.Name AS Author
    -> FROM Books b
    -> INNER JOIN Authors a ON b.AuthorID=a.AuthorID;
+------------------------------------------+---------------+
| Title                                    | Author        |
+------------------------------------------+---------------+
| HARRY POTTER AND THE PHILOSOPHER'S STONE | J.K.Rowling   |
| HARRY POTTER AND THE CHAMBER OF SECRETS  | J.K.Rowling   |
| 1984                                     | George Orwell |
| THE HOBBIT                               | J.R.R.Tolkien |
+------------------------------------------+---------------+
4 rows in set (0.01 sec)

mysql> SELECT Name,
    -> (SELECT COUNT(*) FROM Books WHERE Books.AuthorID=Authors.AuthorID)AS NumberOfBooks
    -> FROM Authors;
+---------------+---------------+
| Name          | NumberOfBooks |
+---------------+---------------+
| J.K.Rowling   |             2 |
| George Orwell |             1 |
| J.R.R.Tolkien |             1 |
+---------------+---------------+
3 rows in set (0.00 sec)

mysql> SELECT Title FROM Books
    -> WHERE BookID IN(
    -> SELECT BookID
    -> FROM BookBorrowing
    -> WHERE BorrowerID=(
    -> SELECT BorrowerID FROM Borrowers WHERE Name='John Doe'
    -> )
    -> );
+------------------------------------------+
| Title                                    |
+------------------------------------------+
| Harry Potter and the Philosopher's Stone |
| Harry Potter and the Chamber of Secrets  |
+------------------------------------------+
2 rows in set (0.00 sec)

mysql> SELECT
    -> b.Title,
    -> COALESCE(bb_data.name,'Not Borrowed') AS Borrower
    -> FROM
    -> Books b
    -> LEFT JOIN(
    -> SELECT
    -> bb.bookID,
    -> br.Name
    -> FROM
    -> BookBorrowing bb
    -> JOIN
    -> Borrowers br ON bb.BorrowerID=br.BorrowerID
    -> ) AS bb_data ON b.BookID=bb_data.BookID;
+------------------------------------------+---------------+
| Title                                    | Borrower      |
+------------------------------------------+---------------+
| Harry Potter and the Philosopher's Stone | John Doe      |
| 1984                                     | Jane Smith    |
| The Hobbit                               | Alice Johnson |
| Harry Potter and the Chamber of Secrets  | John Doe      |
+------------------------------------------+---------------+
4 rows in set (0.00 sec)

mysql> SELECT DISTINCT br.Name
    -> FROM Borrowers br
    -> WHERE EXISTS(
    -> SELECT 1
    -> FROM BookBorrowing bb
    -> JOIN Books b ON bb.BookID=b.BookID
    -> WHERE b.AuthorID=(SELECT AuthorID FROM Authors WHERE Name='J.K.Rowling')
    -> AND bb.BorrowerID=br.BorrowerID
    -> );
+----------+
| Name     |
+----------+
| John Doe |
+----------+
1 row in set (0.01 sec)

mysql> SELECT Title
    -> FROM Books
    -> WHERE EXISTS(
    -> SELECT 1 FROM BookBorrowing bb WHERE bb.BookiD=Books.BookID
    -> );
+------------------------------------------+
| Title                                    |
+------------------------------------------+
| Harry Potter and the Philosopher's Stone |
| 1984                                     |
| The Hobbit                               |
| Harry Potter and the Chamber of Secrets  |
+------------------------------------------+
4 rows in set (0.00 sec)

mysql> SELECT Title
    -> FROM Books
    -> WHERE NOT EXISTS(
    -> SELECT 1 FROM BookBorrowing bb WHERE bb.BookID=Books.BookID
    -> );
Empty set (0.00 sec)

mysql>
