/*
Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
*/

/*
РЕШЕНИЕ
*/

USE geekbrains;

DROP FUNCTION IF EXISTS hello;

delimiter //
CREATE FUNCTION hello ()
RETURNS NVARCHAR(25) NOT DETERMINISTIC
BEGIN
	CASE
		WHEN (TIME(NOW())>'18:00') THEN RETURN 'Добрый вечер';
		WHEN (TIME(NOW())>'12:00') THEN RETURN 'Добрый день';
		WHEN (TIME(NOW())>'06:00') THEN RETURN 'Доброе утро';
		ELSE RETURN 'Доброй ночи';
	END CASE;
END//

delimiter ;

SELECT hello() as 'Приветствие';
