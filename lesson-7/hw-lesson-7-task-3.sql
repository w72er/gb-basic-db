-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to)
-- и таблица городов cities (label, name). Поля from, to и label содержат
-- английские названия городов, поле name — русское. Выведите список
-- рейсов flights с русскими названиями городов.

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
	id SERIAL,
    `from` VARCHAR(150) NOT NULL,
    `to` VARCHAR(150) NOT NULL,
    CONSTRAINT pk_flights_id PRIMARY KEY (id)
);

INSERT flights (`from`, `to`) VALUES
('moscow', 'omsk'),
('novgorod', 'kazan'),
('irkutsk', 'moscow'),
('omsk', 'irkutsk'),
('moscow', 'kazan');

SELECT * FROM flights;

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
    label VARCHAR(150) NOT NULL,
    name VARCHAR(150) NOT NULL,
    PRIMARY KEY (label)
);

INSERT cities (label, name) VALUES
('moscow', 'Москва'),
('irkutsk', 'Иркутск'),
('novgorod', 'Новгород'),
('kazan', 'Казань'),
('omsk', 'Омск');

SELECT * FROM cities;

ALTER TABLE flights ADD CONSTRAINT fk_cities_label_from FOREIGN KEY (`from`) REFERENCES cities(label);
ALTER TABLE flights ADD CONSTRAINT fk_cities_label_to FOREIGN KEY (`to`) REFERENCES cities(label);

SELECT id, cities_from.`name`, cities_to.`name`
FROM flights
LEFT JOIN cities AS cities_from ON cities_from.label = flights.`from`
LEFT JOIN cities AS cities_to ON cities_to.label = flights.`to`;