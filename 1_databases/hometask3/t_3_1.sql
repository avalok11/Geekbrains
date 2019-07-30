/*
- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
*/

/* Подготовка к заданию. Создание БД и Таблицы User */

CREATE DATABASE IF NOT EXISTS geekbrains;

USE geekbrains;

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

-- добавление путые полей в таблицы users
insert users (name, birthday_at, created_at, updated_at)
	value ('alex', '1990-01-01', Null, Null),
    ('ivan', '1990-01-01', Null, Null),
    ('petr', '1990-01-01', Null, Null),
    ('andry', '1990-01-01', Null, Null);
-- проверка записи
SELECT * FROM geekbrains.users;

/*
РЕШЕНИЕ
*/
update users set created_at=NOW(), updated_at=NOW() where created_at is NULL AND updated_at is NULL;
SELECT * FROM geekbrains.users;
