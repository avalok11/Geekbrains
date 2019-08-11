/*
Создайте двух пользователей которые имеют доступ к базе данных shop. 
Первому пользователю shop_read должны быть доступны только запросы на чтение данных, второму пользователю shop — любые операции в пределах базы данных shop.
*/

/*
подгтовка БД
*/
DROP DATABASE IF EXISTS shop;
CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name NVARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
  
  /*
  РЕШЕНИЕ
  */
  DROP USER IF EXISTS shop;
  DROP USER IF EXISTS shop_read;
  
  CREATE USER IF NOT EXISTS shop IDENTIFIED WITH mysql_native_password BY 'pass';
  CREATE USER IF NOT EXISTS shop_read IDENTIFIED WITH mysql_native_password BY 'pass2';
  
  GRANT SELECT ON shop.* TO 'shop_read'@'%';
  GRANT ALL ON shop.* TO 'shop'@'%';
  
  
