/*
В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
0, если товар закончился и выше нуля, если на складе имеются запасы. 
Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
Однако, нулевые запасы должны выводиться в конце, после всех записей.
*/

/* Подготовка к заданию. Создание БД и Таблицы User */

DROP DATABASE IF EXISTS geekbrains;
CREATE DATABASE IF NOT EXISTS geekbrains;

USE geekbrains;

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products 
	(storehouse_id, product_id, `value`)
VALUES
	(101, 1001, 0),
    (102, 1003, 2500),
    (103, 1002, 0),
    (104, 1004, 30),
    (105, 1006, 500),
    (106, 1011, 1);

SELECT * FROM geekbrains.storehouses_products;

/*
РЕШЕНИЕ
*/
SELECT * FROM storehouses_products ORDER BY `value`=0 ASC, `value` ASC;