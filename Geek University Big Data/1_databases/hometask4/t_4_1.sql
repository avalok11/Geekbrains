/*
Подсчитайте средний возраст пользователей в таблице users
*/

/* Подготовка к заданию.*/

CREATE DATABASE IF NOT EXISTS geekbrains;

USE geekbrains;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name NVARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME default CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

SELECT * FROM geekbrains.users;
-- describe geekbrains.users;

/*
РЕШЕНИЕ
*/
SELECT ROUND(AVG(DATEDIFF(now(),birthday_at)/365.25),2) avarage_years
	FROM users;
/* или немного не точное решение */
SELECT ROUND(AVG(YEAR(NOW())-YEAR(birthday_at)),2) avarage_years
	FROM users;

