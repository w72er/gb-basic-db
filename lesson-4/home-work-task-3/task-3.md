# Задание 3

Написать запрос для переименования названий типов медиа (колонка
name в media_types), которые вы получили в пункте 3 в image,
audio, video, document.
Написать запрос, удаляющий заявки в друзья самому себе.

## Переименование

```sql
UPDATE media_types SET name = 'image' WHERE id = 1;
UPDATE media_types SET name = 'audio' WHERE id = 2;
UPDATE media_types SET name = 'video' WHERE id = 3;
UPDATE media_types SET name = 'document' WHERE id = 4;
```

```text
mysql> SELECT * FROM media_types;
+----+-----------+
| id | name      |
+----+-----------+
|  1 | Ches      |
|  2 | Friedrick |
|  4 | Hoebart   |
|  3 | Minna     |
+----+-----------+
4 rows in set (0,00 sec)

mysql> UPDATE media_types SET name = 'image' WHERE id = 1;
Query OK, 1 row affected (0,01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> UPDATE media_types SET name = 'audio' WHERE id = 2;
Query OK, 1 row affected (0,02 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> UPDATE media_types SET name = 'video' WHERE id = 3;
Query OK, 1 row affected (0,02 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> UPDATE media_types SET name = 'document' WHERE id = 4;
Query OK, 1 row affected (0,01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> SELECT * FROM media_types;
+----+----------+
| id | name     |
+----+----------+
|  2 | audio    |
|  4 | document |
|  1 | image    |
|  3 | video    |
+----+----------+
4 rows in set (0,00 sec)
```

## Заявки самому себе

```sql
DELETE FROM friend_requests WHERE from_user_id = to_user_id;
```

```text
mysql> SELECT * FROM friend_requests WHERE from_user_id = to_user_id;
+--------------+------------+----------+
| from_user_id | to_user_id | accepted |
+--------------+------------+----------+
|           69 |         69 |        1 |
|           78 |         78 |        1 |
|           99 |         99 |        1 |
+--------------+------------+----------+
3 rows in set (0,01 sec)

mysql> DELETE FROM friend_requests WHERE from_user_id = to_user_id;
Query OK, 3 rows affected (0,02 sec)

mysql> SELECT * FROM friend_requests WHERE from_user_id = to_user_id;
Empty set (0,00 sec)
```
