/*
(по желанию) Подсчитайте произведение чисел в столбце таблицы
*/

/* Подготовка к заданию.*/

CREATE DATABASE IF NOT EXISTS geekbrains;

USE geekbrains;

DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl (
  id SERIAL PRIMARY KEY,
  valuee int COMMENT 'Количество чегото'
) COMMENT = 'Прост';

INSERT INTO tbl (valuee) VALUES
  (1),
  (2),
  (3),
  (4),
  (5);

SELECT * FROM geekbrains.tbl;
-- describe geekbrains.users;

/*
РЕШЕНИЕ
*/
select ROUND(exp(SUM(ln(valuee))),0)
	from tbl;


