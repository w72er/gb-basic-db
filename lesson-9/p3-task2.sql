-- Практическое задание по теме "Хранимые процедуры и функции,
-- триггеры"

-- 2. В таблице products есть два текстовых поля: name с названием
-- товара и description с его описанием. Допустимо присутствие обоих
-- полей или одно из них. Ситуация, когда оба поля принимают
-- неопределенное значение NULL неприемлема. Используя триггеры,
-- добейтесь того, чтобы одно из этих полей или оба поля были
-- заполнены. При попытке присвоить полям NULL-значение необходимо
-- отменить операцию.

-- INSERT
-- DELETE
-- Which restrictions for columns name and description?
--   name VARCHAR(255) COMMENT 'Название',
--   description TEXT COMMENT 'Описание',

DELIMITER //
DROP TRIGGER IF EXISTS check_name_or_description_not_null_when_insert//
CREATE TRIGGER check_name_or_description_not_null_when_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF (NEW.name IS NULL AND NEW.description IS NULL) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'name or description should be not null';
    END IF;
END//

DROP TRIGGER IF EXISTS check_name_or_description_not_null_when_update//
CREATE TRIGGER check_name_or_description_not_null_when_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
	IF (NEW.name IS NULL AND NEW.description IS NULL) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'name or description should be not null';
    END IF;
END//

DELIMITER ; -- if without this, it will not create trigger

INSERT products (name, description, price, catalog_id) VALUES
('Intel Core i9-10900F', 'LGA 1200, 10 x 2800 МГц, L2 - 2.5 МБ, L3 - 20 МБ, 2хDDR4-2933 МГц, TDP 65 Вт', 29999, 1);

-- raises error
-- INSERT products (price, catalog_id) VALUES (49999, 1);

DELETE FROM products WHERE id = 200;
INSERT products (id, name, description, price, catalog_id) VALUES
(200, 'Intel Core i9-10900F', 'LGA 1200, 10 x 2800 МГц, L2 - 2.5 МБ, L3 - 20 МБ, 2хDDR4-2933 МГц, TDP 65 Вт', 29999, 1);

UPDATE products
SET
    name = NULL
WHERE id = 200;

-- raises error
UPDATE products
SET
    description = NULL
WHERE id = 200;

