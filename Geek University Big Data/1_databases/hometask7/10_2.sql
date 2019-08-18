/*
При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.
*/

/* Создаем коллекционный тип данных. С ключом вида user:'name':'email' */

-- создаем два хеша
127.0.0.1:6379> HSET user:alexey:ivanov@ayndex.ru name AlexeyI email ivanov@yandex.ru
(integer) 1
127.0.0.1:6379> HSET user:alexey:alexey@ayndex.ru name Alexey email alexey@yandex.ru
(integer) 1

-- первый шаг посик ключа по маске или Имя или Емейл
127.0.0.1:6379> KEYS user:*:ivanov@ayndex.ru
1) "user:alexey:ivanov@ayndex.ru"
127.0.0.1:6379> KEYS user:alexey:*
1) "user:alexey:ivanov@ayndex.ru"
2) "user:alexey:alexey@ayndex.ru"
-- вторым шагом получение требуемого значения
127.0.0.1:6379> HGET user:alexey:alexey@ayndex.ru name
"Alexey"




