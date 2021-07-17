## Урок 6. Вебинар. Операторы, фильтрация, сортировка и ограничение. Агрегация данных

Не переживайте, все будет проверено.

Задачи:
* Селект
* Как можем делать курсовую

Два решения один мой и второй:
```text
likes
    id
    user_id
    to_user_id --
    to_media_id -- будет много дырок
    to_post_id -- 

    obj_id -- нет дырок, но нет 
    obj_type -- и внешних ключей.
```

update media
set name = case
    when
    when
    when

Рассмотрим вложенные select-ы, иногда без них никак, но часто мы
подобные запросы можем переписать с помощью join.

alter table frend_request add constraint fk_ FK 

## Вложенные запросы и передача значений.

Строим основной запрос с дырками для данных о city, profile_photo,
затем в круглые скобки записываем под запросы, затем параметризуем
под запросы.

У нас по трем страницам распределена информация о пользователе
select
    first_name,
    last_name,
    'city',
    'profile_photo'
FROM users
WHERE id = 1;

SELECT city FROM profiles WHERE user_id = 1;

select
    first_name,
    last_name,
    (SELECT city FROM profiles WHERE user_id = 1),
    'profile_photo'
FROM users
WHERE id = 1;

SELECT photo_id FROM profiles WHERE user_id = 1; -- photo_id => 1

SELECT file_name FROM media WHERE id = 1;

--
SELECT file_name FROM media WHERE id = (SELECT photo_id FROM profiles WHERE user_id = 1);
select
    first_name,
    last_name,
    (SELECT city FROM profiles WHERE user_id = 1),
    (SELECT file_name FROM media WHERE id = (SELECT photo_id FROM profiles WHERE user_id = 1))
FROM users
WHERE id = 1;

нюансы:
* константы, если другой id, то меняем в 3 местах.
  Мы можем из внутреннего обратиться к внешнему запросу.
* название колонок задаем через alias as

select
    first_name,
    last_name,
    (SELECT city FROM profiles WHERE user_id = users.id) AS city,
    (SELECT file_name FROM media WHERE id = (SELECT photo_id FROM profiles WHERE user_id = users.id)) AS photo_id
FROM users
WHERE id = 1;

условие where можно убрать.

## Найдем все картинки пользователя

media_type_id = 1 - картинки

SELECT file_name
FROM media
WHERE
    user_id = 1
    AND media_type_id = 1;

media_type_id = 1 - вычислим номер

SELECT id FROM media_types WHERE name = 'image';

SELECT file_name
FROM media
WHERE
    user_id = 1
    AND media_type_id = (SELECT id FROM media_types WHERE name = 'image');

Допустим мы идентификатор пользователя тоже не знаем
SELECT id FROM users WHERE email = 'user@email.com'; -- по одному
имейлу найдем только одного пользователя, из-за уникальности.
Если их будет несколько, то запрос сломается.

SELECT file_name
FROM media
WHERE
    user_id = (SELECT id FROM users WHERE email = 'user@email.com')
    AND media_type_id = (SELECT id FROM media_types WHERE name = 'image');

Найдем файлы с расширением png

SELECT * FROM media WHERE file_name LIKE '%.png';


SELECT file_name
FROM media
WHERE
    user_id = (SELECT id FROM users WHERE email = 'user@email.com')
    AND media_type_id = (SELECT id FROM media_types WHERE name = 'image')
    AND (file_name LIKE '%.png' OR file_name LIKE '%.jpg');

автор: дает 
тренажеры и ресурсы.

## Подсчитаем медиафайлы каждого типа.
SELECT count(*), media_types_id
FROM media
GROUP BY media_types_id;


SELECT count(*), media_types_id (media_types_id случайное в этом запросе)
FROM media

Выделяет в группу где media_types_id = 1, где равен 2. И применит
каунт к группе и напроитв группы поставит сумму.

## сумму размеров файлов

SELECT SUM(file_size), media_type_id
FROM media
GROUP BY media_type_id

## Считаем кол-во медиафайлы по каждому типу с названием типа

SELECT
    SUM(file_size),
    media_type_id
FROM media
GROUP BY media_type_id

SELECT name FROM media_types WHERE id = media.media_types_id;

SELECT
    SUM(file_size),
    media_type_id,
    (SELECT name FROM media_types WHERE id = media.media_types_id) -- смотрим по полу med_type_id что находится в таблице media
FROM media
GROUP BY media_type_id

## Посчитаем количество медиа файлов каждого типа для каждого пользователя.

SELECT
    SUM(file_size),
    media_type_id,
    (SELECT name FROM media_types WHERE id = media.media_types_id) -- смотрим по полу med_type_id что находится в таблице media
    user_id
FROM media
GROUP BY media_type_id, user_id -- сначала группируем по типу, затем по пользователю  
ORDER BY user_id

1:19:00

## 5. Выберем друзей пользователей.

SELECT
    to_user_id
FROM user_request
WHERE
    from_user_id = 1
    AND requests_type = 1;

SELECT from_user_id
FROM user_requests
WHERE
    to_user_id = 1
    AND requests_type = 1;

union - кол-во и типы колонок совпадали

select ... union all select ... -- без алл удаляет повторения.

SELECT DISTINGCT if(to_u_id = 1, from_u_id, to_u_id) AS friend
WHERE
    req_type = 1
    and (to_u_id = 1 or from_u_id = 1)

А вообще имеет ли смысл делать сложнее, ведь три костыля
сложнее понять чем union.

## Иммя и фамилия

SELECT CONCAT(first_name, last_name) from users where id IN (2, 3, 5, 7, 11);

SELECT CONCAT(first_name, last_name) from users where id IN (SELECT DISTINGCT if(to_u_id = 1, from_u_id, to_u_id) AS friend
WHERE
    req_type = 1
    and (to_u_id = 1 or from_u_id = 1));

select id from friend_request_types where name = accepted;

SELECT CONCAT(first_name, last_name) AS name
FROM users
WHERE id in (
SELECT DISTINGCT if(to_u_id = 1, from_u_id, to_u_id) AS friend
WHERE
    req_type = (
        select id from friend_request_types where name = accepted
    )
    and (to_u_id = 1 or from_u_id = 1)
)

## Переменные

IDEA: иногда удобно использовать переменные.
В SQL обычно не пользуются переменные, как в языках программирования.

SET @request_state_id := (select id from friend_request_types where name = accepted);
select @request_state_id;

С использованием переменных мы можем заменить на что-то карсивое.
SELECT CONCAT(first_name, last_name) AS name
FROM users
WHERE id in (
SELECT DISTINGCT if(to_u_id = 1, from_u_id, to_u_id) AS friend
WHERE
    req_type = @request_state_id
    and (to_u_id = 1 or from_u_id = 1)
)

## task 7.

SELECT user_id,
    CASE (gender)
        WHEN 'f' THEN 'female',
        WHEN 'm' THEN 'male',
        WHEN 'x' THEN 'not defined'
    END AS gender
FROM profiles;

-- age
SELECT user_id, TIMESTAMPDIFF(YEAR, NOW(), birtday) from users;

SELECT
    user_id,
    CASE (gender)
        WHEN 'f' THEN 'female',
        WHEN 'm' THEN 'male',
        WHEN 'x' THEN 'not defined'
    END AS gender,
    TIMESTAMPDIFF(YEAR, NOW(), birtday) AS age
FROM users
    WHERE user_id IN (
        SELECT from_user_id FROM friend_requests WHERE to_user_id = 1 AND request_type =
            (SELECT id FROM friend_requests_types WHERE name = 'accepted')
        UNION
        SELECT to_user_id FROM friend_requests WHERE from_user_id = 1 AND request_type =
            (SELECT id FROM friend_requests_types WHERE name = 'accepted')
    )

Минусы вложенных запросов - их читабельность.

SELECT
    CONCAT(first_name, last_name),
    (SELECT
        CASE (gender)
            WHEN 'f' THEN 'female',
            WHEN 'm' THEN 'male',
            WHEN 'x' THEN 'not defined'
        END
    FROM profile
    WHERE user_id = users.id) AS gender
FROM users
WHERE id IN (
        SELECT from_user_id FROM friend_requests WHERE to_user_id = 1 AND request_type =
            (SELECT id FROM friend_requests_types WHERE name = 'accepted')
        UNION
        SELECT to_user_id FROM friend_requests WHERE from_user_id = 1 AND request_type =
            (SELECT id FROM friend_requests_types WHERE name = 'accepted')
)

## Выведем все сообщения пользователя и выведем их по дате.

SELECT from_user_id, to_user_id, txt, is_delivered, created_at
FROM messages
WHERE (from_user_id = 1 OR to_user_id = 1) AND is_delivered = FALSE
ORDER BY created_at DESC;

(from_user_id = 1) AS sorting, по этому полю отсортируемся после.

# Курсовая может выглядеть

Книжный магазин лабиринт
Файл примерное оформление курсовой
3 файла
db.sql
минимум 10 таблиц.

Есть книга, по ней есть информация
Автор - отдельная таблица
Переводчик

пользователи дают оценки, рецензии,
Есть на сайте блок акции.

Мы видим, что есть книжная сумка с книгами - наборы.

Рассматриваем пердметную область, отталкиваясь от
значимого объекта.

Автор: показала на примере, как выполнить пункт курсовой.