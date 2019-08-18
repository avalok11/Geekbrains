/*
Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
*/


-- создаем два хеша
student@Ubuntu-MySQL-VirtualBox:~$ mongo
MongoDB shell version: 3.2.22
connecting to: test
> version()
3.2.22
> show dbs
local  0.000GB
> use shop
switched to db shop
> db.shop.insert({category: 'Процессоры', products: {name: 'Intel Core i3-8100', description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', price :'7890.00'}})
> db.shop.insert({category: 'Материнские платы', products: {name: 'ASUS ROG MAXIMUS X HERO', description: 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', price :'19310.00'}})
> db.shop.find()
{ "_id" : ObjectId("5d592af5cbaf694c4f5088b5"), "category" : "Материнские платы", "products" : { "name" : "ASUS ROG MAXIMUS X HERO", "description" : "Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX", "price" : "19310.00" } }
{ "_id" : ObjectId("5d592b4fcbaf694c4f5088b6"), "category" : "Процессоры", "products" : { "name" : "Intel Core i3-8100", "description" : "Процессор для настольных персональных компьютеров, основанных на платформе Intel.", "price" : "7890.00" } }








