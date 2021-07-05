# Задание 3

Создайте дамп базы данных example из предыдущего задания, разверните
содержимое дампа в новую базу данных sample.

## Решение

```shell
mysqldump example > /tmp/example.sql
mysql
mysql> CREATE DATABASE sample;
mysql sample < /tmp/example.sql
mysql
mysql> USE sample;
mysql> DESCRIBE users;
+-------+-----------------+------+-----+---------+----------------+
| Field | Type            | Null | Key | Default | Extra          |
+-------+-----------------+------+-----+---------+----------------+
| id    | bigint unsigned | NO   | PRI | NULL    | auto_increment |
| name  | varchar(255)    | NO   | UNI | NULL    |                |
+-------+-----------------+------+-----+---------+----------------+
2 rows in set (0,01 sec)
```
