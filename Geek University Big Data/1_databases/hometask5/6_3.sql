/*
(по желанию) Пусть имеется таблица с календарным полем created_at. 
В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.


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
  ('2018-08-05'),
  ('2018-08-15'),
  ('2018-08-12'),
  ('2018-08-13'),
  ('2018-08-22');
  
/*
РЕШЕНИЕ
*/
DROP TABLE IF EXISTS temp;
CREATE TEMPORARY TABLE temp (august DATE);

DROP PROCEDURE IF EXISTS doWhile;
DELIMITER $$  
CREATE PROCEDURE doWhile()   
BEGIN
DECLARE i DATE DEFAULT '2018-08-01'; 
WHILE (i <= '2018-08-31') DO
    INSERT INTO `temp` (august) values (i);
    SET i = DATE_ADD(i, INTERVAL 1 DAY);
END WHILE;
END;
$$  
CALL doWhile(); 
DROP PROCEDURE IF EXISTS doWhile;

SELECT * FROM temp ORDER BY august;
SELECT * FROM tbl ORDER BY created_at;

SELECT august,
CASE
    WHEN created_at IS NOT NULL THEN 1
    ELSE 0
END creted_att
FROM temp
LEFT JOIN tbl ON temp.august=tbl.created_at
ORDER BY august;