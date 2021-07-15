--
-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться
-- самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются
-- запасы. Необходимо отсортировать записи таким образом, чтобы они выводились
-- в порядке увеличения значения value. Однако нулевые запасы должны выводиться
-- в конце, после всех записей.
--

--
-- Answer
--
-- SELECT * FROM storehouses_products ORDER BY IF(value > 0, 1, 0) DESC, value ASC;

--
-- Solution
--
DROP DATABASE IF EXISTS lesson5;
CREATE DATABASE lesson5;
USE lesson5;

CREATE TABLE storehouses_products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    value INTEGER DEFAULT 0
);

INSERT storehouses_products VALUES
    (DEFAULT, 'Alpro', 0),
    (DEFAULT, 'Carnation', 2500),
    (DEFAULT, 'Coca-Cola', 0),
    (DEFAULT, 'Horlicks', 30),
    (DEFAULT, 'Killer Shake', 500),
    (DEFAULT, 'Nesquik', 1);

SELECT * FROM storehouses_products;

SELECT *, IF(value > 0, 1, 0) AS zero FROM storehouses_products ORDER BY zero DESC, value ASC;

SELECT * FROM storehouses_products ORDER BY IF(value > 0, 1, 0) DESC, value ASC;