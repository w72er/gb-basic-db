DROP TABLE IF EXISTS prices;
CREATE TABLE prices (
	ticker_id BIGINT UNSIGNED NOT NULL,
    price DECIMAL NOT NULL -- TODO: check kopeek size
);
INSERT INTO prices (ticker_id, price) VALUES
    (1, 800),
    (2, 6000),
    (3, 77);
