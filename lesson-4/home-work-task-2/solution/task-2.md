# Задание 2

Используя сервис http://filldb.info, https://www.mockaroo.com/
или другой по вашему желанию, сгенерировать тестовые данные для
всех таблиц, используя vk-data.sql, учитывая логику связей.
Для всех таблиц, где это имеет смысл, создать не менее 100 строк.
Для media_types создать ровно 4 строки. Загрузить тестовые данные.
Приложить к отчёту полученный дамп с данными.

## Решение

Этот шаг лишний, поскольку все данные имеются уже в `vk-data.sql`:
```shell
C:\'Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe' -u root -p --no-data > vk-schema-before.sql
```

* users (1)
  * id: Row Number
  * first_name: First Name
  * last_name: Last Name
  * email: Email Address
  * phone: Phone, format: #########, sum: '8'+this
  * password_hash: SHA1
  * created_at: Datetime, 04/01/2019 to 07/12/2021 format: SQL datetime
* media_types (2)
  * id: Row Number
  * name: First Name
* media (3)
  * user_id Row Number
  * file_size Number 100 10000
  * media_types_id Custom List 1,2,3,4
* communities (4)
  * id: Row Number
  * name: App Name
  * description: Desc
* profiles (5)
  * user_id: Row Number
  * gender Number [0 10]
    ```text
    if this == 0 then 'x'
    elsif this % 2 == 0 then 'm'
    else 'f' end
    ```
  * birthday: Datetime, 07/12/1980 to 07/12/2004 format: yyyy-mm-dd
  * photo_id Row Number
  * user_status: desc
* communities_users (6)
  * user_id и com_id - числа из диапазона [1-100], чтобы было несколько записей увеличим количество строк до 200.
  * тестируем и убираем записи с ошибкой
* friend_requests (7)
* messages (8)
* posts (9)
* posts_likes (10)

```python
names = 'users media_types media communities profiles communities_users friend_requests messages posts posts_likes'
' '.join(list(map(lambda name: f'{name}.sql', names.split())))
# 'users.sql media_types.sql media.sql communities.sql profiles.sql communities_users.sql friend_requests.sql messages.sql posts.sql posts_likes.sql'
```

```shell
cat users.sql media_types.sql media.sql communities.sql profiles.sql communities_users.sql friend_requests.sql messages.sql posts.sql posts_likes.sql > full-data.sql
```

```shell
mysqldump
```

## Проверка

```shell
mysqldump vk > mysqldump-vk.sql
mysql vk < mysqldump-vk.sql # предварительно пересоздав БД vk
```

```text
show tables;
+-------------------+
| Tables_in_vk      |
+-------------------+
| communities       |
| communities_users |
| friend_requests   |
| media             |
| media_types       |
| messages          |
| posts             |
| posts_likes       |
| profiles          |
| users             |
+-------------------+
10 rows in set (0,00 sec)
SELECT * FROM posts_likes;
```

## Выводы

1. http://filldb.info - при загрузке таблицы `post_likes`, не мог для нее сгенерировать данные.
2. https://www.mockaroo.com/ Не удобно что сразу нельзя загрузить несколько таблиц.
* Работать с `FOREIGN KEY` получалось через случайное число из диапазона.
* Если есть ограничения на дублирование, то вставка каждой записи одиночно при
  вызове команды `SOURCE post_likes.sql`, не останавливает выполнение, поэтому удалять
  дубликаты не обязательно, чего не скажешь о запуске через `mysql workbench`.
* У сервиса [mockaroo.com](https://www.mockaroo.com/) большое количество вариантов заполнения,
  что позволяет наполнять таблицы качественными данными.
3. Генерация данных — долгая процедура
