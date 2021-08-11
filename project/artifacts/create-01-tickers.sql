DROP TABLE IF EXISTS tickers;
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
