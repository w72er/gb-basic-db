--
-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными.
-- Заполните их текущими датой и временем.
--

--
-- Short answer:
--
UPDATE IGNORE users
SET created_at = NOW()
WHERE created_at IS NULL;

UPDATE IGNORE users
SET updated_at = NOW()
WHERE updated_at IS NULL;

--
-- Solution
--
DROP DATABASE IF EXISTS lesson5;
CREATE DATABASE lesson5;
USE lesson5;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL
);

INSERT users VALUES
    (DEFAULT, 'Fred', NULL, NULL),
    (DEFAULT, 'Smith', now() - interval 30 year,  now() - interval 20 year ),
    (DEFAULT, 'Mark', NULL, now() - interval 30 year);

SELECT * FROM users;

SELECT * FROM users
WHERE created_at IS NULL OR updated_at IS NULL;

UPDATE users
SET created_at = NOW()
WHERE created_at IS NULL;

UPDATE users
SET updated_at = NOW()
WHERE updated_at IS NULL;

SELECT * FROM users
WHERE created_at IS NULL OR updated_at IS NULL;
