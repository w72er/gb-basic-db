DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;

USE vk;
SHOW TABLES;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    -- id SERIAL PRIMARY KEY,
    first_name VARCHAR(145) NOT NULL,
    last_name VARCHAR(145) NOT NULL,
    email VARCHAR(145) NOT NULL UNIQUE,
    -- UNIQUE unique_email(email), -- уникальность для востановления пароля.
    phone CHAR(11) NOT NULL UNIQUE,
    password_hash CHAR(65) DEFAULT NULL,
    created_at datetime not null default CURRENT_TIMESTAMP, -- NOW()
    INDEX (phone),
    INDEX (email)
);

INSERT INTO users VALUES (DEFAULT, 'John', 'Smith', 'john.smith@vk.com', '89212223334', DEFAULT, DEFAULT);
INSERT INTO users VALUES (DEFAULT, 'Katy', 'Perry', 'katy.perry@vk.com', '89212023334', DEFAULT, DEFAULT);

SELECT * FROM users;
DESCRIBE users; -- описание таблицы
SHOW CREATE TABLE users; -- скрипт создания

create TABLE profiles (
	/* такой же как и user.id, но без AUTO_INCREMENT, что бы значения не
       перепутались после вставки, то есть связь 1 к 1 не нарушилась. */
	user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    gender ENUM('f', 'm', 'x') not null,
    birthday DATE NOT NULL,
    photo_id INT UNSIGNED,
    city VARCHAR(130),
    country VARCHAR(130),
    FOREIGN KEY (user_id) REFERENCES users(id) on DELETE CASCADE on update CASCADE
    -- on delete cascede - при удалении из users, удаляется из профиля
    -- on update CASCADE - при изменении идентификатора в users, идентификатор изменится и в профиле.
    -- по умолчанию вместо cascede - restrict, то есть запрещать.
);

INSERT into profiles values (1, 'm', '1997-12-01', NULL, 'Moscow', 'Russia');
INSERT into profiles values (2, 'f', '1988-08-21', NULL, 'Moscow', 'Russia');
-- INSERT into profiles values (3, 'f', '1988-08-21', NULL, 'Moscow', 'Russia'); -- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`vk`.`profiles`, CONSTRAINT `profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`))	0.000 sec
