-- 2. Выведите список товаров products и разделов
-- catalogs, который соответствует товару.

-- Solution 1
-- nested request
SELECT
	name,
    description,
    (SELECT name FROM catalogs WHERE id = products.catalog_id) as catalog_name
FROM products;

-- solution 2
-- join
SELECT
	name,
    description,
    catalogs.name as catalog_name
FROM products
JOIN catalogs ON catalogs.id = products.catalog_id;
