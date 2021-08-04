-- Практическое задание по теме "Оптимизация запросов"
-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании
-- записи в таблицах users, catalogs и products в таблицу logs
-- помещается время и дата создания записи, название таблицы,
-- идентификатор первичного ключа и содержимое поля name.

USE shop;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
--    id SERIAL PRIMARY KEY,
--    Error Code: 1069. Too many keys specified; max 1 keys allowed
--    https://coderoad.ru/56280866/%D0%9A%D0%B0%D0%BA-%D0%B8%D1%81%D0%BF%D1%80%D0%B0%D0%B2%D0%B8%D1%82%D1%8C-%D0%BE%D1%88%D0%B8%D0%B1%D0%BA%D1%83-Too-many-keys-specified-max-1-keys-allowed
	id BIGINT NOT NULL AUTO_INCREMENT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    table_name VARCHAR(255) NOT NULL,
    primary_key_id BIGINT UNSIGNED NOT NULL,
    name_value VARCHAR(255) NOT NULL,
    KEY (id)
) ENGINE="Archive";

DROP PROCEDURE IF EXISTS proc_add_log;
DELIMITER //
CREATE PROCEDURE proc_add_log(
	IN table_name VARCHAR(255),
    IN primary_key_id BIGINT UNSIGNED,
    IN name_value VARCHAR(255))
BEGIN
	INSERT logs VALUES (DEFAULT, DEFAULT, table_name, primary_key_id, name_value);
END//
DELIMITER ;

DROP TRIGGER IF EXISTS trigger_log_catalog;
DELIMITER //
CREATE TRIGGER trigger_log_catalog AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
    CALL proc_add_log("catalogs", NEW.id, NEW.name);
END//
DELIMITER ;

DROP TRIGGER IF EXISTS trigger_log_product;
DELIMITER //
CREATE TRIGGER trigger_log_product AFTER INSERT ON products
FOR EACH ROW
BEGIN
    CALL proc_add_log("products", NEW.id, NEW.name);
END//
DELIMITER ;

DELETE FROM catalogs WHERE name IN ("Корпус", "Кулер");
INSERT catalogs (name) VALUES ("Корпус"), ("Кулер");
SELECT * FROM logs;

-- DELETE FROM products WHERE name IN ("Intel Core i5-8400");
INSERT products (name, description, price, catalog_id)
VALUE ('Intel Core i5-8400', 'intel', 22700.00, '1');
SELECT * FROM logs;

-- К сожалению, нет таблицы users, но создавать триггер по подобию.
-- При `engine="archive"` не возможно создать ключ, см. описание движка.