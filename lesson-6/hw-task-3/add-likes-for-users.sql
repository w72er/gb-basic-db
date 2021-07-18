CREATE TABLE user_likes (
    liked_user_id BIGINT UNSIGNED NOT NULL COMMENT 'user who was liked',
    user_id BIGINT UNSIGNED NOT NULL COMMENT 'user who liked another user',
    FOREIGN KEY (liked_user_id) REFERENCES users(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    PRIMARY KEY (liked_user_id, user_id)
);

-- пусть пользователи получат лайки следующим образом
INSERT user_likes VALUES
(1, 2), (1, 3),
(2, 1),
(3, 1), (3, 2),
(4, 1),
(5, 1), (5, 2),
(6, 1),
(7, 1), (7, 2),
(8, 1),
(9, 1), (9, 2),
(10, 1),
(11, 1), (11, 2);