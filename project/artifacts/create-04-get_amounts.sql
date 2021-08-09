DROP TABLE IF EXISTS stock_splits;
CREATE TABLE stock_splits (
	id SERIAL PRIMARY KEY,
    ticker_id BIGINT UNSIGNED NOT NULL,
    multiplicator INT NOT NULL,
    splitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

TRUNCATE TABLE deals;
INSERT INTO deals (ticker_id, amount, made_at) VALUES
	(1, 4, '2021-08-06 20:12:00'),
	(2, 3, '2021-08-06 20:12:20'),
	(3, 116, '2021-08-06 20:12:40'),
    (2, 3, '2021-08-06 20:14:20'),
    (2, 3, '2021-08-06 20:16:20');

INSERT INTO stock_splits (ticker_id, multiplicator, splitted_at) VALUES
	(2, 10, '2021-08-06 20:12:21'),
    (2, 2, '2021-08-06 20:14:21');

DROP FUNCTION IF EXISTS get_amounts;
DELIMITER //
-- DETERMINISTIC, NO SQL, or READS SQL DATA

-- https://stackoverflow.com/questions/5817395/how-can-i-loop-through-all-rows-of-a-table-mysql
CREATE FUNCTION get_amounts() RETURNS INT DETERMINISTIC
BEGIN
	RETURN 1;
END//
DELIMITER ;

SELECT get_amounts();