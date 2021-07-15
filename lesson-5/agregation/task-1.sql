--
-- 1. Подсчитайте средний возраст пользователей в таблице users.
--

-- Short answer
SELECT FORMAT(AVG( TIMESTAMPDIFF(YEAR, birthday_at, NOW()) ), 1) AS avg_age FROM users;

--
-- Solution
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


SELECT * FROM users;

SELECT FLOOR((TO_DAYS(NOW()) - TO_DAYS(birthday_at)) / 365.25) AS age FROM users;

SELECT TIMESTAMPDIFF(YEAR, birthday_at, NOW()) AS age FROM users;

SELECT FORMAT(AVG( TIMESTAMPDIFF(YEAR, birthday_at, NOW()) ), 1) AS avg_age FROM users;