/*
(по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ, имя пользователя и его пароль. 
Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. 
Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.

*/

/*
подгтовка БД
*/
DROP DATABASE IF EXISTS geekbrains;
CREATE DATABASE IF NOT EXISTS geekbrains;
USE geekbrains;

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  `name` NVARCHAR(255) COMMENT 'Имя пользователя',
  `password` NVARCHAR(255) COMMENT 'Пароль'
) COMMENT = 'Таблица';

INSERT INTO accounts (`name`, `password`) VALUES
  ('user1', 'pass1'),
  ('user2', 'pass2');
  
  
  /*
  РЕШЕНИЕ
  */
  
CREATE VIEW user_read 
	AS
    SELECT id, name FROM accounts;
    
SELECT * FROM user_read;

CREATE USER user_read IDENTIFIED WITH mysql_native_password BY 'pass';
GRANT SELECT ON geekbrains.user_read TO 'user_read'@'%';
  
