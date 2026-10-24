mysql> CREATE DATABASE SecurityDB1;
Query OK, 1 row affected (0.02 sec)

mysql> CREATE DATABASE SecurityDB2;
Query OK, 1 row affected (0.00 sec)

mysql> USE SecurityDB1;
Database changed

mysql> CREATE TABLE Users (
    -> user_id INT AUTO_INCREMENT PRIMARY KEY,
    -> username VARCHAR(100),
    -> password_encrypted VARBINARY(255),
    -> secret_key VARCHAR(50)
    -> );
Query OK, 0 rows affected (0.03 sec)

mysql> USE SecurityDB2;
Database changed

mysql> CREATE TABLE Messages (
    -> msg_id INT AUTO_INCREMENT PRIMARY KEY,
    -> original_message VARCHAR(255),
    -> encrypted_message VARBINARY(255),
    -> decrypted_message VARCHAR(255),
    -> hash_value VARCHAR(255),
    -> base64_encoded TEXT
    -> );
Query OK, 0 rows affected (0.02 sec)

mysql> USE SecurityDB1;
Database changed

mysql> INSERT INTO Users (username, password_encrypted, secret_key) VALUES (
    -> 'Allen',
    -> AES_ENCRYPT('mySecretPass123', 'encryption_key_123'),
    -> 'encryption_key_123'
    -> );
Query OK, 1 row affected, 1 warning (0.01 sec)

mysql> SELECT user_id, username, HEX(password_encrypted) AS Encrypted_Password FROM Users;
+---------+----------+----------------------------------+
| user_id | username | Encrypted_Password               |
+---------+----------+----------------------------------+
| 1       | Allen    | 18239F770FC516B8072F489A2AC391D4 |
+---------+----------+----------------------------------+
1 row in set (0.00 sec)

mysql> SELECT username, AES_DECRYPT(password_encrypted, secret_key) AS Decrypted_Password
    -> FROM Users;
+----------+----------------------------------+
| username | Decrypted_Password               |
+----------+----------------------------------+
| Allen    | 0x6D7953656372657450617373313233 |
+----------+----------------------------------+
1 row in set (0.00 sec)

mysql> USE SecurityDB2;
Database changed

mysql> INSERT INTO Messages (original_message, encrypted_message, decrypted_message, hash_value,
    -> base64_encoded) VALUES (
    -> 'Secret Message',
    -> AES_ENCRYPT('Secret Message', 'key123'),
    -> AES_DECRYPT(AES_ENCRYPT('Secret Message', 'key123'), 'key123'),
    -> SHA2('Secret Message', 256),
    -> TO_BASE64('Secret Message')
    -> );
Query OK, 1 row affected (0.01 sec)

mysql> SELECT msg_id,
    -> original_message,
    -> HEX(encrypted_message) AS Encrypted_Hex,
    -> decrypted_message,
    -> base64_encoded,
    -> hash_value,
    -> FROM_BASE64(base64_encoded) AS Base64_Decoded
    -> FROM Messages;
+--------+------------------+----------------------------------+-------------------+----------------------+
