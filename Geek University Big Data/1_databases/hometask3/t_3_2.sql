/*
Таблица users была неудачно спроектирована. 
Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". 
Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

*/

/* Подготовка к заданию. Создание БД и Таблицы User */

CREATE DATABASE IF NOT EXISTS geekbrains;

USE geekbrains;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name NVARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(25),
  updated_at VARCHAR(25)
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05', '20.11.2017 8:10', '25.10.2017 8:10'),
  ('Наталья', '1984-11-12', '21.10.2017 8:10', '21.05.2017 8:10'),
  ('Александр', '1985-05-20', '20.10.2017 8:10', '20.10.2017 8:10'),
  ('Сергей', '1988-02-14', '20.10.2017 8:10', '20.10.2017 8:10'),
  ('Иван', '1998-01-12', '20.10.2017 8:10', '20.10.2017 8:10'),
  ('Мария', '1992-08-29', '20.10.2017 8:10', '20.10.2017 8:10');

SELECT * FROM geekbrains.users;
describe geekbrains.users;

-- select DATE_FORMAT(str_to_date(created_at, '%d.%m.%Y %H:%i'),'%Y-%h-%m %H:%i') from users;
/*
РЕШЕНИЕ
*/
ALTER TABLE users ADD created_at_temp DATETIME, ADD updated_at_temp DATETIME;
UPDATE users SET 
    created_at_temp=DATE_FORMAT(str_to_date(created_at, '%d.%m.%Y %H:%i'),'%Y-%m-%d %H:%i'), 
    updated_at_temp=DATE_FORMAT(str_to_date(updated_at, '%d.%m.%Y %H:%i'),'%Y-%m-%d %H:%i');
ALTER TABLE users DROP COLUMN created_at, DROP COLUMN updated_at;
SELECT * FROM geekbrains.users;
describe geekbrains.users;