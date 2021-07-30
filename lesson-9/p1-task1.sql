-- Практическое задание по теме "Транзакции, переменные,
-- представления"

-- 1. В базе данных shop и sample присутствуют одни и те же таблицы,
-- учебной базы данных. Переместите запись id = 1 из таблицы
-- shop.users в таблицу sample.users. Используйте транзакции.
-- to prepare shop database use file:
-- gb-basic-db\shop.sql

DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample;
USE sample;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

START TRANSACTION;

INSERT sample.users SELECT * FROM shop.users WHERE id = 1;
DELETE FROM shop.users WHERE id = 1;

COMMIT;

SELECT * FROM shop.users;
SELECT * FROM sample.users;