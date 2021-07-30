-- Практическое задание по теме "Транзакции, переменные,
-- представления"

-- 2. Создайте представление, которое выводит название name товарной
-- позиции из таблицы products и соответствующее название каталога
-- name из таблицы catalogs.

USE shop;

SELECT products.name, catalogs.name
FROM products
LEFT JOIN catalogs ON products.catalog_id = catalogs.id;

DROP VIEW IF EXISTS short_products;

CREATE VIEW short_products (product, catalog)
AS SELECT products.name AS product, catalogs.name AS catalog
FROM products
LEFT JOIN catalogs ON products.catalog_id = catalogs.id;

SELECT * FROM short_products;
