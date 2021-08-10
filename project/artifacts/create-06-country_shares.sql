DROP TABLE IF EXISTS country_shares;
CREATE TABLE country_shares (
	id SERIAL PRIMARY KEY,
    country VARCHAR(100) NOT NULL,
    share DECIMAL NOT NULL
);

START TRANSACTION;
DELETE FROM country_shares WHERE id < 100; -- todo: remove WHERE
INSERT INTO country_shares (country, share) VALUES
    ('United States', 59.11),
	('Japan', 5.82),
	('China', 4.15),
	('United Kingdom', 3.73),
	('France', 2.98),
	('Canada', 2.86),
	('Switzerland', 2.53),
	('Germany', 2.38),
	('Australia', 1.81),
	('Taiwan', 1.8),
	('Korea (South)', 1.65),
	('India', 1.31),
	('Netherlands', 1.16),
	('Cash and/or Derivatives', 0.35),
	('Other', 8.36);
COMMIT;