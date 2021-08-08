DROP DATABASE IF EXISTS stock;
CREATE DATABASE stock;
USE stock;

DROP TABLE IF EXISTS tickers;
CREATE TABLE tickers (
	id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

INSERT INTO tickers (name) VALUES
("VTBE"), ("FXUS"), ("FXDM");

SELECT * FROM tickers;

DROP TABLE IF EXISTS deals;
CREATE TABLE deals (
	id SERIAL PRIMARY KEY,
    ticker_id BIGINT UNSIGNED NOT NULL,
    amount INT NOT NULL,
    made_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Дано:
-- | ticker | price | amount      | rate | costs, rub |
-- | vtbe   | 800   |             | 0.1  |            |
-- | fxus   | 6000  |             | 0.6  |            |
-- | fxdm   | 77    |             | 0.3  |            |
-- | total  |       |             | 1    | 30000      |
-- Вычисления:
-- | ticker | price | amount      | rate | costs, rub |
-- | vtbe   | 800   | 3,75 (4)    | 0.1  |  3000      |
-- | fxus   | 6000  | 3           | 0.6  | 18000      |
-- | fxdm   | 77    | 116.9 (116) | 0.3  |  9000      |
-- | total  |       |             | 1    | 30000      |
INSERT INTO deals (ticker_id, amount, made_at) VALUES
(1, 4, '2021-08-06 20:12:00'),
(2, 3, '2021-08-06 20:12:20'),
(3, 116, '2021-08-06 20:12:40');

SELECT * FROM deals;

/* Вывести стоимость портфеля ver 1 */
SELECT
	*,
    tickers.name AS ticker,
    deals.amount AS amount
FROM tickers
	INNER JOIN deals ON tickers.id = deals.ticker_id;

-- Добавим цену за бумагу

DROP TABLE IF EXISTS prices;
CREATE TABLE prices (
	ticker_id BIGINT UNSIGNED NOT NULL,
    price DECIMAL NOT NULL -- TODO: check kopeek size
);
INSERT INTO prices (ticker_id, price) VALUES
(1, 800),
(2, 6000),
(3, 77);

/* Вывести стоимость портфеля ver 2 */
SELECT
	*,
    tickers.name AS ticker,
    deals.amount AS amount,
    prices.price AS price
FROM tickers
	INNER JOIN deals ON tickers.id = deals.ticker_id
    INNER JOIN prices ON tickers.id = prices.ticker_id;

/* Вывести стоимость портфеля ver 3 */
SELECT
	*,
    tickers.name AS ticker,
    deals.amount AS amount,
    prices.price AS price,
    deals.amount * prices.price AS "sum"
FROM tickers
	INNER JOIN deals ON tickers.id = deals.ticker_id
    INNER JOIN prices ON tickers.id = prices.ticker_id;

/* Вывести стоимость портфеля ver 4 */
SELECT
	*,
    tickers.name AS ticker,
    deals.amount AS amount,
    prices.price AS price,
    deals.amount * prices.price AS "sum",
    sum(deals.amount * prices.price) AS "sum2"
FROM tickers
	INNER JOIN deals ON tickers.id = deals.ticker_id
    INNER JOIN prices ON tickers.id = prices.ticker_id
GROUP BY tickers.id WITH ROLLUP;

/* Вывести стоимость портфеля ver 5 */
SELECT
    tickers.name AS ticker,
    deals.amount AS amount,
    prices.price AS price,
    sum(deals.amount * prices.price) AS "sum"
FROM tickers
	INNER JOIN deals ON tickers.id = deals.ticker_id
    INNER JOIN prices ON tickers.id = prices.ticker_id
GROUP BY ticker WITH ROLLUP;
-- вывод не очень ясный, поэтому можно отдать вычисление на уровень приложения.
-- тем более выводить придется все тикеры, который будет не более 10.

-- Улучшим вариант без ROLLUP
/* Вывести стоимость портфеля ver 6 */
SELECT
    tickers.name AS ticker,
    deals.amount AS amount,
    prices.price AS price,
    deals.amount * prices.price AS "sum"
FROM tickers
	INNER JOIN deals ON tickers.id = deals.ticker_id
    INNER JOIN prices ON tickers.id = prices.ticker_id;
    
-- Проверим результат: сумма должна быть около 30000 рублей.
-- 3200 + 18000 + 8932 = 30132 - больше получилось из-за округлений
-- при вычислении количества бумаг. Поэтому будем считать результат
-- верным.