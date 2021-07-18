/*
 * Подсчитать общее количество лайков, которые получили 10 самых
 * молодых пользователей.
 */
WITH ten_youngest_users AS (
    SELECT *
	FROM profiles
    ORDER BY birthday DESC
    LIMIT 10
)
SELECT COUNT(*)
FROM user_likes
WHERE liked_user_id IN (SELECT user_id FROM ten_youngest_users);

--
-- Решение
--

-- что такое лайки?
SELECT COUNT(*) FROM users; -- 11 users

SELECT * FROM user_likes;

-- top ten youngest users
SELECT *
FROM profiles
ORDER BY birthday DESC
LIMIT 10;

-- 18:10:27	SELECT 1 IN ( SELECT * FROM profiles ORDER BY birthday DESC LIMIT 10 ) LIMIT 0, 1000
-- Error Code: 1235. This version of MySQL doesn't yet support 'LIMIT & IN/ALL/ANY/SOME subquery'
-- SELECT 1 IN (
--     SELECT *
--     FROM profiles
--     ORDER BY birthday DESC
--     LIMIT 10
-- );

-- https://stackoverflow.com/questions/53397668/mysql-set-a-variable-with-a-list
-- LIMIT affects to COUNT? -- нет, он только на результирующий вывод.
-- Поэтому и не получится сохранить в переменную выражение с LIMIT.
SELECT COUNT(*)
FROM profiles
ORDER BY birthday DESC
LIMIT 10;

-- Попытаемся вывести порядковый номер записи и отфильтровать по
-- значениям меньше 10.
SELECT ROW_NUMBER() OVER (ORDER BY birthday DESC) AS no1, user_id, birthday
FROM profiles;
-- WHERE no1 < 11;

-- with tbl as ()
WITH tbl AS (
	SELECT * FROM profiles
)
SELECT user_id
FROM tbl;

-- use limit WITH_SELECT
WITH tbl AS (
    SELECT *
	FROM profiles
    ORDER BY birthday DESC
    LIMIT 10
)
SELECT user_id
FROM tbl;

-- use CONCAT with WITH+LIMIT
WITH tbl AS (
    SELECT *
	FROM profiles
    ORDER BY birthday DESC
    LIMIT 10
)
SELECT GROUP_CONCAT(user_id)
FROM tbl;
--  9 7 6 11 3 10 2 1 5 4
-- '9,7,6,11,3,10,2,1,5,4'

-- IN (SELECT tbl) works?
WITH tbl AS (
    SELECT *
	FROM profiles
    ORDER BY birthday DESC
    LIMIT 10
)
SELECT *
FROM user_likes
WHERE liked_user_id IN (SELECT user_id FROM tbl);
-- without user_id = 8 - ok

-- Сумма этих строк соответствует количеству лайков ответа.
-- Посчитаем сумму.
WITH ten_youngest_users AS (
    SELECT *
	FROM profiles
    ORDER BY birthday DESC
    LIMIT 10
)
SELECT COUNT(*)
FROM user_likes
WHERE liked_user_id IN (SELECT user_id FROM ten_youngest_users);

-- Количество лайков в файле add-likes-for-users.sql без
-- лайков 8 пользователя, составляет 16.