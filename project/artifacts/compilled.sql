DROP DATABASE IF EXISTS stock;
CREATE DATABASE stock;
USE stock;

CREATE TABLE tickers (
	id SERIAL PRIMARY KEY, -- TODO: change to INT
    name VARCHAR(20) NOT NULL,
    type ENUM('share', 'bond')
);

INSERT INTO tickers (name, type) VALUES
("VTBE", "share"),
("FXUS", "share"),
("FXDM", "share"),
("FXRU", "bond"),
("USD", "bond");

DELIMITER //
CREATE FUNCTION get_multiplier(ticker_id1 BIGINT UNSIGNED, made_at DATETIME) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE mul INT DEFAULT 1;
    DECLARE multiplier1 INT;
    DECLARE splitted_at1 DATETIME DEFAULT NULL;
    DECLARE done INT DEFAULT FALSE;
    DECLARE cursor_i CURSOR FOR SELECT splitted_at, multiplier FROM stock_splits WHERE ticker_id = ticker_id1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cursor_i;
    read_loop: LOOP
        FETCH cursor_i INTO splitted_at1, multiplier1;
        IF done THEN
            LEAVE read_loop;
        END IF;

		IF splitted_at1 > made_at THEN -- что-то не так с условием
			SET mul = mul * multiplier1;
		END IF;
	END LOOP;
    CLOSE cursor_i;

	RETURN mul;
END//
DELIMITER ;

CREATE TABLE prices (
	ticker_id BIGINT UNSIGNED NOT NULL,
    price DECIMAL NOT NULL, -- TODO: check kopeek size
    CONSTRAINT fk_prices_ticker_id FOREIGN KEY (ticker_id) REFERENCES tickers(id)
);
INSERT INTO prices (ticker_id, price) VALUES
    (1, 800),
    (2, 6000),
    (3, 77),
    (5, 74);

CREATE TABLE country_shares (
	id SERIAL PRIMARY KEY,
    country VARCHAR(100) NOT NULL,
    share DECIMAL NOT NULL
);

CREATE TABLE rebalance_barriers (
	barrier DECIMAL(4, 4) -- todo: check value truncated
);

INSERT INTO rebalance_barriers (barrier) VALUE (0.1);

CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

INSERT INTO users (email, password) VALUES
('ivanov.ivan@email.com', '51C908187EFA21D797AD672C87221746A31A5F178D0DB2D0185AB06E6FEEB38D'),
('petrov.petr', '4BF03016130544ABAB4E42AAC73105576399F311D6CEAE1F1FA46E32D64AF0F6'),
('sidorov.sidr', '9DCF3AB4BE6681791FC077E2868A2347F745A3FF8C26C8C29F08617819F5C362');

CREATE TABLE users_portfolios (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
    CONSTRAINT fk_users_portfolios_user_id FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users_portfolios (user_id) VALUES
	(1), (1), (1), (2), (3);

CREATE TABLE deals (
	id SERIAL PRIMARY KEY,
    portfolio_id BIGINT UNSIGNED NOT NULL,
    ticker_id BIGINT UNSIGNED NOT NULL,
    amount INT NOT NULL,
    made_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_deals_portfolio_id FOREIGN KEY (portfolio_id) REFERENCES users_portfolios(id),
    CONSTRAINT fk_deals_ticker_id FOREIGN KEY (ticker_id) REFERENCES tickers(id)
);

INSERT INTO deals (portfolio_id, ticker_id, amount, made_at) VALUES
(1, 1, 4, '2021-08-06 20:12:00'),
(1, 2, 3, '2021-08-06 20:12:20'),
(1, 3, 116, '2021-08-06 20:12:40'),
(1, 5, 200, '2021-08-06 20:13:00'),
(2, 5, 200, '2021-08-06 20:13:00'),
(3, 5, 200, '2021-08-06 20:13:00'),
(4, 5, 200, '2021-08-06 20:13:00'),
(5, 5, 200, '2021-08-06 20:13:00');

CREATE VIEW amount_by_tickers AS
	SELECT
		ticker_id,
        portfolio_id,
        sum(get_multiplier(ticker_id, made_at) * amount) AS amount
	FROM deals
    GROUP BY portfolio_id, ticker_id;