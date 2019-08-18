/*
(по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
Вызов функции FIBONACCI(10) должен возвращать число 55.
*/


/*
РЕШЕНИЕ
*/
USE geekbrains;

DROP FUNCTION IF EXISTS fiba;

delimiter //
CREATE FUNCTION fiba (value INT)
RETURNS BIGINT NOT DETERMINISTIC
BEGIN
	DECLARE fiba_result, fiba_prev_prev BIGINT DEFAULT 0;
    DECLARE fiba_prev BIGINT DEFAULT 1;
    DECLARE i INT DEFAULT 2; 
    IF (value < 0) OR (value > 92) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Wrong number, try again';
    ELSEIF value = 0 THEN RETURN 0;
    ELSEIF value = 1 THEN RETURN 1;
    ELSE
		cycle : WHILE i <= value DO
			IF i > 92 THEN LEAVE cycle; 
            END IF;
            SET fiba_result = fiba_prev_prev + fiba_prev;
            SET fiba_prev_prev = fiba_prev;
            SET fiba_prev = fiba_result;
            SET i = i + 1;
		END WHILE cycle;
	END IF;
    RETURN fiba_result;
END//

delimiter ;



