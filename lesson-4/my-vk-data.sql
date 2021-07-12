Возможны дополнительные ограничения CONSTRAINTS.

USE vk;

-- чтобы не было запроса дружбы самому себе
-- добавляем ограничение, что отправитель дружбы не может
-- быть получателем
ALTER TABLE friend_requests
ADD CONSTRAINT sender_not_receiver_check
CHECK (from_user_id != to_user_id);

-- автор: поставила под сомнение свой ответ о возможности
-- задать ограничения только через триггеры, и на следующий
-- урок показала задание ограничений через условие.

-- Если задаются ограничения даже на where, то они могут
-- быть очень длинный список, и поэтому задание имени
-- ограничению становится актуальным.

-- Номер должен состоять из 11 символов и только цифр
-- наверное менее удобное ограничение, ведь мы не можем
-- нанизывать ограничения, поэтому указывая все ограничения
-- сразу на поле, мы не будем размазывать ограничения для
-- одного поля. Хотя может и сложнее из одного ограничения
-- вычленять условия.

-- вариант 1 не полный:
ALTER TABLE users
ADD CONSTRAINT phone_length_is_11
CHECK (LEN(phone) == 11)

-- вариант 2 - авторский
ALTER TABLE users
ADD CONSTRAINT phone_check -- _check говорит какого плана
                           -- ограничение
CHECK (REGEXP_LIKE(phone, '^[0-9]{11}$'))

-- regex101.com - по составлению регулярных выражений.

-- вопрос: а как я бы догадался что для фото нет fk?
-- Может есть чек листы? Или статические анализаторы?
-- делаем FOREIGN KEY на `media`
-- я ведь сам его могу написать, например, задавая вопросы:
-- 1) это поле ссылка на что-то (xxx_id)?
-- 2) какие ограничения есть на поле
-- 3) нормальные формы у таблицы
ALTER TABLE profiles
ADD CONSTRAINT fk_profiles_media
FOREIGN KEY (photo_id) REFERENCES media (id);

-- автор: как же офигенно когда автор показывает как читать
-- документацию, потому что это отдельный навык, понять как
-- читать документацию.

-- смотрим insert в документации dev.mysql.com/doc/../insert.html
-- три разных варианта
-- если ключевое слово в [INTO], то можем не указывать.
-- | - значение на выбор
-- IGNORE - игнорирует если есть дубли, либо проблемы при
-- вставке.

-- Минимальный набор для выполнения команды вставки

-- что-то не минимальный набор
-- при перечислении колонок убедитесь в их порядке.
-- Чтобы не писать значение по умолчанию, то можно его не писать
-- или указать default
INSERT user (id, first_name, last_name, email)
VALUE (DEFAULT, 'alex', 'stepanov', 'alex.stepanov@mail.ru')

-- поскольку email уникален, то мы не сможем выполнить ее по
-- конфиликту email
INSERT IGNORE user (id, first_name, last_name, email)
VALUE (DEFAULT, 'alex', 'stepanov', 'alex.stepanov@mail.ru')

-- не указываем DEFAULT-значения
INSERT users (first_name, last_name, email, phone)
VALUES ();
-- тут добавился этот пользователь перепрыгнув `id`
-- это объясняется тем, что при попытке вставить дублирующуюся
-- запись запись не произошла, но счетчик увеличился.
-- Состояние счетчика можно изменить через ALTER

-- Такой записью мы обязаны перечислить все поля, иначе получим
-- ошибку, несоответствия кол-ва колонок и кол-ва значений.
INSERT users
VALUES (DEFAULT, ..., DEFAULT, DEFAULT);

-- Для DEFAULT-значений можем явно указать значение, только
-- для PRIMARY KEY, нужно убедиться в уникальности.
INSERT users
VALUES (22, ..., DEFAULT, DEFAULT);

-- Запись через VALUES хороша добавлением нескольких записей
INSERT users (first_name, last_name, email, phone)
VALUES ('Igor', 'Petrov', 'igor.petrov@mail.ru', '8477232084204'),
       ('Igor', 'Petrov', 'igor.petrov@mail.ru', '8477232084204');


-- INSERT SET
-- Используется внутри query builder ов или фреймворков.
INSERT users
SET first_name = 'Iren',
    last_name = 'Stepanova',

-- Есть таблица из которой мы хотим импортировать часть данных.
-- тоесть из vk.users в temp_db.users;
-- шаг1 Создадим в тестовой базе таблицу users
SHOW CREATE TABLE users;
-- из таблицы убрали автоинкремент с 59 идентификатора
-- а так же убрали внешние ключи.
USE vk;
INSERT users (first_name, last_name, email, phone)
SELECT first_name, last_name, email, phone
FROM temp_db.users;

--
-- SELECT
--
-- GROUP BY - группировка для использования агрегирующих функций
-- вывести среднее, мин, макс
-- HAVING - для работы с вычисленными сгруппированными значениями

SELECT 1; -- Вывод константы
SELECT 1+10; -- Вычисление
-- dbeaver возвращает максимум 200 записей.
-- но если будем возвращать без limit, иначе повесите

SELECT first_name FROM users;
-- ALL не убираем повторы first_name
-- DISTINCK -- убирает повторы.

WHERE id <= 10
WHERE id BETWEEN 3 and 7 -- с включением границ
-- проверка на пустое значение (NULL)
-- любая операция с null - неизвестность, поэтому null == null = null
-- поэтому используем IS NULL
WHERE password_hash IS NOT NULL;

-- Выбор первых четырех пользователей
-- вариант 1:
ORDER BY id DESC -- по возрастанию
LIMIT 4; -- первые четыре

ORDER BY id LIMIT 1 OFFSET 3; -- отступить 3 и взять 1

-- 1:19:38
--
-- UPDATE
--
UPDATE messages
SET is_delivered = TRUE;

UPDATE messages
SET txt='I love you'
WHERE id = 5;

--
-- DELETE, TRUNCATE
--
DELETE FROM users
WHERE last_name = 'Stepanov';

-- Можем удалить все из таблицы сообщений двумя способами
-- Способ 1:
DELETE FROM messages; -- удаляет строки по одной, поэтому
                      -- id не сбрасывается
-- Способ 2:
TRUNCATE FROM messages; -- вся таблица удаляется быстрее, т.к.
                        -- удаляется сразу вся таблица
                        -- удаляются без fk
SET FOREIGN_KEY_CHECK = 0;
TRUNCATE FROM messages;
SET FOREIGN_KEY_CHECK = 0;

-- Как наполнить БД тестовыми данными.
-- Существуют разные сервисы или языки программирования
-- filldb.info - его минус не в гибкости
-- Скопируем схему
-- Генерируем таблицы, чьи данные не от чего не зависят.
-- Переходим
-- Внешние ключи: users, id, 1

-- mockaroo.com
-- Минус - ручной ввод таблиц.
-- Плюс - подкупает гибкая настройка данных.

-- В третьей нормальной форме все столбцы зависят от
-- первичного ключа. Если будем рисовать стрелочки, от
-- первичного ключа к столбцам, то увидим зависимость
-- только от него.
-- В таблице users мы могли бы пользоваться НАТУРАЛЬНЫМИ
-- ПЕРВИЧНЫМИ КЛЮЧАМИ email, phone, но удобнее
-- пользоваться суррогатным первичным ключом.


-- ДЗ
-- первое задание -- скриншот из dbeaver
-- по третьему заданию будет видно, что с первым вы
-- разобрались.