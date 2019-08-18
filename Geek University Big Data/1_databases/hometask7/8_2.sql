/*
В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
При попытке присвоить полям NULL-значение необходимо отменить операцию.
*/

/*
Подготовка БД
*/

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name NVARCHAR(255) COMMENT 'Название',
  description TEXT CHARACTER SET utf8 COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1);

/*
РЕШЕНИЕ
*/

DROP TRIGGER IF EXISTS null_limitation;
delimiter //

CREATE TRIGGER null_limitation BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF (NEW.name IS NULL) AND (NEW.description IS NULL) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'тук тук INSERT canceled';
	END IF;
END//

delimiter ;

/*
ПРОВЕРКА
*/

SELECT * FROM products;

-- name and descriptions are nut nulls
INSERT INTO products (name, description, price, catalog_id)
	VALUE
    ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
	('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1);

-- name is null
INSERT INTO products (description, price, catalog_id)
	VALUE
    ('Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
	('Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1);
INSERT INTO products (name, price, catalog_id)
	VALUE
    ('Intel Core i3-8101', 7890.00, 1),
	('Intel Core i3-8102', 12700.00, 1);
SELECT * FROM products;

-- name and description are nulls
INSERT INTO products (price, catalog_id)
	VALUE
    (7890.00, 1),
	(12700.00, 1);

