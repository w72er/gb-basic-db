--
-- 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at
-- были заданы типом VARCHAR и в них долгое время помещались значения в формате
-- 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив
-- введённые ранее значения.
--

--
-- Solution
--
DROP DATABASE IF EXISTS lesson5;
CREATE DATABASE lesson5;
USE lesson5;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    created_at VARCHAR(20) NOT NULL,
    updated_at VARCHAR(20) NOT NULL
);

INSERT users VALUES
    (DEFAULT, 'Fred', '20.10.2017 8:10', '20.10.2017 8:11'),
    (DEFAULT, 'Smith', '2.9.2014 2:08',  '2.9.2014 2:09'),
    (DEFAULT, 'Mark', '14.05.2000 23:24', '14.05.2000 23:25');

SELECT created_at, STR_TO_DATE(created_at, '%d.%m.%Y %H:%i') AS after FROM users;

ALTER TABLE users
ADD COLUMN tmp_created_at DATETIME;
ALTER TABLE users
ADD COLUMN tmp_updated_at DATETIME;

SELECT * FROM users;

UPDATE users
SET
    tmp_created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'),
    tmp_updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');

SELECT * FROM users;

ALTER TABLE users DROP COLUMN created_at;
ALTER TABLE users DROP COLUMN updated_at;
ALTER TABLE users RENAME COLUMN tmp_created_at TO created_at;
ALTER TABLE users RENAME COLUMN tmp_updated_at TO updated_at;

SELECT * FROM users;

ALTER TABLE users MODIFY COLUMN created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users MODIFY COLUMN updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
INSERT users VALUES (DEFAULT, 'Kate', DEFAULT, DEFAULT);
SELECT * FROM users;
