-- Практическое задание по теме "Хранимые процедуры и функции,
-- триггеры"

-- 1. Создайте хранимую функцию hello(), которая будет возвращать
-- приветствие, в зависимости от текущего времени суток.
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
-- с 18:00 до 00:00 — "Добрый вечер",
-- с 00:00 до 6:00 — "Доброй ночи".

USE shop;
delimiter //

DROP FUNCTION IF EXISTS hello_by_time//
CREATE FUNCTION hello_by_time(time TIME) RETURNS VARCHAR(30) DETERMINISTIC
BEGIN
	IF ('06:00' <= time AND time < '12:00') THEN
		RETURN 'Доброе утро';
	ELSEIF ('12:00' <= time AND time < '18:00') THEN
		RETURN 'Добрый день';
    ELSEIF ('18:00' <= time AND time < '00:00') THEN
		RETURN 'Добрый вечер';
    ELSEIF ('00:00' <= time AND time < '06:00') THEN
		RETURN 'Доброй ночи';
    END IF;
    
	SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Unhandled period of time';
END//

DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello() RETURNS VARCHAR(30) NOT DETERMINISTIC NO SQL
BEGIN
	DECLARE now_time TIME DEFAULT TIME(NOW());
	RETURN hello_by_time(now_time);
--	RETURN hello_by_time(TIME(NOW()));
END//

-- END	Error Code: 1418. This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in its declaration and binary logging is enabled (you *might* want to use the less safe log_bin_trust_function_creators variable)	0.000 sec

delimiter ;

SELECT hello();

SELECT hello_by_time('10:00'); -- 'Доброе утро'
SELECT hello_by_time('01:00'); -- 'Доброй ночи'