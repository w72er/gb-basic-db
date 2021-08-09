DROP TABLE IF EXISTS deals;
CREATE TABLE deals (
	id SERIAL PRIMARY KEY,
    ticker_id BIGINT UNSIGNED NOT NULL,
    amount INT NOT NULL,
    made_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Дано:
-- | ticker | price | amount      | rate | costs, rub |
-- | vtbe   | 800   |             | 0.1  |            |
-- | fxus   | 6000  |             | 0.6  |            |
-- | fxdm   | 77    |             | 0.3  |            |
-- | total  |       |             | 1    | 30000      |
-- Вычисления:
-- | ticker | price | amount      | rate | costs, rub |
-- | vtbe   | 800   | 3,75 (4)    | 0.1  |  3000      |
-- | fxus   | 6000  | 3           | 0.6  | 18000      |
-- | fxdm   | 77    | 116.9 (116) | 0.3  |  9000      |
-- | total  |       |             | 1    | 30000      |
INSERT INTO deals (ticker_id, amount, made_at) VALUES
(1, 4, '2021-08-06 20:12:00'),
(2, 3, '2021-08-06 20:12:20'),
(3, 116, '2021-08-06 20:12:40');
