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

-- после реализации ФТ-05, в таблице deals стали находиться
-- не уникальные записи по тикеру.
-- поэтому необходимо представление amount_by_tickers, для
-- корректного выполения запроса print-portfolio-cost.sql.

/* Вывести стоимость портфеля ver 7 */
SELECT
    tickers.name AS ticker,
    amount_by_tickers.amount AS amount,
    prices.price AS price,
    amount_by_tickers.amount * prices.price AS "sum"
FROM tickers
	INNER JOIN amount_by_tickers ON tickers.id = amount_by_tickers.ticker_id
    INNER JOIN prices ON tickers.id = prices.ticker_id;