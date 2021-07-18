--
-- Найти 10 пользователей, которые проявляют наименьшую
-- активность в использовании социальной сети.
--

--
-- ANSWER
--

/*
 * Найти 10 пользователей, которые проявляют наименьшую
 * активность в использовании социальной сети.
 *
 * Под активностью понимаем сумму всех лайков, постов
 * и сообщений пользователя.
 */
SELECT
	CONCAT(first_name, ' ', last_name) AS name,
    (
		(SELECT COUNT(*) FROM messages WHERE from_user_id = users.id) +
		(SELECT COUNT(*) FROM user_likes WHERE user_id = users.id) +
		(SELECT COUNT(*) FROM posts WHERE user_id = users.id)
    ) AS actions_amount
FROM users
ORDER BY actions_amount
LIMIT 10;

--
-- РЕШЕНИЕ
--

-- Гипотеза:
SELECT
	id,
    RAND() AS message_count,
	RAND() AS user_likes_count,
	RAND() AS posts_count,
    (
		RAND() +
		RAND() +
		RAND()
    ) AS value
FROM users
ORDER BY value DESC
LIMIT 10;

-- последний кирпичек - вычислим количество постов
-- написанных пользователем по его идентификатору
SELECT COUNT(*) FROM posts WHERE user_id = 1;

-- подставим кол-во постов в гипотезу:
SELECT
	id,
    RAND() AS message_count,
	RAND() AS user_likes_count,
	(SELECT COUNT(*) FROM posts WHERE user_id = users.id) AS posts_count,
    (
		RAND() +
		RAND() +
		(SELECT COUNT(*) FROM posts WHERE user_id = users.id)
    ) AS value
FROM users
ORDER BY value DESC
LIMIT 10;

-- гипотеза подтвердилась, тогда заполним кол-во лайков и сообщений.

-- посчитаем кол-во лайков, которые поставил пользователь.
SELECT COUNT(*) FROM user_likes WHERE user_id = 1;

-- посчитаем кол-во сообщений от пользователя.
SELECT COUNT(*) FROM messages WHERE from_user_id = 1;

-- подставим кол-во лайков и кол-во сообщений в родительский запрос.
SELECT
	id,
    RAND() AS message_count,
	RAND() AS user_likes_count,
	(SELECT COUNT(*) FROM posts WHERE user_id = users.id) AS posts_count,
    (
		(SELECT COUNT(*) FROM messages WHERE from_user_id = users.id) +
		(SELECT COUNT(*) FROM user_likes WHERE user_id = users.id) +
		(SELECT COUNT(*) FROM posts WHERE user_id = users.id)
    ) AS value
FROM users
ORDER BY value DESC
LIMIT 10;

-- уберем лишние поля и добавим имя пользователя
-- забыл про неактивных пользователей, значит ASC
SELECT
	CONCAT(first_name, ' ', last_name) AS name,
    (
		(SELECT COUNT(*) FROM messages WHERE from_user_id = users.id) +
		(SELECT COUNT(*) FROM user_likes WHERE user_id = users.id) +
		(SELECT COUNT(*) FROM posts WHERE user_id = users.id)
    ) AS actions_amount
FROM users
ORDER BY actions_amount
LIMIT 10;