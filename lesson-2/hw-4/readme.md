# Задание 4

(по желанию) Ознакомьтесь более подробно с документацией утилиты mysqldump.
Создайте дамп единственной таблицы help_keyword базы данных mysql.
Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.

## Решение

Ограничения по лимиту не нашел. Поэтому зацепился за ненадежный вариант — 
идентификаторы.

```text
mysql> SELECT help_keyword_id FROM help_keyword WHERE help_keyword_id < 100;
+-----------------+
| help_keyword_id |
+-----------------+
|               0 |
|              99 |
+-----------------+
100 rows in set (0,00 sec)
```

```text
mysqldump mysql help_keyword --where="help_keyword_id<=100"
```