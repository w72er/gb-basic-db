-- Занимаемся курсовой

-- Урок 10. Вебинар. Транзакции, переменные, представления.
-- Администрирование. Хранимые процедуры и функции, триггеры

-- В некоторых компаниях есть SQL разработчики, они пишут только
-- sql код. Для не мускл есть другие реализации хранимых процедур,
-- триггеров и представлений.

/*
 * Задание 1. Написать процедуру для рекомендаций пользователю
 * новых друзей (живут в одном городе, состоят в одном сообществе)
 */

 USE vk;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_friendship_recomendation//

-- sp - saved procedure after name
CREATE PROCEDURE sp_friendship_recomendation(IN for_user_id BIGINT UNSIGNED)
BEGIN
	SELECT for_user_id;
    
	SELECT * FROM profiles;

    -- SELECT p1.user_id , p1.city, p2.user_id, p2.city - use for check how they joined
    SELECT p2.user_id
    FROM profiles AS p1
    LEFT JOIN profiles AS p2 ON (p1.city = p2.city)
    WHERE
		p1.user_id = for_user_id -- without @
        AND p1.user_id != p2.user_id
	UNION
    SELECT cu2.user_id
	FROM communities_users AS cu1
	LEFT JOIN communities_users AS cu2 ON (cu1.community_id = cu2.community_id)
	WHERE
		cu1.user_id = for_user_id
        AND cu2.user_id != for_user_id
	ORDER BY RAND()
    LIMIT 3;
END//

DELIMITER ;

SELECT cu2.user_id
FROM communities_users AS cu1
LEFT JOIN communities_users AS cu2 ON (cu1.community_id = cu2.community_id)
WHERE cu1.user_id = 2 AND cu2.user_id != 2;

CALL sp_friendship_recomendation(2);
-- a function calls by name, but procedure calls with keyword CALL

/*
 * посчитать популярность пользователя как отношения заявок в друзья.
 * популярность = (кол-во входящих заявок) \ (кол-во исходящих)
 */
DROP FUNCTION IF EXISTS func_user_popularity;
DELIMITER //
CREATE FUNCTION func_user_popularity (for_user_id BIGINT UNSIGNED)
RETURNS FLOAT READS SQL DATA
BEGIN
	DECLARE count_to_user INT;
    DECLARE count_from_user INT;
    
    SET count_to_user = (SELECT COUNT(*) FROM friend_requests WHERE to_user_id = for_user_id);
    SELECT COUNT(*) INTO count_from_user FROM friend_requests WHERE from_user_id = for_user_id;
    RETURN count_to_user / count_from_user;
END//

DELIMITER ;

-- SELECT func_user_popularity(2);
SELECT TRUNCATE(func_user_popularity(id), 1) FROM users;

-- LAST_INSERT_ID()

/*
 * Добавим нового пользователя через процедуру и транзакцию
 */
DROP PROCEDURE IF EXISTS sp_add_user;
DELIMITER //
CREATE PROCEDURE sp_add_user(
	IN first_name VARCHAR(145),
    IN last_name VARCHAR(145),
    IN email VARCHAR(145),
    IN phone VARCHAR(11),
    IN birthday DATE,
    IN gender VARCHAR(1),
    IN city VARCHAR(130),
    IN country VARCHAR(130),
    OUT tran_result VARCHAR(200)
)
BEGIN
	DECLARE tran_rollback BOOL DEFAULT 0;
    DECLARE code VARCHAR(100);
    DECLARE error_string VARCHAR(100);
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION -- handle exception;
    BEGIN
		SET tran_rollback = 1;
        
        GET STACKED DIAGNOSTICS CONDITION 1
			code = RETURNED_SQLSTATE,
            error_string = MESSAGE_TEXT;
            SET tran_result := CONCAT(code, error_string);
    END;

	START TRANSACTION;
    INSERT INTO users (first_name, last_name, email, phone)
    VALUES (first_name, last_name, email, phone);
    INSERT profiles (user_id, birthday, gender, city, country)
    VALUES (LAST_INSERT_ID(), birthday, gender, city, country);
    
    IF tran_rollback = 1 THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
END//

DELIMITER ;

-- CALL sp_add_user(
-- 	'Procedure',
--     'Transaction3',
--     'email.ru',
--     '89538083245',
--     DATE(NOW()),
--     'm',
--     'Nsk',
--     'Russia',
--     @tran_result);
-- SELECT @tran_result;

-- VIEWS

/*
 * Задание 5. Представления для вывода всех друзей пользователя.
 */
-- CREATE OR REPLACE VIEW AS SELECT *...;

-- SELECT u.id-- , u1.id AS friend_id, u1.first_name, u1.last_name
SELECT u.id, fr.from_user_id, fr.to_user_id, u1.id
	FROM users as u
	LEFT JOIN friend_requests fr ON (u.id = fr.from_user_id OR u.id = fr.to_user_id)
	JOIN users AS u1 ON (u1.id = fr.from_user_id OR u1.id = fr.to_user_id)
--    JOIN friend_request_types frt ON frt.id = fr.request_type
WHERE u.id != u1.id
ORDER BY u.id;

-- производная (временная таблица) существует на время сессии
-- SELECT rect_t.user_id FROM
-- (
-- )
-- WHERE rect_t.user_id NOT IN ();

-- trigger
-- Тот код который будет вызываться при определенных действиях
-- Если код проекта не документирован, и кто-то напишет триггер,
-- то будите долго искать такое поведение.
-- NEW - добавляемое значение.

-- Есть все процедуры индексы в SCHEMAS.
