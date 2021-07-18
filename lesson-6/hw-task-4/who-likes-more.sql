-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

--
-- Answer
--

/*
 * Определить кто больше поставил лайков (всего) - мужчины или женщины?
 * Ответ приводится в столбце likes_more
 */
SELECT
	IF (
		SUM((
			SELECT IF(gender = 'm', 1, 0) AS male_likes
			FROM profiles
			WHERE user_id = all_likes.user_id
		))
		-
		SUM((
			SELECT IF(gender = 'f', 1, 0) AS female_likes
			FROM profiles
			WHERE user_id = all_likes.user_id
		))
        > 0,
        'male',
        'female'
    ) likes_more
FROM (
	SELECT * FROM posts_likes
	UNION ALL
	SELECT * FROM posts_likes
) AS all_likes;

--
-- гипотеза:
-- идея ставить лайк в колонку мужчин или женщин.
-- затем суммировать лайки по мужчинам и женщинам
-- затем вычесть суммы из друг друга, чтобы получить ответ кто больше.
--

-- проверка гипотезы:

-- разница сумм - работает
SELECT SUM(user_id) AS male_likes, SUM(like_type) AS female_likes, SUM(user_id) - SUM(like_type)
FROM posts_likes;

-- суммируем несколько таблиц и делаем для них разницу
SELECT SUM(user_id) AS male_likes, SUM(like_type) AS female_likes, SUM(user_id) - SUM(like_type)
FROM (
	SELECT * FROM posts_likes
	UNION ALL
	SELECT * FROM posts_likes
) AS all_likes;

-- гипотеза проверена, можно реализовывать

-- определим по id это мужчина или женщина, а если не тот не тот, то?
SELECT IF(gender = 'm', 1, 0) AS male_likes, IF(gender = 'f', 1, 0) AS female_likes FROM profiles WHERE user_id = 2;
SELECT IF(gender = 'm', 1, 0) AS male_likes, IF(gender = 'f', 1, 0) AS female_likes FROM profiles WHERE user_id = 1;

--
SELECT
	IF(gender = 'm', 1, 0) AS male_likes,
    IF(gender = 'f', 1, 0) AS female_likes
FROM profiles
WHERE user_id = 1;


SELECT
	IF (
		SUM((
			SELECT IF(gender = 'm', 1, 0) AS male_likes
			FROM profiles
			WHERE user_id = all_likes.user_id
		))
		-
		SUM((
			SELECT IF(gender = 'f', 1, 0) AS female_likes
			FROM profiles
			WHERE user_id = all_likes.user_id
		))
        > 0,
        'male',
        'female'
    ) likes_more,
	SUM((
		SELECT IF(gender = 'm', 1, 0) AS male_likes
		FROM profiles
		WHERE user_id = all_likes.user_id
	)) AS male_likes,
    SUM((
		SELECT IF(gender = 'f', 1, 0) AS female_likes
		FROM profiles
		WHERE user_id = all_likes.user_id
	)) AS female_likes,
    SUM((
		SELECT IF(gender = 'x', 1, 0) AS undefined_likes
		FROM profiles
		WHERE user_id = all_likes.user_id
	)) AS undefined_likes,
    COUNT(*) AS total_likes,
    SUM(user_id) - SUM(like_type)
FROM (
	SELECT * FROM posts_likes
	UNION ALL
	SELECT * FROM posts_likes
) AS all_likes;

-- убедимся что всего количество лайков 130
SELECT COUNT(*)
FROM (
	SELECT * FROM posts_likes
	UNION ALL
	SELECT * FROM posts_likes
) AS all_likes;

SELECT
	IF (
		SUM((
			SELECT IF(gender = 'm', 1, 0) AS male_likes
			FROM profiles
			WHERE user_id = all_likes.user_id
		))
		-
		SUM((
			SELECT IF(gender = 'f', 1, 0) AS female_likes
			FROM profiles
			WHERE user_id = all_likes.user_id
		))
        > 0,
        'male',
        'female'
    ) likes_more
FROM (
	SELECT * FROM posts_likes
	UNION ALL
	SELECT * FROM posts_likes
) AS all_likes;
