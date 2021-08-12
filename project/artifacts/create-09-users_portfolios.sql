DROP TABLE IF EXISTS users_portfolios;
CREATE TABLE users_portfolios (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL
);

INSERT INTO users_portfolios (user_id) VALUES
	(1), (1), (1), (2), (3);