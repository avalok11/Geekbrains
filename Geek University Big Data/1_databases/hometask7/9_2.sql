/*
(по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
*/

/*
Подготовка БД
*/
DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;
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
  
/*
РЕШЕНИЕ
*/
USE shop;

DROP FUNCTION IF EXISTS insert_b;

delimiter \\
CREATE FUNCTION insert_b ()
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
	DECLARE i INT DEFAULT 1;
    DECLARE limiti INT DEFAULT 3;
    cycle: WHILE i<=limiti DO
		IF i > 1000001 THEN LEAVE cycle;
        END IF;
		INSERT INTO users (`name`, birthday_at)
			VALUE ('Геннадий2', '1990-10-05');
		SET i = i + 1;
    END WHILE cycle;
    RETURN CONCAT(limiti, ' records were inserted to users');
END\\

delimiter ;



