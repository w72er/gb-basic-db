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

-- у одного пользователя может быть несколько сообений 1:М
-- у одного сообщения один пользователь                1:1
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
    -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT
    id SERIAL PRIMARY KEY,
    from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    txt TEXT NOT NULL,
    is_delivered BOOLEAN DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
    -- поскольку очень часто будем искать по пользователям, то нужно добавить для них индексы
    -- для индекса создается отдельная структура, если таблица маленькая, то искать по ней быстро,
    -- а только тормозить операции вставки, изменения, удаления.
    INDEX messages_from_user_id_idx(from_user_id),
    INDEX messages_to_user_id_idx(to_user_id),
    -- ограничение CHECK
    CONSTRAINT fk_messages_from_user_id FOREIGN KEY (from_user_id) REFERENCES users (id),
    CONSTRAINT fk_messages_to_user_id FOREIGN KEY (to_user_id) REFERENCES users (id)
);

INSERT INTO messages VALUES (DEFAULT, 1, 2, 'HI', 1, DEFAULT);
INSERT INTO messages VALUES (DEFAULT, 1, 2, 'HI', 1, DEFAULT);

CREATE TABLE friend_requests(
    from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    accepted BOOLEAN DEFAULT FALSE,
	-- мы дважды не можем предложить дружбу одному человеку.
    -- первичный ключ уникален
    PRIMARY KEY (from_user_id, to_user_id),
    -- сочетание двух пользователей встречается
    -- можем сделать сурогатный ключ и добавить unique (from_user_id, to_user_id)
    INDEX friend_requests_from_user_id_idx(from_user_id),
    INDEX friend_requests_to_user_id_idx(to_user_id),
    -- ограничение CHECK
    CONSTRAINT fk_friend_requests_from_user_id FOREIGN KEY (from_user_id) REFERENCES users (id),
    CONSTRAINT fk_friend_requests_to_user_id FOREIGN KEY (to_user_id) REFERENCES users (id)
    -- имя ограничений удобно прописывать, тогда когда получаем ошибку, имя ограничения
    -- фигурирует в ней, тем самым мы знаем какое ограничение сработало, ведь их может
    -- быть много на один столбец.
);

INSERT INTO friends_requests (from_user_id, to_user_id) VALUES (2, 1);

CREATE TABLE communities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(255),
    admin_id BIGINT UNSIGNED NOT NULL,
    KEY (admin_id), -- зачем делать индекс, разве FOREIGN KEY не делает ее ключом?
    FOREIGN KEY (admin_id) REFERENCES users (id)
);

-- пользователи : сообщества
-- M:1
-- 1:M

-- Таблица связи пользователей и сообществALTER
CREATE TABLE communities_users(
	community_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created
    PRIMARY KEY (community_id, user_id), -- только для уникальности?
    -- поскольку очень часто будем смотреть какие пользователи входят в сообщество и
    -- какие сообщества есть у пользователя, то добавим
    KEY (community_id),
    KEY (user_id),
    FOREIGN KEY (community_id) REFERENCES communities(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE media_types (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO media_types VALUES (DEFAULT, 'изображение'), (DEFAULT, 'музыка');

CREATE TABLE media (
    id SERIAL PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    media_types_id INT UNSIGNED NOT NULL,
    file_name VARCHAR(255) COMMENT '/files/folder/img.png',
    file_size BIGINT UNSIGNED,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY (user_id),
    KEY (media_types_id),
    FOREIGN KEY (user_id)
        REFERENCES users (id),
    FOREIGN KEY (media_types_id)
        REFERENCES mediatypes (id)
);

ALTER TABLE profiles MODIFY COLUMN photo_id BIGINT UNSIGNED;
ALTER TABLE profiles ADD COLUMN passport_number VARCHAR(20);
ALTER TABLE profile RENAME COLUMN passport_number TO passport;
ALTER TABLE profile ADD KEY passport_idx (passport);
ALTER TABLE profile DROP INDEX passport_idx;
ALTER TABLE profile DROP COLUMN passport;

