# Задание 2

Создайте базу данных example, разместите в ней таблицу users,
состоящую из двух столбцов, числового id и строкового name.

## Решение

```shell
cd ~/projects/my/gb-basic-db/lesson-2/hw-2
mysql

mysql> CREATE DATABASE example;
mysql> USE example;

mysql> SOURCE users.sql;
Query OK, 0 rows affected (0,06 sec)

Query OK, 0 rows affected (0,12 sec)

Query OK, 3 rows affected (0,02 sec)
Records: 3  Duplicates: 0  Warnings: 0

+-------+-----------------+------+-----+---------+----------------+
| Field | Type            | Null | Key | Default | Extra          |
+-------+-----------------+------+-----+---------+----------------+
| id    | bigint unsigned | NO   | PRI | NULL    | auto_increment |
| name  | varchar(255)    | NO   | UNI | NULL    |                |
+-------+-----------------+------+-----+---------+----------------+
2 rows in set (0,00 sec)

+----+--------------+
| id | name         |
+----+--------------+
|  1 | ivan.ivanov  |
|  2 | petr.petrov  |
|  3 | sidr.sidorov |
+----+--------------+
3 rows in set (0,00 sec)
```
