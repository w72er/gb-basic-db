/*
 * 10. Таблица с лайками медиа файлов `media_likes`.
 *
 * Медиафайлы может лайкать пользователь.
 * Один медиа файл может лайкнуть несколько пользователей.
 * Один пользователь может лайкнуть несколько медиа файлов.
 *
 * Сценарий: На медиа файле отображаются пользователи,
 * поставившие лайк на медиа файле.
 *
 * Один пользователь не может лайкнуть один медиа файл несколько
 * раз, поэтому нам не надо использовать суррогатный ключ.
 *
 * Применив составной ключ, он будет отсортирован по двум
 * столбцам сначала по `media_id`, затем по `user_id`.
 * Для основного сценария нам нужно найти для выбранного
 * медиа файла всех пользователей, но если значения и так
 * отсортированы по `media_id`, то дополнительный ключ по нему
 * не нужен.
 */
CREATE TABLE media_likes (
    media_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (media_id) REFERENCES media(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    PRIMARY KEY (media_id, user_id)
);

INSERT INTO media_likes VALUES (1, 1); -- Petya likes im.jpg
INSERT INTO media_likes VALUES (1, 2); -- Vasya likes im.jpg

/*
 * 11. Таблица с постами
 *
 * Сценарий: пролистать все посты выбранного автора.
 *
 * Автором поста является пользователь.
 * Из сценария нам хочется быстро находить посты выбранного автора,
 * поэтому заводим индекс на `author_id`.
 * Пост создается в определенное время.
 * По последней дате изменения пользователи понимают актуальность
 * поста.
 * Пост может быть размещен как в сообществе, так и у пользователя.
 * Пока не буду прорабатывать размещение поста. Однако, для решения
 * скорее всего потребуется таблица `community_posts` со связкой
 * `(post_id, community_id)`, а еще хочется не нарушать 1НФ по
 * дублированию строк, поэтому введем в таблицу `posts` суррогатный
 * первичный ключ `id`.
 * У поста есть заголовок и текст, которым пользователь хочет
 * поделиться.
 */
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    author_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    title VARCHAR(150) NOT NULL,
    text TEXT NOT NULL,
    FOREIGN KEY (author_id) REFERENCES users(id),
    INDEX idx_author_id(author_id)
);

INSERT INTO posts VALUES (DEFAULT, 1, DEFAULT, DEFAULT, 'Meeting', 'I\'m Petya, nice to meet you');

/*
 * 12. Таблица лайков постов `post_likes`.
 *
 * Аналогична талице `media_likes`
 */
CREATE TABLE post_likes (
    post_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (post_id) REFERENCES posts(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    PRIMARY KEY (post_id, user_id)
);

INSERT INTO post_likes VALUES (1, 1); -- Petya likes post meeting
INSERT INTO post_likes VALUES (1, 2); -- Vasya likes post meeting

/*
 * Таблица лайков пользователей
 *
 * Наверно лайкают профили пользователей, но мы не будем изменять
 * задание. Проблема в том, что у нас уже используется имя
 * `user_id` - и оно показывает кто поставил лайк. Назовем
 * пользователя кому ставят лайк `liked_user`.
 * В остальном таблица лайков аналогична талице `media_likes`.
 */
CREATE TABLE user_likes (
    liked_user_id BIGINT UNSIGNED NOT NULL COMMENT 'user who was liked',
    user_id BIGINT UNSIGNED NOT NULL COMMENT 'user who liked another user',
    FOREIGN KEY (liked_user_id) REFERENCES users(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    PRIMARY KEY (liked_user_id, user_id)
);

INSERT INTO user_likes VALUES (2, 1); -- Vasya likes Petya
INSERT INTO user_likes VALUES (1, 2); -- Petya likes Vasya
