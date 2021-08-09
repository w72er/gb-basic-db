DROP TABLE IF EXISTS tickers;
CREATE TABLE tickers (
	id SERIAL PRIMARY KEY, -- TODO: change to INT
    name VARCHAR(20) NOT NULL
);

INSERT INTO tickers (name) VALUES
("VTBE"), ("FXUS"), ("FXDM");
