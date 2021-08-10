DROP TABLE IF EXISTS stock_splits;
CREATE TABLE stock_splits (
	id SERIAL PRIMARY KEY,
    ticker_id BIGINT UNSIGNED NOT NULL,
    multiplier INT NOT NULL,
    splitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

TRUNCATE TABLE deals;
INSERT INTO deals (ticker_id, amount, made_at) VALUES
	(1, 4, '2021-08-06 20:12:00'),
	(2, 3, '2021-08-06 20:12:20'),
	(3, 116, '2021-08-06 20:12:40'),
    (2, 3, '2021-08-06 20:14:20'),
    (2, 3, '2021-08-06 20:16:20');

INSERT INTO stock_splits (ticker_id, multiplier, splitted_at) VALUES
	(2, 10, '2021-08-06 20:12:21'),
    (2, 2, '2021-08-06 20:14:21');

DROP FUNCTION IF EXISTS get_multiplier;
DELIMITER //
-- DETERMINISTIC, NO SQL, or READS SQL DATA

-- https://stackoverflow.com/questions/5817395/how-can-i-loop-through-all-rows-of-a-table-mysql
CREATE FUNCTION get_multiplier(ticker_id BIGINT UNSIGNED, made_at DATETIME) RETURNS INT READS SQL DATA
BEGIN
    DECLARE mul INT DEFAULT 1;
    DECLARE multiplier INT DEFAULT NULL;
    DECLARE splitted_at DATETIME DEFAULT NULL;
    DECLARE done INT DEFAULT FALSE;
    DECLARE cursor_i CURSOR FOR SELECT splitted_at, multiplier FROM stock_splits WHERE ticker_id = ticker_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cursor_i;
    read_loop: LOOP
        FETCH cursor_i INTO splitted_at, multiplier;
        IF done THEN
            LEAVE read_loop;
        END IF;

--        IF splitted_at < made_at THEN -- что-то не так с условием
--            SET mul = mul * multiplier;
--        END IF;
        SET mul = mul * 2;
    END LOOP;
    CLOSE cursor_i;

	RETURN mul;
END//
DELIMITER ;

SELECT get_multiplier(1, '2021-08-06 20:12:20');
