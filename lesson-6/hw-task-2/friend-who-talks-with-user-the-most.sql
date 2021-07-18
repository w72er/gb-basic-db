/*
 * Пусть задан некоторый пользователь.
 * Из всех друзей этого пользователя найдите человека, который больше
 * всех общался с нашим пользователем.
 * @param: user_id - идентификатор заданного пользователя.
 */
 SET @user_id := 1;
 SELECT
	(
		SELECT CONCAT(first_name, ' ', last_name)
        FROM users
        WHERE id = (IF(messages.from_user_id = @user_id, messages.to_user_id, messages.from_user_id))
	) AS friend,
	COUNT(*) AS messages_count
FROM messages
WHERE from_user_id = @user_id OR to_user_id = @user_id
GROUP BY IF(from_user_id = @user_id, to_user_id, from_user_id)
ORDER BY messages_count DESC
LIMIT 1;

--
-- Решение
--

-- Вычислим количество сообщений с каждым другом. - родительский
-- запрос, на который будем нанизывать подзапросы.
SELECT * FROM messages WHERE from_user_id = @user_id; -- id: 1,2,6,7,20
SELECT * FROM messages WHERE to_user_id = @user_id; -- id: 3,4,5,8,9,21
-- не понятно как его группировать и считать сумму.
SELECT * FROM messages WHERE from_user_id = @user_id
UNION
SELECT * FROM messages WHERE to_user_id = @user_id;

SELECT * FROM messages
WHERE from_user_id = @user_id OR to_user_id = @user_id;

-- Получим список сообщений с друзьями
SELECT
	id,
    from_user_id,
    to_user_id,
    IF (from_user_id = @user_id, to_user_id, from_user_id) AS friend_id
FROM messages
WHERE from_user_id = @user_id OR to_user_id = @user_id;
-- friend_id: count ==> 2: 5, 5: 2, 6: 2, 10: 1, 9: 1

-- Получим количество сообщений с каждым другом
SELECT
    IF (from_user_id = @user_id, to_user_id, from_user_id) AS friend_id,
	COUNT(*) AS messages_count
FROM messages
WHERE from_user_id = @user_id OR to_user_id = @user_id
GROUP BY friend_id
ORDER BY messages_count DESC
LIMIT 1;

-- Подставим first_name и last_name
SELECT CONCAT(first_name, ' ', last_name) AS name FROM users WHERE id = 2;

SELECT
	(
		SELECT CONCAT(first_name, ' ', last_name)
        FROM users
        WHERE id = (IF(messages.from_user_id = @user_id, messages.to_user_id, messages.from_user_id))
	) AS friend,
    IF(from_user_id = @user_id, to_user_id, from_user_id) AS friend_id,
	COUNT(*) AS messages_count
FROM messages
WHERE from_user_id = @user_id OR to_user_id = @user_id
GROUP BY friend_id
ORDER BY messages_count DESC
LIMIT 1;

-- Уберем из ответа лишние поля
SELECT
	(
		SELECT CONCAT(first_name, ' ', last_name)
        FROM users
        WHERE id = (IF(messages.from_user_id = @user_id, messages.to_user_id, messages.from_user_id))
	) AS friend,
	COUNT(*) AS messages_count
FROM messages
WHERE from_user_id = @user_id OR to_user_id = @user_id
GROUP BY IF(from_user_id = @user_id, to_user_id, from_user_id)
ORDER BY messages_count DESC
LIMIT 1;
