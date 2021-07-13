# Задание 2

Используя сервис http://filldb.info, https://www.mockaroo.com/
или другой по вашему желанию, сгенерировать тестовые данные для
всех таблиц, используя vk-data.sql, учитывая логику связей.
Для всех таблиц, где это имеет смысл, создать не менее 100 строк.
Для media_types создать ровно 4 строки. Загрузить тестовые данные.
Приложить к отчёту полученный дамп с данными.

Этот шаг лишний, поскольку все данные имеются уже в `vk-data.sql`:
```shell
C:\'Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe' -u root -p --no-data > vk-schema-before.sql
```

* communities (4)
  * id: Row Number
  * name: App Name
  * description: Desc
* communities_users (6)
  * user_id и com_id - числа из диапазона [1-100], чтобы было несколько записей увеличим количество строк до 200.
  * тестируем и убираем записи с ошибкой
* friend_requests (7)
* media (3)
  * user_id Row Number
  * file_size Number 100 10000
  * media_types_id Custom List 1,2,3,4
* media_types (2)
  * id: Row Number
  * name: First Name
* messages (8)
* posts (9)
* posts_likes (10)
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
* users (1)
  * id: Row Number
  * first_name: First Name
  * last_name: Last Name
  * email: Email Address
  * phone: Phone, format: #########, sum: '8'+this
  * password_hash: SHA1
  * created_at: Datetime, 04/01/2019 to 07/12/2021 format: SQL datetime





