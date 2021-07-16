--
-- 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.
--

--
-- SOLUTION
--

DROP DATABASE IF EXISTS lesson5;
CREATE DATABASE lesson5;
USE lesson5;

CREATE TABLE `values` (
    `value` INT
);

INSERT `values` VALUES (1), (2), (3), (4), (5);

SELECT * FROM `values`;

-- https://stackoverflow.com/questions/30665719/how-to-multiply-all-values-within-a-column-with-sql-like-sum
SELECT ROUND(EXP(SUM(LOG(value))),1)
FROM `values`;