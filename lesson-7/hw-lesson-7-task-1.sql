-- 1. Составьте список пользователей users,
-- которые осуществили хотя бы один заказ orders
-- в интернет магазине.

-- INSERT orders (user_id) VALUES (1), (4);
-- INSERT orders (user_id) VALUES (1), (4), (3);

-- Solution 1:
-- nested request
SELECT name
FROM users
WHERE id = ANY (SELECT DISTINCT user_id FROM orders);
-- WHERE id IN (SELECT DISTINCT user_id FROM orders);

-- Solution 2
-- use LEFT JOIN and uniq by DISTINCT
SELECT DISTINCT users.name
FROM orders
LEFT JOIN users ON (orders.user_id = users.id);