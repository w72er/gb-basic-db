DROP DATABASE IF EXISTS stock;
CREATE DATABASE stock;
USE stock;

/*
 * Ценные бумаги идентифицируются по своеобразному названию
 * - тикеру. При долгосрочной пассивной стратегии
 * с разделением капитала на акции и облигации, следует
 * хранить тип ценной бумаги.
 */
CREATE TABLE tickers (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    type ENUM('share', 'bond')
);

INSERT INTO tickers (name, type) VALUES
("VTBE", "share"),
("FXUS", "share"),
("FXDM", "share"),
("FXRU", "bond"),
("USD", "bond");

/*
 * Список текущих цен ценных бумаг.
 */
CREATE TABLE prices (
	ticker_id SMALLINT UNSIGNED NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    CONSTRAINT fk_prices_ticker_id FOREIGN KEY (ticker_id) REFERENCES tickers(id)
);
INSERT INTO prices (ticker_id, price) VALUES
    (1, 800),
    (2, 6000),
    (3, 77),
    (5, 74);

/*
 * Стратегия формирования всех портфелей ценных
 * бумаг приложения базируется на соотношении
 * ценных бумаг стран мира. В таблице
 * представлено соотношение разных стран, по
 * которому приложение выбирает ценные бумаги
 * содержащие акции стран или регионов, например,
 * FXDM - акции развитых стран, за исключение США.
 */
CREATE TABLE country_shares (
	id SERIAL PRIMARY KEY,
    country VARCHAR(100) NOT NULL,
    share DECIMAL NOT NULL
);

/*
 * Для получения портфельного эффекта - покупки обесценившихся
 * ценных бумаг, необходимо знать барьер "обесценки" бумаг
 * акций и облигаций.
 * В настоящее время параметр глобальный, поскольку клиенты
 * приложения - россияне, со статусом неквалифицированного
 * инвестора. И коэффициент подбирается автоматически
 * оптимальным по налогооблажению и другим издержкам.
 */
CREATE TABLE rebalance_barriers (
	barrier DECIMAL(4, 4)
);

INSERT INTO rebalance_barriers (barrier) VALUE (0.1);

/*
 * Пользователи системы.
 * Поскольку приложние - не социальная сеть,
 * пользователю требуется лишь войти в систему.
 */
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

INSERT INTO users (email, password) VALUES
('ivanov.ivan@email.com', '51C908187EFA21D797AD672C87221746A31A5F178D0DB2D0185AB06E6FEEB38D'),
('petrov.petr', '4BF03016130544ABAB4E42AAC73105576399F311D6CEAE1F1FA46E32D64AF0F6'),
('sidorov.sidr', '9DCF3AB4BE6681791FC077E2868A2347F745A3FF8C26C8C29F08617819F5C362');

/*
 * Под портфелем понимается группировка пользователем
 * ценных бумаг для одной цели согласно правилам
 * формирования портфеля. У одного пользователя может
 * быть несколько портфелей.
 */
CREATE TABLE users_portfolios (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
    CONSTRAINT fk_users_portfolios_user_id FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users_portfolios (user_id) VALUES
	(1), (1), (1), (2), (3);

/* Пользователь покупает или продает ценные бумаги,
 * то есть совершает сделки в конкретный портфель.
 */
CREATE TABLE deals (
	id SERIAL PRIMARY KEY,
    portfolio_id BIGINT UNSIGNED NOT NULL,
    ticker_id SMALLINT UNSIGNED NOT NULL,
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

/*
 * Поскольку портфели не формируются сами по себе,
 * а для конкретных целей, то требуется описывать цели.
 */
CREATE TABLE goals (
    portfolio_id BIGINT UNSIGNED NOT NULL,
    txt TEXT NOT NULL,
    CONSTRAINT fk_goals_portfolio_id FOREIGN KEY (portfolio_id) REFERENCES users_portfolios(id)
);

INSERT INTO goals (portfolio_id, txt) VALUES
	(1, "я просто люблю бабулесики"),
    (2, "коплю на поездку в Кипр в ноябре $3000"),
	(3, "Хочу накопить денег на черный день"),
    (4, "-"),
    (5, "На гастро тур");

/*
 * Хранит информацию о разделении ценной бумаги.
 */
CREATE TABLE stock_splits (
	id SERIAL PRIMARY KEY,
    ticker_id SMALLINT UNSIGNED NOT NULL,
    multiplier INT NOT NULL,
    splitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_stock_splits_ticker_id FOREIGN KEY (ticker_id) REFERENCES tickers(id)
);

INSERT INTO stock_splits (ticker_id, multiplier, splitted_at) VALUES
	(2, 10, '2021-08-06 20:12:21'),
    (2, 2, '2021-08-06 20:14:21');
