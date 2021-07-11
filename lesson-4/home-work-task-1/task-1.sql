--
-- 1. Повторить все действия по доработке БД vk из урока.
-- a) нельзя отправить запрос дружбы самому себе
-- b) ограничение на номер телефона
-- c) photo_id - внешний ключ
--

-- a) нельзя отправить запрос дружбы самому себе
ALTER TABLE friend_requests
ADD CONSTRAINT check_not_send_friend_request_to_himself
CHECK (from_user_id != to_user_id);

INSERT friend_requests VALUES (1, 1, DEFAULT);
-- Error Code: 3819. Check constraint 'check_not_send_friend_request_to_himself' is violated.

-- b) ограничение на номер телефона
ALTER TABLE users
ADD CONSTRAINT check_phone_format
CHECK (REGEXP_LIKE(phone, '^8[0-9]{10}$'));

INSERT users
VALUES (DEFAULT, 'Bob', 'Marley', 'bob.marley@mail.com', '01234567890', DEFAULT, DEFAULT);
-- Error Code: 3819. Check constraint 'check_phone_format' is violated.

-- c) photo_id - внешний ключ
ALTER TABLE profiles
ADD CONSTRAINT fk_photo_id FOREIGN KEY (photo_id) REFERENCES media(id);
-- 2 row(s) affected Records: 2  Duplicates: 0  Warnings: 0
SHOW CREATE TABLE profiles;
-- 'profiles', 'CREATE TABLE `profiles` (\n  `user_id` bigint unsigned NOT NULL,\n  `gender` enum(\'f\',\'m\',\'x\') NOT NULL,\n  `birthday` date NOT NULL,\n  `photo_id` bigint unsigned DEFAULT NULL,\n  `city` varchar(130) DEFAULT NULL,\n  `country` varchar(130) DEFAULT NULL,\n  PRIMARY KEY (`user_id`),\n  KEY `fk_photo_id` (`photo_id`),\n  CONSTRAINT `fk_photo_id` FOREIGN KEY (`photo_id`) REFERENCES `media` (`id`),\n  CONSTRAINT `profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci'

