--
-- Подсчитайте количество дней рождения, которые приходятся на
-- каждый из дней недели. Следует учесть, что необходимы дни недели
-- текущего года, а не года рождения.
--

--
-- ANSWER
--

SELECT
	DATE_FORMAT(STR_TO_DATE(CONCAT(YEAR(NOW()), '-', MONTH(birthday_at), '-', DAY(birthday_at)), '%Y-%m-%d'), '%W') AS week_day,
    COUNT(*),
    GROUP_CONCAT(birthday_at)
FROM users
GROUP BY week_day
ORDER BY DATE_FORMAT(STR_TO_DATE(CONCAT(YEAR(NOW()), '-', MONTH(birthday_at), '-', DAY(birthday_at)), '%Y-%m-%d'), '%w');

--
-- Idea
--

SELECT YEAR(NOW()), MONTH(NOW()), DAY(NOW());

-- https://www.w3resource.com/slides/mysql-date-and-time-functions-slides-presentation.php
DATE_FORMAT()
SELECT DATE_FORMAT('2008-05-15 22:23:00', '%W');
-- https://stackoverflow.com/questions/3960049/create-date-from-day-month-year-fields-in-mysql
SELECT CONCAT(YEAR(NOW()), MONTH(NOW()), DAY(NOW());

SELECT STR_TO_DATE(CONCAT(YEAR(NOW()), '-', MONTH(NOW()), '-', DAY(NOW())), '%Y-%m-%d');

--
-- SOLUTION
--

DROP DATABASE IF EXISTS lesson5;
CREATE DATABASE lesson5;
USE lesson5;

create table users (
	id INT,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	birthday_at DATE
);
INSERT INTO users VALUES
    (1, 'Ebenezer', 'Wetherburn', '1985-09-19'),
    (2, 'Conway', 'todor', '1998-01-18'),
    (3, 'Aretha', 'Lilleyman', '1982-10-24'),
    (4, 'Masha', 'Girt', '1990-02-05'),
    (5, 'Raimondo', 'Clowney', '1989-07-10'),
    (6, 'Stoddard', 'Veracruysse', '1984-10-20'),
    (7, 'Betteann', 'Mingaud', '1995-12-26'),
    (8, 'Thurston', 'Cheson', '1992-01-08'),
    (9, 'Jolyn', 'Maltby', '1981-01-01'),
    (10, 'Bellanca', 'Feehely', '1983-07-15');

SELECT
	DATE_FORMAT(STR_TO_DATE(CONCAT(YEAR(NOW()), '-', MONTH(birthday_at), '-', DAY(birthday_at)), '%Y-%m-%d'), '%W') AS week_day,
    COUNT(*),
    GROUP_CONCAT(birthday_at)
FROM users
GROUP BY week_day
ORDER BY DATE_FORMAT(STR_TO_DATE(CONCAT(YEAR(NOW()), '-', MONTH(birthday_at), '-', DAY(birthday_at)), '%Y-%m-%d'), '%w');
