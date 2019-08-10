/*
Тема “Сложные запросы”

Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
*/

/*
подготовка БД
*/

DROP DATABASE IF EXISTS geekbrains;
CREATE DATABASE IF NOT EXISTS geekbrains;

USE geekbrains;

-- таблица зарегистрированных пользователей
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

-- таблица заказов
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';
INSERT INTO orders (user_id) VALUES
	(1),
    (2),
    (3),
    (1),
    (1);

-- корзина продуктов в заказе
DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';
INSERT INTO orders_products (order_id, product_id, total) VALUES
	(1,1,10),
    (2,1,10),
    (3,2,1),
    (4,4,5),
    (5,3,3);


/*
РЕШЕНИЕ
*/
SELECT name 
	FROM users u
    INNER JOIN orders o ON u.id=o.user_id
    INNER JOIN orders_products op ON op.order_id=o.id
    WHERE op.total>0