/*
 * Вывести стоимость портфеля
 */
SELECT "Вывести стоимость портфеля";

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

