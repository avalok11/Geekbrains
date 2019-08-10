/*
В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
*/

/*
ПОдготовка БД
*/
DROP DATABASE IF EXISTS shop;
CREATE DATABASE IF NOT EXISTS shop;
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
SELECT * FROM users;

DROP DATABASE IF EXISTS sample;
CREATE DATABASE IF NOT EXISTS sample;
USE sample;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name NVARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Алексей', '1970-03-01'),
  ('Андрей', '1964-12-11'),
  ('Валерий', '1955-01-23'),
  ('Леонид', '1987-03-17');
SELECT * FROM users;
  
/*
РЕШЕНИЕ
*/
START TRANSACTION;

UPDATE 
	sample.users,
    shop.users
SET 
	sample.users.name=shop.users.name, 
    sample.users.birthday_at=shop.users.birthday_at,
    sample.users.created_at=shop.users.created_at,
    sample.users.updated_at=shop.users.updated_at
WHERE
	sample.users.id=shop.users.id and sample.users.id=1;
SELECT * FROM sample.users;
COMMIT;
SELECT * FROM sample.users;


