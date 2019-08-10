/*
Тема “Сложные запросы”

(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.
*/

/*
подготовка БД
*/

DROP DATABASE IF EXISTS geekbrains;
CREATE DATABASE IF NOT EXISTS geekbrains;

USE geekbrains;

-- таблица продуктов
DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(255) COMMENT 'Город вылета, на Английском',
  `to` VARCHAR(255) COMMENT 'Город прилета, на Английском'
) COMMENT = 'Самолетные рейсы';
INSERT INTO flights
  (`from`, `to`)
VALUES
  ('moscow', 'omsk'),
  ('novgorod', 'kazan'),
  ('irkutsk', 'moscow'),
  ('omsk', 'irkutsk'),
  ('moscow', 'kazan');

-- каталог продуктов
DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  label VARCHAR (255) UNIQUE NOT NULL PRIMARY KEY COMMENT 'Английское название города, уникальное',
  name NVARCHAR(255) COMMENT 'Русское название города',
  UNIQUE unique_name(name(10))
) COMMENT = 'Список городов';
INSERT INTO cities 
	(label, name)
VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');

/*
РЕШЕНИЕ
*/

SELECT a.ru_from, b.ru_to
FROM
	(SELECT id, c.name ru_from
		FROM flights f
		LEFT JOIN cities c ON f.from=c.label) a
	INNER JOIN
	(SELECT id, c.name ru_to
		FROM flights f
		LEFT JOIN cities c ON f.to=c.label) b ON a.id=b.id