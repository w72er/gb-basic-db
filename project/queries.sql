/*
 * Поскольку ценные бумаги со временем могут разделиться,
 * чтобы покупатели сохранили покупательскую способность
 * бумаги, при многократном ее росте. Поэтому создадим
 * функцию get_multiplier, которая по тикеру и дате
 * приводит прошлое количество ценной бумаги к текущему
 * количеству.
 * Функция базируется на таблице таблице разделений
 * ценных бумаг stock_splits.
 * Подробнее см. ФТ-04.
 * @returns множитель количества актуального количества
 * ценной бумаги
 * @param ticker_id1 - идентификатор ценной бумаги
 * @param made_at - дата, когда была куплена ценная
 * бумага
 */
DELIMITER //
CREATE FUNCTION get_multiplier(ticker_id BIGINT UNSIGNED, made_at DATETIME) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE mul INT DEFAULT 1;
    DECLARE multiplier INT;
    DECLARE splitted_at DATETIME DEFAULT NULL;
    DECLARE done INT DEFAULT FALSE;
    DECLARE cursor_i CURSOR FOR SELECT `splitted_at`, `multiplier` FROM stock_splits WHERE `ticker_id` = ticker_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cursor_i;
    read_loop: LOOP
        FETCH cursor_i INTO splitted_at, multiplier;
        IF done THEN
            LEAVE read_loop;
        END IF;

		IF splitted_at > made_at THEN
			SET mul = mul * multiplier;
		END IF;
	END LOOP;
    CLOSE cursor_i;

	RETURN mul;
END//
DELIMITER ;

/*
 * Поскольку непосредственно использовать
 * таблицу deals для определения количества
 * ценных бумаг невозможно из-за разделения ценных
 * бумаг, выставим представление в интерфейс, решающее
 * эту проблему.
 */
CREATE VIEW amount_by_tickers AS
	SELECT
		ticker_id,
        portfolio_id,
        sum(get_multiplier(ticker_id, made_at) * amount) AS amount
	FROM deals
    GROUP BY portfolio_id, ticker_id;

/*
 * Вывести стоимость портфеля
 * @params: tickers.type - выводит бумаги акций ("share")
 * или облигаций ("bond")
 */
SELECT
    tickers.name AS ticker,
    amount_by_tickers.amount AS amount,
    prices.price AS price,
    amount_by_tickers.portfolio_id,
    amount_by_tickers.amount * prices.price AS "sum"
FROM tickers
	left JOIN amount_by_tickers ON tickers.id = amount_by_tickers.ticker_id
    left JOIN prices ON tickers.id = prices.ticker_id
WHERE tickers.type = 'share' AND amount_by_tickers.portfolio_id = 1;
