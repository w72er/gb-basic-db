/*
 * Подсчитать общее количество лайков, которые получили 10 самых
 * молодых пользователей.
 */

 -- что такое лайки?
 SELECT COUNT(*) FROM users; -- 11 users

 SELECT * FROM user_likes;

 SELECT
	liked_user_id,
    COUNT(*)
 FROM user_likes
 GROUP BY liked_user_id;

 -- check possibility LIMIT 10 and ORDER BY id;

SELECT
	liked_user_id,
    COUNT(*)
 FROM user_likes
 GROUP BY liked_user_id
 ORDER BY liked_user_id DESC
 LIMIT 10;

-- use birthday for sorting
SELECT birthday FROM profiles WHERE user_id = 1;
SELECT
	liked_user_id,
    (SELECT birthday FROM profiles WHERE user_id = user_likes.liked_user_id) AS birthday,
    COUNT(*)
FROM user_likes
GROUP BY liked_user_id
ORDER BY birthday DESC
LIMIT 10;

-- use name for user
SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = 2;

SELECT
	liked_user_id,
    (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_likes.liked_user_id) AS name,
    (SELECT birthday FROM profiles WHERE user_id = user_likes.liked_user_id) AS birthday,
    COUNT(*)
FROM user_likes
GROUP BY liked_user_id
ORDER BY birthday DESC
LIMIT 10;

-- А почему я не использую IN? Потому что не смогу выбрать 10 из-за дырявых лайков.
-- получить 10 пользователей я не смогу без их группировки, поэтому не получится просто упорядочить по дате рождения все лайки

-- not works
-- SELECT
-- 	SUM((
-- 		SELECT id FROM users
--     ));

-- not works
-- SELECT *
-- FROM (
-- 	SELECT id FROM users
-- )

-- not works
-- SELECT
-- 	liked_user_id,
--     (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_likes.liked_user_id) AS name,
--     (SELECT birthday FROM profiles WHERE user_id = user_likes.liked_user_id) AS birthday,
-- 	COUNT(*) as total,
--     SUM(total)
-- FROM user_likes
-- GROUP BY liked_user_id
-- ORDER BY birthday DESC
-- LIMIT 10;

-- !!! как использовать результат функции в другой функции агрегации?

-- есть еще WITH ROLLUP
-- SELECT
-- 	liked_user_id,
--     (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_likes.liked_user_id) AS name,
--     (SELECT birthday FROM profiles WHERE user_id = user_likes.liked_user_id) AS birthday,
--     COUNT(*)
-- FROM user_likes
-- GROUP BY liked_user_id
-- WITH ROLLUP
-- ORDER BY birthday DESC
-- LIMIT 10;

-- 10 молодых пользователей.
SELECT birthday
FROM profiles
ORDER BY birthday DESC
LIMIT 10;

-- все лайки 10 молодым пользователям
-- not work
-- SELECT
-- 	liked_user_id
-- FROM user_likes
-- WHERE
-- 	liked_user_id IN (
-- 		SELECT birthday
-- 		FROM profiles
-- 		ORDER BY birthday DESC
-- 		LIMIT 10
-- 	)
-- error: more than 1 row.
SET @ten_youngest = (SELECT birthday
		FROM profiles
		ORDER BY birthday DESC
		LIMIT 10);
SELECT
	liked_user_id
FROM user_likes
WHERE
	liked_user_id IN (@ten_youngest);