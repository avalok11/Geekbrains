/*
Создайте таблицу logs типа Archive. 
Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и 
дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.
*/

/*
Подготовка БД
*/
DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;
USE shop;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name NVARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';
INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');
  
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
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name NVARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';
INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');



/*
РЕШЕНИЕ
*/
USE shop;

DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs` (
	inserted_at DATETIME COMMENT 'Время добавления записис',
    `table_name` VARCHAR(25) COMMENT 'Название таблицы',
    id_records INT COMMENT 'номер id  в исходной таблице',
    `name` NVARCHAR(255) COMMENT 'поле name в исходной таблице'
	) Engine=Archive;

DROP TRIGGER IF EXISTS log_users;
DROP TRIGGER IF EXISTS log_products;
DROP TRIGGER IF EXISTS log_catalogs;

delimiter //
CREATE TRIGGER log_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO shop.logs (inserted_at, `table_name`, id_records, `name`)
		VALUE (NOW(), 'users', NEW.id, NEW.`name`);
END//
CREATE TRIGGER log_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO shop.logs (inserted_at, `table_name`, id_records, `name`)
		VALUE (NOW(), 'products', NEW.id, NEW.`name`);
END//
CREATE TRIGGER log_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO shop.logs (inserted_at, `table_name`, id_records, `name`)
		VALUE (NOW(), 'users', NEW.id, NEW.`name`);
END//

delimiter ;

/*
ПРОВЕРКА
*/
select * from logs;

INSERT INTO users (name, birthday_at) VALUES
  ('Тест Мария', '1992-08-29');
INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Тест MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);
INSERT INTO catalogs VALUES
  (NULL, 'Тест 2 Оперативная память');

select * from logs;




