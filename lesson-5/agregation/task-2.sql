--
-- Подсчитайте количество дней рождения, которые приходятся на
-- каждый из дней недели. Следует учесть, что необходимы дни недели
-- текущего года, а не года рождения.
--

SELECT YEAR(NOW()), MONTH(NOW()), DAY(NOW());

-- https://www.w3resource.com/slides/mysql-date-and-time-functions-slides-presentation.php
DATE_FORMAT()
SELECT DATE_FORMAT('2008-05-15 22:23:00', '%W');
-- https://stackoverflow.com/questions/3960049/create-date-from-day-month-year-fields-in-mysql