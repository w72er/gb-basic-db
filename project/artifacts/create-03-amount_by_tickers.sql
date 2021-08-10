-- после реализации ФТ-05, в таблице deals стали находиться
-- не уникальные записи по тикеру.
-- поэтому необходимо представление amount_by_tickers, для
-- корректного выполения запроса print-portfolio-cost.sql.
SELECT * FROM deals;
SELECT ticker_id, sum(amount) AS amount FROM deals GROUP BY ticker_id;

DROP VIEW IF EXISTS amount_by_tickers;
CREATE VIEW amount_by_tickers AS
	SELECT ticker_id, sum(amount) AS amount
	FROM deals
    GROUP BY ticker_id;

SELECT * FROM amount_by_tickers;

-- Проверка для ticker_id = 1 количество совпадает с количеством
-- в запросе ниже.
-- SELECT * FROM deals WHERE ticker_id = 1;

DROP VIEW IF EXISTS amount_by_tickers;
CREATE VIEW amount_by_tickers AS
	SELECT ticker_id, sum(get_multiplier(ticker_id, made_at) * amount) AS amount
	FROM deals
    GROUP BY ticker_id;
