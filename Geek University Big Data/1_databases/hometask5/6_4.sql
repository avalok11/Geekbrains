/*
(по желанию) Пусть имеется любая таблица с календарным полем created_at. 
Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
*/

/*
Подготовка БД
*/
DROP DATABASE IF EXISTS geekbrains;
CREATE DATABASE IF NOT EXISTS geekbrains;
USE geekbrains;

DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl (
  id SERIAL PRIMARY KEY,
  created_at DATE
) COMMENT = 'Прост';

INSERT INTO tbl (created_at) VALUES
  ('2019-08-05'),
  ('2019-08-06'),
  ('2019-08-07'),
  ('2019-08-08'),
  ('2019-01-15'),
  ('2019-06-12'),
  ('2019-05-13'),
  ('2019-07-22');

SELECT * FROM tbl ORDER BY created_at;
  
/*
РЕШЕНИЕ
*/
DELETE FROM tbl 
	WHERE created_at<   (SELECT created_at 
						FROM
							(SELECT created_at FROM tbl 
							ORDER BY created_at DESC
							LIMIT 5) a
						ORDER BY created_at
						LIMIT 1);

SELECT * FROM tbl;